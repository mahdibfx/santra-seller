import 'dart:async';

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

  final searchController = TextEditingController();
  Timer? _debounce;

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  String _query = '';
  DateTime? _from;
  DateTime? _to;

  int _page = 1;
  int _totalPages = 1;
  int _total = 0;
  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _page < _totalPages;
  int get resultsCount => _total;

  String get query => _query;
  DateTime? get from => _from;
  DateTime? get to => _to;

  bool get hasFilters => _query.isNotEmpty || _from != null || _to != null;

  Future<void> init() async {
    setBusy(true);
    await _load(reset: true);
    setBusy(false);
  }

  String _iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _load({bool reset = false}) async {
    final page = reset ? 1 : _page + 1;
    final result = await _ordersService.fetchOrders(
      page: page,
      // History is the delivered archive — the live board covers the rest.
      status: OrderStatus.delivered,
      search: _query.trim().replaceAll('#', ''),
      dateFrom: _from == null ? null : _iso(_from!),
      dateTo: _to == null ? null : _iso(_to!),
    );
    result.fold(
      (failure) =>
          _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (p) {
        _orders = reset ? p.items : [..._orders, ...p.items];
        _page = p.page;
        _totalPages = p.totalPages;
        _total = p.total;
      },
    );
  }

  /// Re-run the query from page 1 whenever a filter changes.
  Future<void> _refresh() async {
    setBusy(true);
    await _load(reset: true);
    setBusy(false);
  }

  Future<void> loadMore() async {
    if (_loadingMore || isBusy || !hasMore) return;
    _loadingMore = true;
    rebuildUi();
    await _load();
    _loadingMore = false;
    rebuildUi();
  }

  void onQueryChanged(String v) {
    _query = v;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _refresh);
    rebuildUi(); // reflect the clear-button / text immediately
  }

  void clearQuery() {
    _query = '';
    searchController.clear();
    _refresh();
  }

  void setFrom(DateTime? d) {
    _from = d;
    // Keep from ≤ to: an out-of-order `to` is dropped.
    if (d != null && _to != null && d.isAfter(_to!)) _to = null;
    _refresh();
  }

  void setTo(DateTime? d) {
    _to = d;
    if (d != null && _from != null && _from!.isAfter(d)) _from = null;
    _refresh();
  }

  void clearFilters() {
    _query = '';
    searchController.clear();
    _from = null;
    _to = null;
    _refresh();
  }

  Future<void> onOpen(Order order) async {
    await _navigationService.navigateToOrderDetailView(orderId: order.id);
    await _load(reset: true);
    rebuildUi();
  }

  void onBack() => _navigationService.back();

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }
}
