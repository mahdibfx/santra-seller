import 'package:dio/dio.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';
import '../models/auth_tokens.dart';
import 'api/api_endpoints.dart';
import 'token_service.dart';
import 'version_check.dart';

class DioService {
  final Dio dio;

  /// Single-flight guard: concurrent 401s share one refresh call.
  Future<String?>? _refreshing;

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
          final token = await _refresh();
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
          _forceLogout();
        }
        handler.next(error);
      },
    ));
  }

  /// Exchanges the stored refresh token for a new access token.
  /// Returns the new access token, or null if refresh isn't possible.
  Future<String?> _refresh() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<String?> _doRefresh() async {
    final tokenService = locator<TokenService>();
    final refreshToken = tokenService.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return null;
    try {
      // A bare Dio so the refresh call itself doesn't re-enter this interceptor.
      final res = await Dio(BaseOptions(baseUrl: ApiEndpoints.base, contentType: 'application/json'))
          .post(ApiEndpoints.refresh, data: {'refreshToken': refreshToken});
      final tokens = AuthTokens.fromJson(res.data as Map<String, dynamic>);
      if (tokens.accessToken.isEmpty) return null;
      await tokenService.saveTokens(
        tokens.accessToken,
        tokens.refreshToken.isEmpty ? refreshToken : tokens.refreshToken,
      );
      return tokens.accessToken;
    } catch (_) {
      return null;
    }
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
