import 'dart:developer';

import 'package:fpdart/fpdart.dart';

import '../../app/app.locator.dart';
import '../../models/api_response.dart';
import '../../models/auth_tokens.dart';
import '../dio_service.dart';
import 'api_endpoints.dart';

class ApiAuthService {
  final _dio = locator<DioService>().dio;

  // ponytail: +971 default kept for callers that never leave the UAE; the
  // login screen passes the picked code.
  Future<ApiResponse<Unit>> requestOtp(
      {required String phone, String countryCode = '+971'}) async {
    final response = await _dio.post(ApiEndpoints.requestOtp,
        data: {'countryCode': countryCode, 'phone': phone});
    log('requestOtp: $countryCode $phone ${response.data}');
    return ApiResponse.mock(
        unit); // 2xx only reaches here; no `data` envelope on auth
  }

  Future<ApiResponse<AuthTokens>> verifyOtp({
    required String phone,
    required String code,
    String countryCode = '+971',
  }) async {
    final res = await _dio.post(ApiEndpoints.verifyOtp,
        data: {'countryCode': countryCode, 'phone': phone, 'code': code});
    return ApiResponse.mock(
        AuthTokens.fromJson(res.data as Map<String, dynamic>));
  }

  Future<ApiResponse<AuthTokens>> refresh(String refreshToken) async {
    final res = await _dio
        .post(ApiEndpoints.refresh, data: {'refreshToken': refreshToken});
    return ApiResponse.mock(
        AuthTokens.fromJson(res.data as Map<String, dynamic>));
  }

  Future<ApiResponse<Unit>> logout(String refreshToken) async {
    await _dio.post(ApiEndpoints.logout, data: {'refreshToken': refreshToken});
    return ApiResponse.mock(unit);
  }

  // ponytail: unsupported by the partner API (OTP-only). Kept so the Forgot
  // screen compiles; will 404 at runtime until that screen is removed.
  Future<ApiResponse<Unit>> forgotPassword({required String phone}) async {
    await _dio.post(ApiEndpoints.forgotPassword, data: {'phone': phone});
    return ApiResponse.mock(unit);
  }

  Future<ApiResponse<Unit>> resetPassword({
    required String phone,
    required String code,
    required String password,
  }) async {
    await _dio.post(ApiEndpoints.resetPassword,
        data: {'phone': phone, 'code': code, 'password': password});
    return ApiResponse.mock(unit);
  }
}
