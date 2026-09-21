import 'package:fpdart/fpdart.dart' hide Order;

import '../../app/app.locator.dart';
import '../../models/api_response.dart';
import '../../models/order.dart';
import '../../models/paginated.dart';
import '../dio_service.dart';
import 'api_endpoints.dart';

class ApiOrdersService {
  final _dio = locator<DioService>().dio;

  Future<ApiResponse<Paginated<Order>>> fetchOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? search,
    String? dateFrom,
    String? dateTo,
  }) async {
    final res = await _dio.get(ApiEndpoints.orders, queryParameters: {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      if (search != null && search.isNotEmpty) 'search': search,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    });
    return ApiResponse.mock(
        Paginated.fromBody(res.data as Map<String, dynamic>, Order.fromJson, page));
  }

  Future<ApiResponse<Order>> fetchOrder(int id) async {
    final res = await _dio.get(ApiEndpoints.order(id));
    return ApiResponse<Order>.fromJson(
        res.data as Map<String, dynamic>, res.statusCode!, (d) => Order.fromJson(d as Map<String, dynamic>));
  }

  /// PATCH /orders/:id/status — the only order mutation the partner API exposes.
  /// `status` ∈ confirmed | preparing | ready | cancelled. `note` is required
  /// by policy when cancelling.
  Future<ApiResponse<Unit>> changeStatus(int id, {required String status, String? note}) async {
    await _dio.patch(ApiEndpoints.orderStatus(id), data: {
      'status': status,
      if (note != null && note.isNotEmpty) 'note': note,
    });
    return ApiResponse.mock(unit);
  }
}
