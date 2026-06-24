import 'package:easy_localization/easy_localization.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../../../services/language_service.dart';
import '../../../services/notifications_service.dart';
import '../../../services/orders_service.dart';
import '../../../services/toast_service.dart';

class OrdersViewModel extends BaseViewModel {
  final _ordersService = locator<OrdersService>();
  final _notificationsService = locator<NotificationsService>();
  final _navigationService = locator<NavigationService>();
  final _languageService = locator<LanguageService>();
  final _toastService = locator<ToastService>();

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  OrderStatus? _filter;
  OrderStatus? get filter => _filter;

  bool _hasUnread = false;
  bool get hasUnread => _hasUnread;

  Future<void> init() async {
    setBusy(true);
    final result = await _ordersService.fetchOrders();
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (orders) => _orders = orders,
    );
    final notifResult = await _notificationsService.fetchNotifications();
    notifResult.fold((_) {}, (notifs) => _hasUnread = notifs.any((n) => n.unread));
    setBusy(false);
  }

  Map<OrderStatus, int> get counts {
    final map = <OrderStatus, int>{};
    for (final s in kStatusOrder) {
      map[s] = _orders.where((o) => o.status == s).length;
    }
    return map;
  }

  int get totalCount => _orders.length;

  int get activeCount =>
      _orders.where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.accepted).length;

  List<Order> get visibleOrders =>
      _filter == null ? _orders : _orders.where((o) => o.status == _filter).toList();

  void setFilter(OrderStatus? status) {
    _filter = status;
    rebuildUi();
  }

  void onOpen(Order order) => _navigationService.navigateToOrderDetailView(orderId: order.id);

  Future<void> onAccept(Order order) async {
    final result = await _ordersService.acceptOrder(order.id);
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (_) {
        _orders = _orders.map((o) => o.id == order.id ? o.copyWith(status: OrderStatus.accepted) : o).toList();
        _toastService.showUpperToast('order_accepted'.tr(), type: ToastType.success);
        rebuildUi();
      },
    );
  }

  Future<void> onDelete(Order order) async {
    final result = await _ordersService.deleteOrder(order.id);
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (_) {
        _orders = _orders.where((o) => o.id != order.id).toList();
        rebuildUi();
      },
    );
  }

  Future<void> onToggleLang() async {
    await _languageService.toggle();
    rebuildUi();
  }

  void onOpenNotifications() => _navigationService.navigateToNotificationsView();

  void onOpenPortal() =>
      _toastService.showUpperToast('portal.santra.ae', type: ToastType.info);
}
