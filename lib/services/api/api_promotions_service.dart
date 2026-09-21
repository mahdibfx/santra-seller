import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../app/app.locator.dart';
import '../../models/api_response.dart';
import '../../models/promotion_request.dart';
import '../dio_service.dart';
import 'api_endpoints.dart';

class ApiPromotionsService {
  final _dio = locator<DioService>().dio;

  Future<ApiResponse<List<PromotionRequest>>> fetchRequests() async {
    final res = await _dio.get(ApiEndpoints.promotionRequests);
    return ApiResponse<List<PromotionRequest>>.fromJson(
        res.data as Map<String, dynamic>, res.statusCode!,
        (d) => (d as List? ?? []).map((e) => PromotionRequest.fromJson(e as Map<String, dynamic>)).toList());
  }

  Future<ApiResponse<PromotionRequest>> fetchRequest(int id) async {
    final res = await _dio.get(ApiEndpoints.promotionRequest(id));
    return ApiResponse<PromotionRequest>.fromJson(res.data as Map<String, dynamic>, res.statusCode!,
        (d) => PromotionRequest.fromJson(d as Map<String, dynamic>));
  }

  /// Answer a request. Send whichever parts the user just did — stock and/or
  /// signature. `fullName` is required by the API when accepting.
  Future<ApiResponse<Unit>> respond(
    int id, {
    String? stock,
    String? stockNote,
    bool? signatureAccept,
    String? fullName,
    String? declineReason,
  }) async {
    await _dio.post(
      ApiEndpoints.respondPromotionRequest(id),
      // x-client tags the audit trail as the app, not the web portal.
      options: Options(headers: {'x-client': 'partner_app'}),
      data: {
        if (stock != null) 'stock': stock,
        if (stockNote != null && stockNote.isNotEmpty) 'stockNote': stockNote,
        if (signatureAccept != null)
          'signature': {'accept': signatureAccept, if (fullName != null) 'fullName': fullName},
        if (declineReason != null && declineReason.isNotEmpty) 'declineReason': declineReason,
      },
    );
    return ApiResponse.mock(unit);
  }
}
