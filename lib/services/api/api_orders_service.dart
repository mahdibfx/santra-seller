import 'package:fpdart/fpdart.dart' hide Order;

import '../../models/api_response.dart';
import '../../models/order.dart';
import '../../models/order_status.dart';
import '../mock_data.dart';
import 'api_endpoints.dart';

/// Orders HTTP layer (STUB — serves [MockData], documents the real contract).
class ApiOrdersService {
  // final _dio = locator<DioService>().dio;

  /// GET [ApiEndpoints.orders]  (optional `?status=pending`)
  /// Response: `{ "success": true, "data": { "orders": [ <order>, ... ] } }`
  /// where each `<order>` is:
  /// ```json
  /// { "id": 1042, "customer": "…", "status": "pending", "total": 245,
  ///   "placed": 8, "deliver": "Today · 6:00 PM", "date": "2026-06-23",
  ///   "payment": "paid", "tags": ["gift"], "due": 78, "sla": 120,
  ///   "items": [ { "name": "…", "ar": "…", "qty": 1, "img": "…" } ],
  ///   "note": "…", "noteAr": "…", "images": ["…"] }
  /// ```
  Future<ApiResponse<List<Order>>> fetchOrders({OrderStatus? status}) async {
    // final res = await _dio.get(ApiEndpoints.orders, queryParameters: {
    //   if (status != null) 'status': status.wire,
    // });
    // return ApiResponse<List<Order>>.fromJson(res.data as Map<String, dynamic>, res.statusCode!,
    //     (d) => (d['orders'] as List? ?? []).map((e) => Order.fromJson(e as Map<String, dynamic>)).toList());
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final all = MockData.orders();
    final data = status == null ? all : all.where((o) => o.status == status).toList();
    return ApiResponse<List<Order>>.mock(data);
  }

  /// GET [ApiEndpoints.order]  → single order (same `<order>` shape above).
  Future<ApiResponse<Order>> fetchOrder(int id) async {
    // final res = await _dio.get(ApiEndpoints.order(id));
    // return ApiResponse<Order>.fromJson(res.data as Map<String, dynamic>, res.statusCode!,
    //     (d) => Order.fromJson(d as Map<String, dynamic>));
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final order = MockData.orders().firstWhere((o) => o.id == id, orElse: () => MockData.orders().first);
    return ApiResponse<Order>.mock(order);
  }

  /// POST [ApiEndpoints.acceptOrder]  → `{ "success": true }`
  Future<ApiResponse<Unit>> acceptOrder(int id) => _mutate();

  /// POST [ApiEndpoints.rejectOrder]
  /// Request:  `{ "reason": "<optional>" }`  → `{ "success": true }`
  Future<ApiResponse<Unit>> rejectOrder(int id, {String? reason}) => _mutate();

  /// POST [ApiEndpoints.advanceOrder]  → moves accepted→on_way→delivered.
  /// Response: `{ "success": true, "data": { "status": "on_way" } }`
  Future<ApiResponse<Unit>> advanceOrder(int id) => _mutate();

  /// DELETE [ApiEndpoints.order]  → `{ "success": true }`
  Future<ApiResponse<Unit>> deleteOrder(int id) => _mutate();

  Future<ApiResponse<Unit>> _mutate() async {
    // final res = await _dio.post(ApiEndpoints.acceptOrder(id));   // (verb/path per method)
    // return ApiResponse<Unit>.fromJson(res.data as Map<String, dynamic>, res.statusCode!, (_) => unit);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return ApiResponse<Unit>.mock(unit);
  }
}
