import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../models/failure.dart';
import '../../../services/auth_service.dart';
import '../../../services/toast_service.dart';

enum ForgotStep { phone, code, newPassword, done }

class ForgotViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _toastService = locator<ToastService>();

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  ForgotStep _step = ForgotStep.phone;
  ForgotStep get step => _step;

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  String? _passwordError;
  String? get passwordError => _passwordError;
  String? _confirmError;
  String? get confirmError => _confirmError;

  String get phone => phoneController.text.trim();
  bool get phoneValid => phone.replaceAll(RegExp(r'\D'), '').length >= 8;

  void onPhoneChanged(String _) => rebuildUi();

  void toggleShowPassword() {
    _showPassword = !_showPassword;
    rebuildUi();
  }

  Future<void> onSendCode() async {
    if (isBusy || !phoneValid) return;
    setBusy(true);
    final result = await _authService.forgotPassword(phone: phone);
    setBusy(false);
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (_) {
        _step = ForgotStep.code;
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
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (_) {
        _step = ForgotStep.newPassword;
        rebuildUi();
      },
    );
  }

  Future<void> onSavePassword() async {
    if (isBusy) return;
    _passwordError = null;
    _confirmError = null;
    final pass = passwordController.text;
    if (pass.length < 6) _passwordError = 'err_pass'.tr();
    if (confirmController.text != pass) _confirmError = 'err_match'.tr();
    if (_passwordError != null || _confirmError != null) {
      rebuildUi();
      return;
    }
    setBusy(true);
    final result = await _authService.resetPassword(phone: phone, code: '0000', password: pass);
    setBusy(false);
    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          _passwordError = failure.firstError;
        }
        _toastService.showUpperToast(failure.message, type: ToastType.danger);
        rebuildUi();
      },
      (_) {
        _step = ForgotStep.done;
        rebuildUi();
      },
    );
  }

  void onBack() {
    switch (_step) {
      case ForgotStep.phone:
        _navigationService.back();
      case ForgotStep.code:
        _step = ForgotStep.phone;
        rebuildUi();
      case ForgotStep.newPassword:
        _step = ForgotStep.code;
        rebuildUi();
      case ForgotStep.done:
        _navigationService.back();
    }
  }

  void closeOtp() {
    _step = ForgotStep.phone;
    rebuildUi();
  }

  void onDone() => _navigationService.back();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }
}
