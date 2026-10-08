import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/language_service.dart';
import '../../../services/token_service.dart';
import '../../../services/version_check.dart';
import '../update_required/update_required_view.dart';

class WelcomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _languageService = locator<LanguageService>();
  final _tokenService = locator<TokenService>();

  /// True until we know whether this shop is signed in. The welcome screen
  /// shows nothing but its background meanwhile, so a signed-in shop never
  /// sees a sign-in screen it is about to be moved off.
  bool _deciding = true;
  bool get deciding => _deciding;

  Future<void> init() async {
    // Reading the token is local and instant, so it decides where the shop
    // belongs BEFORE any network call. This used to await the version check
    // first — up to five seconds of "Welcome, sign in" for a shop that was
    // already signed in.
    await _tokenService.init();
    if (_tokenService.isLoggedIn) {
      _navigationService.clearStackAndShow(Routes.mainView);
    } else {
      _deciding = false;
      rebuildUi();
    }

    // The gate still runs, just not in the way: it replaces whatever is on
    // screen if this build is too old.
    unawaited(_runVersionGate());
  }

  Future<void> _runVersionGate() async {
    final storeUrl = await VersionCheck.forcedUpdateUrl();
    if (storeUrl == null) return;
    StackedService.navigatorKey?.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => UpdateRequiredView(storeUrl: storeUrl)),
        (_) => false);
  }

  Future<void> onToggleLang() async {
    await _languageService.toggle();
    rebuildUi();
  }

  void onStart() => _navigationService.navigateToLoginView();
}
