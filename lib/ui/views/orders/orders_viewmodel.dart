import 'package:easy_localization/easy_localization.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

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

  int _page = 1;
  int _totalPages = 1;
  int _total = 0;
  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _page < _totalPages;

  bool _hasUnread = false;
  bool get hasUnread => _hasUnread;

  Future<void> init() async {
    setBusy(true);
    await _load(reset: true);
    final notifResult = await _notificationsService.fetchNotifications();
    notifResult.fold(
        (_) {}, (notifs) => _hasUnread = notifs.any((n) => n.unread));
    setBusy(false);
  }

  Future<void> _load({bool reset = false}) async {
    final page = reset ? 1 : _page + 1;
    final result =
        await _ordersService.fetchOrders(page: page, status: _filter);
    result.fold(
      (failure) =>
          _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (p) {
        final fresh = p.items.map(_withDetail).toList();
        _orders = reset ? fresh : [..._orders, ...fresh];
        _page = p.page;
        _totalPages = p.totalPages;
        _total = p.total;
      },
    );
  }

  /// Reached the end of the list — fetch the next page.
  Future<void> loadMore() async {
    if (_loadingMore || isBusy || !hasMore) return;
    _loadingMore = true;
    rebuildUi();
    await _load();
    _loadingMore = false;
    rebuildUi();
  }

  /// Whole store is empty (new seller) — only when unfiltered and nothing came back.
  bool get isEmptyStore => _filter == null && _total == 0;

  int get totalCount => _total;

  List<Order> get visibleOrders => _orders;

  Future<void> setFilter(OrderStatus? status) async {
    if (_filter == status) return;
    _filter = status;
    setBusy(true);
    await _load(reset: true);
    setBusy(false);
  }

  /// The board lives in an IndexedStack, so `init` never runs again — pull the
  /// list back from the server after the detail screen may have changed it.
  Future<void> onOpen(Order order) async {
    await _navigationService.navigateToOrderDetailView(orderId: order.id);
    await _reload();
  }

  /// Full records already fetched, kept across reloads so the notes and photos
  /// don't vanish when the board refreshes — `GET /orders` omits them.
  final Map<int, Order> _details = {};

  Future<void> hydrateItems(Order order) async {
    if (_details.containsKey(order.id)) return;
    final result = await _ordersService.fetchOrder(order.id);
    result.fold(
      (_) {}, // no cache entry — the next tap retries
      (full) {
        _details[order.id] = full;
        _orders = _orders.map(_withDetail).toList();
        rebuildUi();
      },
    );
  }

  Order _withDetail(Order o) {
    final full = _details[o.id];
    return full == null
        ? o
        : o.copyWith(
            items: full.items, note: full.note, images: full.images);
  }

  Future<void> _reload() async {
    await _load(reset: true);
    rebuildUi();
  }

  Future<void> onAccept(Order order) async {
    final result = await _ordersService.acceptOrder(order.id);
    result.fold(
      (failure) =>
          _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (_) {
        _orders = _orders
            .map((o) => o.id == order.id
                ? o.copyWith(status: OrderStatus.confirmed)
                : o)
            .toList();
        _toastService.showUpperToast('order_accepted'.tr(),
            type: ToastType.success);
        rebuildUi();
        _reload();
      },
    );
  }

  Future<void> onDelete(Order order) async {
    final result = await _ordersService.deleteOrder(order.id);
    result.fold(
      (failure) =>
          _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (_) {
        // Show it as cancelled rather than dropping the row, then resync — the
        // active filter decides whether it still belongs in the list.
        _orders = _orders
            .map((o) => o.id == order.id
                ? o.copyWith(status: OrderStatus.cancelled)
                : o)
            .toList();
        rebuildUi();
        _reload();
      },
    );
  }

  Future<void> onToggleLang() async {
    await _languageService.toggle();
    rebuildUi();
  }

  void onOpenNotifications() =>
      _navigationService.navigateToNotificationsView();

  Future<void> onOpenPortal() async {
    final url = Uri.https('portal_url'.tr());
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      _toastService.showUpperToast('portal_url'.tr(), type: ToastType.info);
    }
  }
}
