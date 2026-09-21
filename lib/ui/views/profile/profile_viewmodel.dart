import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/seller_profile.dart';
import '../../../services/language_service.dart';
import '../../../services/profile_service.dart';
import '../../../services/token_service.dart';
import '../../../services/toast_service.dart';

class ProfileViewModel extends BaseViewModel {
  final _profileService = locator<ProfileService>();
  final _tokenService = locator<TokenService>();
  final _languageService = locator<LanguageService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();

  SellerProfile? _profile;
  SellerProfile? get profile => _profile;

  /// Business name: /me when it carries one, else the name saved at login.
  String displayName(String lang) {
    final fromApi = _profile?.displayName(lang) ?? '';
    return fromApi.isNotEmpty ? fromApi : _tokenService.partnerDisplayName(lang);
  }

  Future<void> init() async {
    setBusy(true);
    final result = await _profileService.fetchProfile();
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (profile) => _profile = profile,
    );
    setBusy(false);
  }

  Future<void> onToggleLang() async {
    await _languageService.toggle();
    rebuildUi();
  }

  void onOpenHistory() => _navigationService.navigateToOrderHistoryView();

  void onOpenPromotions() => _navigationService.navigateToPromotionRequestsView();

  Future<void> onLogout() async {
    final result = await _profileService.logout();
    result.fold(
      (failure) => _toastService.showUpperToast(failure.message, type: ToastType.danger),
      (_) async {
        await _tokenService.clearToken();
        _navigationService.clearStackAndShow(Routes.welcomeView);
      },
    );
  }
}
