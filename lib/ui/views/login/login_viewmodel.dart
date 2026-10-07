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
  static const _uaeDial = '+971';

  /// Santra's own test shop is an Algerian number. With the picker gone it
  /// could not sign in at all, so this one number carries its own dial code —
  /// on every build, production included (Mahdi's call, 7 Oct 2026, so the
  /// account can be used against the live API).
  ///
  /// The prefix flips to the Algerian flag as it is typed, so what will be
  /// sent is always on screen.
  ///
  /// KNOWN RISK: `553522128` is also a valid UAE mobile (they run 5x + 7
  /// digits). A real UAE shop with exactly this number would be sent to +213
  /// and could never sign in. Delete these three lines the day that matters,
  /// or move the test shop to a number that is not UAE-shaped.
  static const _testPhone = '553522128';
  static const _testDial = '+213';

  String get _dialCode => phone == _testPhone ? _testDial : _uaeDial;

  String get dialCode => _dialCode;
  String get prefixLabel => '${flagFor(_dialCode)}  $_dialCode';
  String get fullPhone => '$_dialCode $phone';

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
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) {
      _phoneError = 'err_phone'.tr();
      rebuildUi();
      return;
    }
    setBusy(true);
    final result =
        await _authService.requestOtp(phone: phone, countryCode: _dialCode);
    setBusy(false);
    result.fold(
      (failure) =>
          _toastService.showUpperToast(failure.message, type: ToastType.danger),
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
        phone: phone, code: code, countryCode: _dialCode);
    setBusy(false);
    result.fold(
      (failure) {
        final msg = failure is ValidationFailure
            ? (failure.firstError ?? failure.message)
            : failure.message;
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
