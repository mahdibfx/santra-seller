import 'package:dio/dio.dart';

import 'api/api_endpoints.dart';

/// Owns the single [Dio] instance used by every `ApiService`.
///
/// Registered as a lazy singleton in the locator. Interceptors (auth token,
/// logging) are wired here once the backend is ready.
class DioService {
  final Dio dio;

  DioService()
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.base,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            contentType: 'application/json',
            responseType: ResponseType.json,
          ),
        );

  /// Call after login to attach the bearer token to every request.
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}
