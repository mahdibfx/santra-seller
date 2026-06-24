import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/failure.dart';
import '../../../services/auth_service.dart';
import '../../../services/toast_service.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _toastService = locator<ToastService>();

  final phoneController = TextEditingController();

  String? _phoneError;
  String? get phoneError => _phoneError;

  bool _otpVisible = false;
  bool get otpVisible => _otpVisible;

  String get phone => phoneController.text.trim();

  void onPhoneChanged(String _) {
    if (_phoneError != null) {
      _phoneError = null;
      rebuildUi();
    }
  }

  Future<void> onSendCode() async {
    if (isBusy) return;
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) {
      _phoneError = 'err_phone'.tr();
      rebuildUi();
      return;
    }
    setBusy(true);
    final result = await _authService.requestOtp(phone: phone);
    setBusy(false);
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (_) {
        _otpVisible = true;
        rebuildUi();
      },
    );
  }

  Future<void> onVerifyOtp(String code) async {
    if (isBusy) return;
    setBusy(true);
    final result = await _authService.verifyOtp(phone: phone, code: code);
    setBusy(false);
    result.fold(
      (failure) {
        final msg = failure is ValidationFailure ? (failure.firstError ?? failure.message) : failure.message;
        _toastService.showUpperToast(msg, type: ToastType.danger);
      },
      (_) {
        _otpVisible = false;
        _navigationService.clearStackAndShow(Routes.mainView);
      },
    );
  }

  void closeOtp() {
    _otpVisible = false;
    rebuildUi();
  }

  void onForgot() => _navigationService.navigateToForgotView();
  void onBack() => _navigationService.back();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
