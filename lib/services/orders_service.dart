import 'package:fpdart/fpdart.dart' hide Order;

import '../app/app.locator.dart';
import '../extensions/api_response_extension.dart';
import '../models/failure.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import 'api/api_orders_service.dart';

class OrdersService {
  final _api = locator<ApiOrdersService>();

  Future<Either<Failure, List<Order>>> fetchOrders({OrderStatus? status}) =>
      _api.fetchOrders(status: status).toEither();

  Future<Either<Failure, Order>> fetchOrder(int id) => _api.fetchOrder(id).toEither();

  Future<Either<Failure, Unit>> acceptOrder(int id) => _api.acceptOrder(id).toEither();

  Future<Either<Failure, Unit>> rejectOrder(int id, {String? reason}) =>
      _api.rejectOrder(id, reason: reason).toEither();

  Future<Either<Failure, Unit>> advanceOrder(int id) => _api.advanceOrder(id).toEither();

  Future<Either<Failure, Unit>> deleteOrder(int id) => _api.deleteOrder(id).toEither();
}
