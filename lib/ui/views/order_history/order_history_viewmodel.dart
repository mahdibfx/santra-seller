import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../../../services/orders_service.dart';
import '../../../services/toast_service.dart';

class OrderHistoryViewModel extends BaseViewModel {
  final _ordersService = locator<OrdersService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();

  List<Order> _all = [];

  final searchController = TextEditingController();
  String _query = '';
  OrderStatus? _status;
  DateTime? _from;
  DateTime? _to;

  String get query => _query;
  OrderStatus? get status => _status;
  DateTime? get from => _from;
  DateTime? get to => _to;

  bool get hasFilters => _query.isNotEmpty || _status != null || _from != null || _to != null;

  Future<void> init() async {
    setBusy(true);
    final result = await _ordersService.fetchOrders();
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (orders) => _all = orders,
    );
    setBusy(false);
  }

  String _iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  List<Order> get filtered {
    final needle = _query.trim().toLowerCase().replaceAll('#', '');
    final fromIso = _from == null ? null : _iso(_from!);
    final toIso = _to == null ? null : _iso(_to!);
    final list = _all.where((o) {
      if (_status != null && o.status != _status) return false;
      if (fromIso != null && (o.date.isEmpty || o.date.compareTo(fromIso) < 0)) return false;
      if (toIso != null && (o.date.isEmpty || o.date.compareTo(toIso) > 0)) return false;
      if (needle.isNotEmpty) {
        final hay = '${o.id} ${o.customer}'.toLowerCase();
        if (!hay.contains(needle)) return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        return byDate != 0 ? byDate : b.id.compareTo(a.id);
      });
    return list;
  }

  void onQueryChanged(String v) {
    _query = v;
    rebuildUi();
  }

  void clearQuery() {
    _query = '';
    searchController.clear();
    rebuildUi();
  }

  void setStatus(OrderStatus? s) {
    _status = s;
    rebuildUi();
  }

  void setFrom(DateTime? d) {
    _from = d;
    rebuildUi();
  }

  void setTo(DateTime? d) {
    _to = d;
    rebuildUi();
  }

  void clearFilters() {
    _query = '';
    searchController.clear();
    _status = null;
    _from = null;
    _to = null;
    rebuildUi();
  }

  void onOpen(Order order) => _navigationService.navigateToOrderDetailView(orderId: order.id);
  void onBack() => _navigationService.back();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
