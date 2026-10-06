import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/app_notification.dart';
import '../../../services/notifications_service.dart';
import '../../../services/toast_service.dart';

class NotificationsViewModel extends BaseViewModel {
  final _notificationsService = locator<NotificationsService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();

  List<AppNotification> _items = [];
  List<AppNotification> get items => _items;

  bool get hasUnread => _items.any((n) => n.unread);

  List<AppNotification> groupItems(NotifGroup group) =>
      _items.where((n) => n.group == group).toList();

  Future<void> init() async {
    setBusy(true);
    final result = await _notificationsService.fetchNotifications();
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (items) => _items = items,
    );
    setBusy(false);
  }

  /// Pull-to-refresh. No busy flag: it would replace the list with a spinner
  /// and take the pull indicator with it.
  Future<void> onRefresh() async {
    final result = await _notificationsService.fetchNotifications();
    result.fold(
      (failure) =>
          _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (items) => _items = items,
    );
    rebuildUi();
  }

  /// Row tap: mark read, then deep-link promo notifications to the requests.
  Future<void> onTap(AppNotification n) async {
    await markRead(n.id);
    if (n.type == 'promo') {
      _navigationService.navigateToPromotionRequestsView();
    }
  }

  Future<void> markRead(int id) async {
    final wasUnread = _items.any((n) => n.id == id && n.unread);
    if (!wasUnread) return;
    _items = _items.map((n) => n.id == id ? n.copyWith(unread: false) : n).toList();
    rebuildUi();
    await _notificationsService.markRead(id);
  }

  Future<void> markAll() async {
    _items = _items.map((n) => n.copyWith(unread: false)).toList();
    rebuildUi();
    await _notificationsService.markAllRead();
  }

  void onBack() => _navigationService.back();
}
