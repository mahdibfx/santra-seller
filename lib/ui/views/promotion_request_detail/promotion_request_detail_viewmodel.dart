import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../models/failure.dart';
import '../../../models/promotion_request.dart';
import '../../../services/promotions_service.dart';
import '../../../services/toast_service.dart';

class PromotionRequestDetailViewModel extends BaseViewModel {
  PromotionRequestDetailViewModel({required this.requestId});
  final int requestId;

  final _promotionsService = locator<PromotionsService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();

  final nameController = TextEditingController();

  PromotionRequest? _request;
  PromotionRequest? get request => _request;

  Future<void> init() async {
    setBusy(true);
    await _fetch();
    setBusy(false);
  }

  Future<void> _fetch() async {
    final result = await _promotionsService.fetchRequest(requestId);
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (r) => _request = r,
    );
  }

  Future<void> _respond({
    String? stock,
    String? stockNote,
    bool? signatureAccept,
    String? fullName,
    String? declineReason,
  }) async {
    if (isBusy) return;
    setBusy(true);
    final result = await _promotionsService.respond(
      requestId,
      stock: stock,
      stockNote: stockNote,
      signatureAccept: signatureAccept,
      fullName: fullName,
      declineReason: declineReason,
    );
    await result.fold(
      (failure) async => _toastService.showUpperToast(
          failure is ValidationFailure ? (failure.firstError ?? failure.message) : failure.message,
          type: ToastType.danger),
      (_) async {
        await _fetch();
        _toastService.showUpperToast('promo_saved'.tr(), type: ToastType.success);
      },
    );
    setBusy(false);
  }

  Future<void> confirmStock() => _respond(stock: 'confirmed');
  Future<void> declineStock() => _respond(stock: 'declined');

  Future<void> signAccept() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      _toastService.showUpperToast('promo_name_required'.tr(), type: ToastType.danger);
      return Future.value();
    }
    return _respond(signatureAccept: true, fullName: name);
  }

  Future<void> signDecline() => _respond(signatureAccept: false);

  void onBack() => _navigationService.back();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
