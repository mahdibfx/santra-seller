import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/seller_profile.dart';
import '../../../services/language_service.dart';
import '../../../services/profile_service.dart';
import '../../../services/push_service.dart';
import '../../../services/token_service.dart';
import '../../../services/toast_service.dart';

class ProfileViewModel extends BaseViewModel {
  final _profileService = locator<ProfileService>();
  final _tokenService = locator<TokenService>();
  final _pushService = locator<PushService>();
  final _languageService = locator<LanguageService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();

  SellerProfile? _profile;
  SellerProfile? get profile => _profile;

  /// Business name: /me when it carries one, else the name saved at login.
  String displayName(String lang) {
    final fromApi = _profile?.displayName(lang) ?? '';
    return fromApi.isNotEmpty
        ? fromApi
        : _tokenService.partnerDisplayName(lang);
  }

  Future<void> init() async {
    setBusy(true);
    final result = await _profileService.fetchProfile();
    result.fold(
      (failure) =>
          _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (profile) => _profile = profile,
    );
    setBusy(false);
  }

  /// Santra's support line. Hardcoded on Mahdi's instruction (7 Oct 2026):
  /// `GET /content/about` serves a DIFFERENT number (+971 52 218 9917), so
  /// whichever Santra settles on, change it in one of the two places.
  static final _helpNumber = Uri(scheme: 'tel', path: '+97145605825');

  Future<void> onOpenHelp() async {
    if (!await launchUrl(_helpNumber)) {
      _toastService.showUpperToast('+971 4 560 5825', type: ToastType.info);
    }
  }

  /// Opens whichever policy Santra has published. Both urls are null on
  /// production today, so this says so rather than being a dead tap.
  Future<void> onOpenLegal() async {
    final result = await _profileService.legalLinks();
    await result.fold(
      (failure) async =>
          _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (links) async {
        final url = links['privacy'] ?? links['terms'] ?? links['contract'];
        if (url == null) {
          _toastService.showUpperToast('legal_not_published'.tr(),
              type: ToastType.info);
          return;
        }
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      },
    );
  }

  Future<void> onToggleLang() async {
    await _languageService.toggle();
    rebuildUi();
  }

  void onOpenHistory() => _navigationService.navigateToOrderHistoryView();

  void onOpenPromotions() =>
      _navigationService.navigateToPromotionRequestsView();

  /// Signing out is a local act. The server call is courtesy — it revokes the
  /// refresh token — but it can fail for reasons that have nothing to do with
  /// the shop's intent: an expired access token (the interceptor does not
  /// refresh `/auth/` calls), no network, or nothing left to revoke. Gating
  /// the sign-out on it left shops stuck signed in, staring at a red toast.
  Future<void> onLogout() async {
    // Unregister first, while the access token still works, or this device
    // keeps receiving another account's orders.
    await _pushService.stop();
    await _profileService.logout();
    await _tokenService.clearToken();
    _navigationService.clearStackAndShow(Routes.welcomeView);
  }
}
