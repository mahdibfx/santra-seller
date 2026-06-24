import 'package:fpdart/fpdart.dart';

import '../../models/api_response.dart';
import 'api_endpoints.dart';

/// Auth HTTP layer.
///
/// STUB: every method returns a mocked [ApiResponse] so the app runs without a
/// backend. The commented block in each method is the exact `Dio` call the
/// backend dev should restore — it documents verb, path, request body, and the
/// expected response envelope.
class ApiAuthService {
  // Restore once the backend exists:
  // final _dio = locator<DioService>().dio;

  /// POST [ApiEndpoints.requestOtp]
  /// Request:  `{ "phone": "+9715XXXXXXXX" }`
  /// Response: `{ "success": true, "message": "OTP sent", "data": null }`
  Future<ApiResponse<Unit>> requestOtp({required String phone}) async {
    // final res = await _dio.post(ApiEndpoints.requestOtp, data: {'phone': phone});
    // return ApiResponse<Unit>.fromJson(res.data as Map<String, dynamic>, res.statusCode!, (_) => unit);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return ApiResponse<Unit>.mock(unit, message: 'OTP sent');
  }

  /// POST [ApiEndpoints.verifyOtp]
  /// Request:  `{ "phone": "+9715XXXXXXXX", "code": "1234" }`
  /// Response: `{ "success": true, "data": { "token": "<jwt>" } }`
  ///   On bad code → HTTP 422 `{ "errors": { "code": ["Invalid code"] } }`.
  Future<ApiResponse<String>> verifyOtp({required String phone, required String code}) async {
    // final res = await _dio.post(ApiEndpoints.verifyOtp, data: {'phone': phone, 'code': code});
    // return ApiResponse<String>.fromJson(res.data as Map<String, dynamic>, res.statusCode!, (d) => d['token'] as String);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return ApiResponse<String>.mock('mock-jwt-token');
  }

  /// POST [ApiEndpoints.forgotPassword]
  /// Request:  `{ "phone": "+9715XXXXXXXX" }`
  /// Response: `{ "success": true, "message": "Reset code sent" }`
  Future<ApiResponse<Unit>> forgotPassword({required String phone}) async {
    // final res = await _dio.post(ApiEndpoints.forgotPassword, data: {'phone': phone});
    // return ApiResponse<Unit>.fromJson(res.data as Map<String, dynamic>, res.statusCode!, (_) => unit);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return ApiResponse<Unit>.mock(unit, message: 'Reset code sent');
  }

  /// POST [ApiEndpoints.resetPassword]
  /// Request:  `{ "phone": "+9715XXXXXXXX", "code": "1234", "password": "<new>" }`
  /// Response: `{ "success": true }`
  ///   Validation → HTTP 422 `{ "errors": { "password": ["Too short"] } }`.
  Future<ApiResponse<Unit>> resetPassword({
    required String phone,
    required String code,
    required String password,
  }) async {
    // final res = await _dio.post(ApiEndpoints.resetPassword,
    //     data: {'phone': phone, 'code': code, 'password': password});
    // return ApiResponse<Unit>.fromJson(res.data as Map<String, dynamic>, res.statusCode!, (_) => unit);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return ApiResponse<Unit>.mock(unit);
  }
}
