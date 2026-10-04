import 'package:fpdart/fpdart.dart' hide Order;

import '../app/app.locator.dart';
import '../extensions/api_response_extension.dart';
import '../models/failure.dart';
import '../models/cancel_reason.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/paginated.dart';
import 'api/api_orders_service.dart';

class OrdersService {
  final _api = locator<ApiOrdersService>();

  Future<Either<Failure, Paginated<Order>>> fetchOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
    String? search,
    String? dateFrom,
    String? dateTo,
  }) =>
      _api
          .fetchOrders(
            page: page,
            limit: limit,
            status: status?.wire,
            search: search,
            dateFrom: dateFrom,
            dateTo: dateTo,
          )
          .toEither();

  Future<Either<Failure, Order>> fetchOrder(int id) =>
      _api.fetchOrder(id).toEither();

  // The partner API models every action as a status change.
  Future<Either<Failure, Unit>> acceptOrder(int id) =>
      _api.changeStatus(id, status: 'confirmed').toEither();

  /// [quantities] maps `order_item_id` to the units that are missing.
  Future<Either<Failure, Unit>> reportUnavailable(
    int id, {
    required Map<int, int> quantities,
    String? note,
  }) =>
      _api.reportUnavailable(id, quantities: quantities, note: note).toEither();

  Future<Either<Failure, Unit>> submitRefundBankDetails(
    int id, {
    required String accountName,
    required String iban,
  }) =>
      _api
          .submitRefundBankDetails(id, accountName: accountName, iban: iban)
          .toEither();

  Future<Either<Failure, List<CancelReason>>> fetchCancelReasons(
          {String? kind}) =>
      _api.fetchCancelReasons(kind: kind).toEither();

  /// Cancels an order with a reason code from [fetchCancelReasons] plus the
  /// partner's optional words. There is no DELETE endpoint — cancelling is it.
  Future<Either<Failure, Unit>> cancelOrder(
    int id, {
    required String reasonCode,
    String? note,
    String? courierStage,
  }) =>
      _api
          .changeStatus(id,
              status: 'cancelled',
              cancelReason: reasonCode,
              note: note,
              courierStage: courierStage)
          .toEither();

  /// Moves an order to [to]. Which targets are legal comes from the order's
  /// `allowed_transitions`; the API still rejects anything illegal with 409.
  Future<Either<Failure, Unit>> moveOrder(int id, {required OrderStatus to}) =>
      _api.changeStatus(id, status: to.wire).toEither();
}
