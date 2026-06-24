import 'package:fpdart/fpdart.dart';

import '../../models/api_response.dart';
import '../../models/seller_profile.dart';
import '../mock_data.dart';
import 'api_endpoints.dart';

/// Profile HTTP layer (STUB — serves [MockData]).
class ApiProfileService {
  // final _dio = locator<DioService>().dio;

  /// GET [ApiEndpoints.profile]
  /// Response: `{ "success": true, "data": { "store_name": "…",
  ///   "store_name_ar": "…", "avatar": "…", "open_now": true } }`
  Future<ApiResponse<SellerProfile>> fetchProfile() async {
    // final res = await _dio.get(ApiEndpoints.profile);
    // return ApiResponse<SellerProfile>.fromJson(res.data as Map<String, dynamic>, res.statusCode!,
    //     (d) => SellerProfile.fromJson(d as Map<String, dynamic>));
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return ApiResponse<SellerProfile>.mock(MockData.profile);
  }

  /// POST [ApiEndpoints.logout]  → `{ "success": true }`
  Future<ApiResponse<Unit>> logout() async {
    // final res = await _dio.post(ApiEndpoints.logout);
    // return ApiResponse<Unit>.fromJson(res.data as Map<String, dynamic>, res.statusCode!, (_) => unit);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return ApiResponse<Unit>.mock(unit);
  }
}
