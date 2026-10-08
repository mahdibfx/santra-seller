import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../models/failure.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../../../services/orders_service.dart';
import '../../widgets/cancel_order_sheet.dart';
import '../../widgets/unavailable_sheet.dart';
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
  /// Driven by the order's `allowed_transitions` — see [Order.nextStep].
  ({String labelKey, String icon})? get advanceAction =>
      switch (_order?.nextStep) {
        OrderStatus.preparing => (labelKey: 'mark_preparing', icon: 'clock'),
        OrderStatus.ready => (labelKey: 'mark_ready', icon: 'checkCircle'),
        _ => null,
      };

  bool get canAccept => _order?.can(OrderStatus.confirmed) ?? false;
  bool get canCancel => _order?.can(OrderStatus.cancelled) ?? false;

  // ── Refund bank details ──────────────────────────────────────────────
  final accountNameController = TextEditingController();
  final ibanController = TextEditingController();

  String? _refundError;
  String? get refundError => _refundError;

  bool _sendingRefund = false;
  bool get sendingRefund => _sendingRefund;

  bool get needsRefundDetails => _order?.refundBankDetails?.needed ?? false;
  num get refundAmount => _order?.refundBankDetails?.amount ?? 0;

  bool get canSendRefund =>
      accountNameController.text.trim().length >= 2 &&
      ibanController.text.trim().length >= 5 &&
      !_sendingRefund;

  void onRefundFieldChanged(String _) {
    _refundError = null;
    rebuildUi();
  }

  Future<void> sendRefundBankDetails() async {
    if (!canSendRefund) return;
    _sendingRefund = true;
    _refundError = null;
    rebuildUi();
    final result = await _ordersService.submitRefundBankDetails(
      orderId,
      accountName: accountNameController.text.trim(),
      iban: ibanController.text.trim(),
    );
    _sendingRefund = false;
    result.fold(
      (f) {
        // Our own copy per code; the server's message is English only.
        _refundError = switch (f.code) {
          'BAD_IBAN' => 'refund_bad_iban'.tr(),
          'BAD_ACCOUNT_NAME' => 'refund_bad_name'.tr(),
          'BANK_DETAILS_NOT_EXPECTED' => null,
          _ => f.message,
        };
        if (f.code == 'BANK_DETAILS_NOT_EXPECTED') {
          // Someone already sent them — refresh and the card disappears.
          _toastService.showUpperToast('refund_sent'.tr(),
              type: ToastType.info);
          init();
        } else {
          rebuildUi();
        }
      },
      (_) {
        accountNameController.clear();
        ibanController.clear();
        _toastService.showUpperToast('refund_sent'.tr(),
            type: ToastType.success);
        init();
      },
    );
  }

  Future<void> init() async {
    setBusy(true);
    final result = await _ordersService.fetchOrder(orderId);
    result.fold(
      (failure) {
        _toastService.showUpperToast(failure.display, type: ToastType.danger);
        // 404 means it isn't ours any more — an unpaid card checkout the
        // customer hasn't finished paying for. Don't sit on a dead screen.
        if (failure.code == 'NOT_FOUND') _navigationService.back();
      },
      (order) => _order = order,
    );
    setBusy(false);
  }

  Future<void> accept() async {
    final result = await _ordersService.acceptOrder(orderId);
    result.fold(
      (f) => _toastService.showUpperToast(f.message, type: ToastType.danger),
      (_) => init(),
    );
  }

  /// Names the units the shop cannot supply, then re-reads the order so the
  /// struck-through lines and the shortage summary come from the server.
  Future<void> reportUnavailable(UnavailableReport report) async {
    final result = await _ordersService.reportUnavailable(orderId,
        quantities: report.quantities, note: report.note);
    result.fold(
      (f) => _toastService.showUpperToast(
          switch (f.code) {
            'SHORTAGE_NOT_ALLOWED_NOW' => 'err_shortage_too_late'.tr(),
            'CANCEL_INSTEAD' => 'err_cancel_instead'.tr(),
            _ => f.message, // VALIDATION says how many can still be reported
          },
          type: ToastType.danger),
      (_) {
        _toastService.showUpperToast(
            (_order?.isManual ?? false)
                ? 'report_sent_manual'.tr()
                : 'report_sent'.tr(),
            type: ToastType.success);
        init();
      },
    );
  }

  Future<void> advance() async {
    final next = _order?.nextStep;
    if (next == null) return;
    final result = await _ordersService.moveOrder(orderId, to: next);
    result.fold(
      (f) => _toastService.showUpperToast(f.message, type: ToastType.danger),
      (_) => init(), // the server re-decides which buttons are legal now
    );
  }

  /// Called with what the partner picked in the cancel sheet. Returns the
  /// failure (if any) so the caller can redraw on `COURIER_STAGE_CHANGED`.
  Future<Failure?> cancel(CancelChoice choice) async {
    final result = await _ordersService.cancelOrder(orderId,
        reasonCode: choice.reasonCode,
        note: choice.note,
        courierStage: choice.courierStage);
    return result.fold(
      (f) {
        // The sheet is about to be redrawn — don't shout about it.
        if (f.code != 'COURIER_STAGE_CHANGED') {
          _toastService.showUpperToast(cancelErrorCopy(f),
              type: ToastType.danger);
        }
        return f;
      },
      (_) {
        init();
        return null;
      },
    );
  }

  void onBack() => _navigationService.back();

  @override
  void dispose() {
    accountNameController.dispose();
    ibanController.dispose();
    super.dispose();
  }
}
