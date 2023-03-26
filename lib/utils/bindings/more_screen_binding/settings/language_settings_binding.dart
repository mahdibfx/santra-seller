import 'package:get/get.dart';

import 'package:santra_seller/controllers/settings_controller/change_password_controller.dart';
import 'package:santra_seller/controllers/settings_controller/language_settings_controller.dart';

class LanguageSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LangaugeSettingsController>(() => LangaugeSettingsController());
  }
}
