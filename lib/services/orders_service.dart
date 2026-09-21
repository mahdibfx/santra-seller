import 'package:fpdart/fpdart.dart' hide Order;

import '../app/app.locator.dart';
import '../extensions/api_response_extension.dart';
import '../models/failure.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/paginated.dart';
import 'api/api_orders_service.dart';

class OrdersService {
  final _api = locator<ApiOrdersService>();

  // ponytail: the app's OrderStatus enum (pending/accepted/onWay/…) doesn't
  // match the partner API's (pending/confirmed/preparing/ready/…). Filtering
  // by the app wire returns nothing, and incoming statuses fall back to
  // `pending`. Reconcile OrderStatus with the partner statuses (+ colors,
  // labels, filter rail) so the board reflects real state.
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

  Future<Either<Failure, Order>> fetchOrder(int id) => _api.fetchOrder(id).toEither();

  // The partner API models every action as a status change.
  Future<Either<Failure, Unit>> acceptOrder(int id) =>
      _api.changeStatus(id, status: 'confirmed').toEither();

  // ponytail: API requires a note when cancelling. The reject sheet only
  // returns a yes/no, so we default one. Collect a real reason in the sheet
  // and thread it through if partners need it.
  Future<Either<Failure, Unit>> rejectOrder(int id, {String? reason}) =>
      _api.changeStatus(id, status: 'cancelled', note: reason ?? 'Cancelled by partner').toEither();

  /// order_card's "Cancel" — no DELETE endpoint exists; cancel the order.
  Future<Either<Failure, Unit>> deleteOrder(int id) =>
      _api.changeStatus(id, status: 'cancelled', note: 'Cancelled by partner').toEither();

  /// Forward step. Partner-legal path is confirmed → preparing → ready
  /// (out_for_delivery/delivered are ops-side → 409 if the app sends them).
  Future<Either<Failure, Unit>> advanceOrder(int id, {required OrderStatus from}) {
    final next = from == OrderStatus.confirmed ? 'preparing' : 'ready';
    return _api.changeStatus(id, status: next).toEither();
  }
}
