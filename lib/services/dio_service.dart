import 'package:dio/dio.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';
import '../models/auth_tokens.dart';
import 'api/api_endpoints.dart';
import 'token_service.dart';
import 'version_check.dart';

/// What came back from `/auth/refresh`. The three are NOT interchangeable:
/// only [rejected] means the session is over and the shop should be signed
/// out. [unavailable] means we never found out.
class RefreshResult {
  const RefreshResult.refreshed(this.token) : rejected = false;
  const RefreshResult.rejected()
      : token = null,
        rejected = true;
  const RefreshResult.unavailable()
      : token = null,
        rejected = false;

  final String? token;
  final bool rejected;
}

class DioService {
  final Dio dio;

  /// Single-flight guard: concurrent 401s share one refresh call.
  Future<RefreshResult>? _refreshing;

  DioService()
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.base,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            contentType: 'application/json',
            responseType: ResponseType.json,
          ),
        ) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (opts, handler) {
        opts.headers['x-app-version'] = VersionCheck.current;
        handler.next(opts);
      },
      onError: (error, handler) async {
        final opts = error.requestOptions;
        final is401 = error.response?.statusCode == 401;
        final isAuthCall = opts.path.contains('/auth/'); // don't refresh on login/refresh/logout
        final alreadyRetried = opts.extra['retried'] == true;

        if (is401 && !isAuthCall && !alreadyRetried) {
          final outcome = await _refresh();
          final token = outcome.token;
          if (token != null) {
            // Replay the original request once with the new token.
            opts.headers['Authorization'] = 'Bearer $token';
            opts.extra['retried'] = true;
            try {
              return handler.resolve(await dio.fetch(opts));
            } on DioException catch (e) {
              return handler.next(e);
            }
          }
          // Only a REFUSED refresh means the session is over. When Santra
          // could not tell us (503, a timeout, no network), the refresh token
          // was not spent — signing the shop out over that is how an order
          // board goes blank mid-service.
          if (outcome.rejected) _forceLogout();
        }
        handler.next(error);
      },
    ));
  }

  /// Exchanges the stored refresh token for a new access token.
  Future<RefreshResult> _refresh() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  /// Backend, 6 Oct 2026: `503 REFRESH_UNAVAILABLE` carries `Retry-After` and
  /// means the session could NOT be checked — the refresh token was not used,
  /// so the same one is sent again after the wait. A `500` is never retried:
  /// the token may already be spent, and sending it twice reads as theft and
  /// signs the shop out of every device.
  Future<RefreshResult> _doRefresh({int attempt = 0}) async {
    final tokenService = locator<TokenService>();
    final refreshToken = tokenService.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return const RefreshResult.rejected();
    }
    try {
      // A bare Dio so the refresh call itself doesn't re-enter this interceptor.
      final res = await Dio(BaseOptions(baseUrl: ApiEndpoints.base, contentType: 'application/json'))
          .post(ApiEndpoints.refresh, data: {'refreshToken': refreshToken});
      final tokens = AuthTokens.fromJson(res.data as Map<String, dynamic>);
      if (tokens.accessToken.isEmpty) return const RefreshResult.rejected();
      await tokenService.saveTokens(
        tokens.accessToken,
        tokens.refreshToken.isEmpty ? refreshToken : tokens.refreshToken,
      );
      return RefreshResult.refreshed(tokens.accessToken);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401) return const RefreshResult.rejected();
      if (status == 503 && attempt < _maxRefreshRetries) {
        await Future<void>.delayed(retryAfter(e.response?.headers.value('retry-after')));
        return _doRefresh(attempt: attempt + 1);
      }
      // 500, a timeout, no network, or a 503 we have waited on long enough:
      // the session may well be fine, so keep the tokens and fail this one
      // request instead of ending the shop's day.
      return const RefreshResult.unavailable();
    } catch (_) {
      return const RefreshResult.unavailable();
    }
  }

  static const _maxRefreshRetries = 3;

  /// `Retry-After` in seconds, clamped: the header is the server's, and a
  /// wrong or hostile value must not park the app for an hour.
  static Duration retryAfter(String? header) {
    final seconds = int.tryParse(header?.trim() ?? '') ?? 15;
    return Duration(seconds: seconds.clamp(1, 60));
  }

  void _forceLogout() {
    locator<TokenService>().clearToken();
    locator<NavigationService>().clearStackAndShow(Routes.welcomeView);
  }

  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}
