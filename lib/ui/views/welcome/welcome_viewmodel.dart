import 'dart:async';
import 'dart:developer';

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

  /// How long the animated splash stays up at minimum. Reading the token is
  /// instant, so without a floor a signed-in shop leaves on the first frame
  /// and the animation is never seen — just a purple flash.
  // ponytail: a fixed floor costs a signed-in launch up to this much. Cut it,
  // or drop it to zero, if shops ever say opening the app feels slow.
  static const _minSplash = Duration(milliseconds: 900);

  Future<void> init() async {
    final splashUntil = DateTime.now().add(_minSplash);
    // Reading the token is local and instant, so it decides where the shop
    // belongs BEFORE any network call. This used to await the version check
    // first — up to five seconds of "Welcome, sign in" for a shop that was
    // already signed in.
    var signedIn = false;
    try {
      await _tokenService.init();
      signedIn = _tokenService.isLoggedIn;
    } catch (e) {
      // Storage unreadable. Treat it as signed out rather than letting the
      // screen hang on its background with nothing to tap — being asked to
      // sign in again is recoverable, a dead first screen is not.
      log('welcome: token init failed: $e');
    }

    final left = splashUntil.difference(DateTime.now());
    if (left > Duration.zero) await Future.delayed(left);

    if (signedIn) {
      _navigationService.clearStackAndShow(Routes.mainView);
    }
    // Always drawn, even on the way out: if the navigation above does not
    // take for any reason, the shop still gets a screen it can use.
    _deciding = false;
    rebuildUi();

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
