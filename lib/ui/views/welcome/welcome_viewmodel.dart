import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/language_service.dart';

class WelcomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _languageService = locator<LanguageService>();

  Future<void> onToggleLang() async {
    await _languageService.toggle();
    rebuildUi();
  }

  void onStart() => _navigationService.navigateToLoginView();
}
