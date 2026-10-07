import 'package:fpdart/fpdart.dart';

import '../../app/app.locator.dart';
import '../../models/api_response.dart';
import '../../models/seller_profile.dart';
import '../../models/trading.dart';
import '../dio_service.dart';
import '../token_service.dart';
import 'api_endpoints.dart';

class ApiProfileService {
  final _dio = locator<DioService>().dio;

  Future<ApiResponse<SellerProfile>> fetchProfile() async {
    final res = await _dio.get(ApiEndpoints.profile); // GET /me
    return ApiResponse<SellerProfile>.fromJson(
        res.data as Map<String, dynamic>,
        res.statusCode!,
        (d) => SellerProfile.fromJson(d as Map<String, dynamic>));
  }

  /// PATCH /me/trading — `busy` (with minutes, or the string `day`),
  /// `extend` (minutes) or `open`. Answers with the new trading object.
  Future<ApiResponse<Trading>> updateTrading(
      {required String action, Object? minutes}) async {
    final res = await _dio.patch(ApiEndpoints.trading, data: {
      'action': action,
      if (minutes != null) 'minutes': minutes,
    });
    return ApiResponse<Trading>.fromJson(res.data as Map<String, dynamic>,
        res.statusCode!, (d) => Trading.fromJson(d as Map<String, dynamic>));
  }

  /// `GET /content/legal` — the published policy links, EN + AR. Every field
  /// may be null; the caller decides what to do with nothing to open.
  Future<ApiResponse<Map<String, String?>>> fetchLegal() async {
    final res = await _dio.get(ApiEndpoints.legal);
    return ApiResponse<Map<String, String?>>.fromJson(
      res.data as Map<String, dynamic>,
      res.statusCode!,
      (d) {
        final m = (d as Map?) ?? const {};
        String? str(String k) {
          final v = m[k]?.toString().trim();
          return (v == null || v.isEmpty) ? null : v;
        }

        return {
          'privacy': str('privacy_policy_url'),
          'terms': str('terms_conditions_url'),
          'contract': str('seller_contract_url'),
        };
      },
    );
  }

  /// Revokes the refresh token server-side. Best effort by design — the
  /// caller signs out locally whatever this returns.
  ///
  /// Skips the call when there is no token to revoke: the endpoint requires
  /// 20+ characters and answers `VALIDATION_ERROR` to an empty string, which
  /// used to surface as "logout failed" on a session that had nothing left to
  /// revoke anyway.
  Future<ApiResponse<Unit>> logout() async {
    final refresh = locator<TokenService>().refreshToken ?? '';
    if (refresh.length < 20) return ApiResponse.mock(unit);
    await _dio.post(ApiEndpoints.logout, data: {'refreshToken': refresh});
    return ApiResponse.mock(unit);
  }
}
