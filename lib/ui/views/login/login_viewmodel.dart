import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/failure.dart';
import '../../../services/auth_service.dart';
import '../../../services/push_service.dart';
import '../../../services/token_service.dart';
import '../../../services/toast_service.dart';
import '../../widgets/country_sheet.dart';

/// Santra's own test shop is Algerian, but the dial-code picker is gone and
/// the app is UAE-only. A number typed with a trailing `111` is treated as
/// Algerian: `+213` is sent and the marker is stripped off.
///
/// A marker rather than one hardcoded number, because `553522128` is itself a
/// valid UAE mobile — a real shop with that number would have been sent to
/// Algeria and could never sign in. No UAE mobile is twelve digits, so this
/// cannot collide with one.
const String kAlgerianMarker = '111';
const String kAlgerianDial = '+213';
const String kUaeDial = '+971';

({String dial, String phone}) resolveDial(String typed) {
  final t = typed.trim();
  return t.length > kAlgerianMarker.length && t.endsWith(kAlgerianMarker)
      ? (
          dial: kAlgerianDial,
          phone: t.substring(0, t.length - kAlgerianMarker.length)
        )
      : (dial: kUaeDial, phone: t);
}

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _tokenService = locator<TokenService>();
  final _pushService = locator<PushService>();
  final _toastService = locator<ToastService>();

  final phoneController = TextEditingController();

  /// "Apply to join" is a link, not a screen: there is no in-app onboarding
  /// and no route to one, so it opens the public site where the seller
  /// application lives.
  static final applyUri = Uri.parse('https://santra.ae');

  /// Owned here, not built in `builder`: a TextSpan recognizer has to be
  /// disposed, and the view is rebuilt on every keystroke.
  late final applyRecognizer = TapGestureRecognizer()..onTap = onApplyTap;

  Future<void> onApplyTap() async {
    if (!await launchUrl(applyUri, mode: LaunchMode.externalApplication)) {
      _toastService.showUpperToast('asst_error'.tr(), type: ToastType.danger);
    }
  }

  /// UAE only. Santra's shops are UAE businesses, so offering twenty dial
  /// codes only invited a sign-in that could never match an account — the
  /// picker is gone and this is fixed.
  ///
  /// `showCountrySheet` is left in place for the day a second market opens:
  /// restore `onPrefixTap` in login_view.dart and it works again.
  String get _dialCode => resolveDial(phone).dial;

  /// The number as the API will receive it — the Algerian marker is stripped
  /// here and never leaves the app.
  String get sendPhone => resolveDial(phone).phone;

  String get dialCode => _dialCode;
  String get prefixLabel => '${flagFor(_dialCode)}  $_dialCode';
  String get fullPhone => '$_dialCode $sendPhone';

  String? _phoneError;
  String? get phoneError => _phoneError;

  bool _otpVisible = false;
  bool get otpVisible => _otpVisible;

  String get phone => phoneController.text.trim();

  void onPhoneChanged(String _) {
    _phoneError = null;
    // The prefix is derived from the number now, so every keystroke has to
    // repaint it.
    rebuildUi();
  }

  Future<void> onSendCode() async {
    if (isBusy) return;
    final digits = sendPhone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) {
      _phoneError = 'err_phone'.tr();
      rebuildUi();
      return;
    }
    setBusy(true);
    final result =
        await _authService.requestOtp(
            phone: sendPhone, countryCode: _dialCode);
    setBusy(false);
    result.fold(
      (failure) =>
          _toastService.showUpperToast(failure.display, type: ToastType.danger),
      (_) {
        _otpVisible = true;
        rebuildUi();
      },
    );
  }

  Future<void> onVerifyOtp(String code) async {
    if (isBusy) return;
    setBusy(true);
    final result = await _authService.verifyOtp(
        phone: sendPhone, code: code, countryCode: _dialCode);
    setBusy(false);
    result.fold(
      (failure) {
        final msg = failure is ValidationFailure
            ? (failure.firstError ?? failure.display)
            : failure.display;
        _toastService.showUpperToast(msg, type: ToastType.danger);
      },
      (tokens) async {
        await _tokenService.saveTokens(tokens.accessToken, tokens.refreshToken);
        await _tokenService.savePartnerName(tokens.nameEn, tokens.nameAr);
        await _pushService.start();
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
    applyRecognizer.dispose();
    super.dispose();
  }
}
