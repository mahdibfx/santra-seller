import 'package:get/get.dart';
import 'package:santra_seller/controllers/settings_controller/settings_controller.dart';
import '../../../../controllers/more_screen_controller.dart/more_controller.dart';

class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
