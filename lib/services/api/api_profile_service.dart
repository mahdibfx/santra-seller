import 'package:fpdart/fpdart.dart';

import '../../app/app.locator.dart';
import '../../models/api_response.dart';
import '../../models/seller_profile.dart';
import '../dio_service.dart';
import '../token_service.dart';
import 'api_endpoints.dart';

class ApiProfileService {
  final _dio = locator<DioService>().dio;

  Future<ApiResponse<SellerProfile>> fetchProfile() async {
    final res = await _dio.get(ApiEndpoints.profile); // GET /me
    return ApiResponse<SellerProfile>.fromJson(
        res.data as Map<String, dynamic>, res.statusCode!, (d) => SellerProfile.fromJson(d as Map<String, dynamic>));
  }

  Future<ApiResponse<Unit>> logout() async {
    final refresh = locator<TokenService>().refreshToken ?? '';
    await _dio.post(ApiEndpoints.logout, data: {'refreshToken': refresh});
    return ApiResponse.mock(unit);
  }
}
