import 'package:get/get.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/privacy_controller.dart';
import '../../../controllers/more_screen_controller.dart/about_us_controller.dart';

class PrivacyBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyController>(() => PrivacyController());
  }
}
