import 'package:fpdart/fpdart.dart' hide Order;

import '../../app/app.locator.dart';
import '../../models/api_response.dart';
import '../../models/cancel_reason.dart';
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
    return ApiResponse.mock(Paginated.fromBody(
        res.data as Map<String, dynamic>, Order.fromJson, page));
  }

  Future<ApiResponse<Order>> fetchOrder(int id) async {
    final res = await _dio.get(ApiEndpoints.order(id));
    return ApiResponse<Order>.fromJson(res.data as Map<String, dynamic>,
        res.statusCode!, (d) => Order.fromJson(d as Map<String, dynamic>));
  }

  /// [kind] is `delivery_service` for a parcel — its six reasons differ from a
  /// product order's nine.
  Future<ApiResponse<List<CancelReason>>> fetchCancelReasons(
      {String? kind}) async {
    final res = await _dio.get(ApiEndpoints.cancelReasons,
        queryParameters: {if (kind != null) 'kind': kind});
    return ApiResponse<List<CancelReason>>.fromJson(
      res.data as Map<String, dynamic>,
      res.statusCode!,
      (d) => (d as List)
          .map((e) => CancelReason.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// POST /orders/:id/items/unavailable — names the units the shop cannot
  /// supply. The server tells the customer and works out the money.
  Future<ApiResponse<Unit>> reportUnavailable(
    int id, {
    required Map<int, int> quantities,
    String? note,
  }) async {
    await _dio.post(ApiEndpoints.unavailableItems(id), data: {
      'items': [
        for (final e in quantities.entries)
          {'orderItemId': e.key, 'quantity': e.value},
      ],
      if (note != null && note.isNotEmpty) 'note': note,
    });
    return ApiResponse.mock(unit);
  }

  /// POST /orders/:id/refund-bank-details — the account Santra refunds a
  /// shop-entered order into. Write-only: the IBAN is never read back.
  Future<ApiResponse<Unit>> submitRefundBankDetails(
    int id, {
    required String accountName,
    required String iban,
  }) async {
    await _dio.post(ApiEndpoints.refundBankDetails(id),
        data: {'accountName': accountName, 'iban': iban});
    return ApiResponse.mock(unit);
  }

  /// PATCH /orders/:id/status — the only order mutation the partner API exposes.
  /// `status` ∈ confirmed | preparing | ready | cancelled. When cancelling,
  /// `cancelReason` is a code from [fetchCancelReasons] and `note` the
  /// partner's own words; both optional at the API today.
  Future<ApiResponse<Unit>> changeStatus(
    int id, {
    required String status,
    String? cancelReason,
    String? note,
    String? courierStage,
  }) async {
    await _dio.patch(ApiEndpoints.orderStatus(id), data: {
      'status': status,
      if (cancelReason != null && cancelReason.isNotEmpty)
        'cancelReason': cancelReason,
      if (note != null && note.isNotEmpty) 'note': note,
      // The stage the shop was shown; the API rejects a stale one.
      if (courierStage != null) 'courierStage': courierStage,
    });
    return ApiResponse.mock(unit);
  }
}
