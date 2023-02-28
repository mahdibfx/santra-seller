import 'package:get/get.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/contact_us/contact_us_controller.dart';

class ContactUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUsController>(() => ContactUsController());
  }
}
