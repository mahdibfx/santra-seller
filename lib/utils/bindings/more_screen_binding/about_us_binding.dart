import 'package:get/get.dart';
import '../../../controllers/more_screen_controller.dart/about_us_controller.dart';

class AboutUsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutUsController>(() => AboutUsController());
  }
}
