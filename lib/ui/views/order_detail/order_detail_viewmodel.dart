import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../../../services/orders_service.dart';
import '../../../services/toast_service.dart';

class OrderDetailViewModel extends BaseViewModel {
  OrderDetailViewModel({required this.orderId});

  final int orderId;

  final _ordersService = locator<OrdersService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();

  Order? _order;
  Order? get order => _order;

  /// Next-step action the partner is allowed to take (label key + icon).
  /// confirmed → preparing → ready; nothing after (ops takes over).
  ({String labelKey, String icon})? get advanceAction => switch (_order?.status) {
        OrderStatus.confirmed => (labelKey: 'mark_preparing', icon: 'clock'),
        OrderStatus.preparing => (labelKey: 'mark_ready', icon: 'checkCircle'),
        _ => null,
      };

  Future<void> init() async {
    setBusy(true);
    final result = await _ordersService.fetchOrder(orderId);
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (order) => _order = order,
    );
    setBusy(false);
  }

  Future<void> accept() async {
    final result = await _ordersService.acceptOrder(orderId);
    result.fold(
      (f) => _toastService.showUpperToast(f.message, type: ToastType.danger),
      (_) {
        _order = _order?.copyWith(status: OrderStatus.confirmed);
        rebuildUi();
      },
    );
  }

  Future<void> advance() async {
    final result = await _ordersService.advanceOrder(orderId, from: _order?.status ?? OrderStatus.confirmed);
    result.fold(
      (f) => _toastService.showUpperToast(f.message, type: ToastType.danger),
      (_) {
        final next = _order?.status == OrderStatus.confirmed ? OrderStatus.preparing : OrderStatus.ready;
        _order = _order?.copyWith(status: next);
        rebuildUi();
      },
    );
  }

  /// Called after the reject confirmation sheet returns true.
  Future<void> reject() async {
    final result = await _ordersService.rejectOrder(orderId);
    result.fold(
      (f) => _toastService.showUpperToast(f.message, type: ToastType.danger),
      (_) {
        _order = _order?.copyWith(status: OrderStatus.cancelled);
        rebuildUi();
      },
    );
  }

  void onBack() => _navigationService.back();
}
