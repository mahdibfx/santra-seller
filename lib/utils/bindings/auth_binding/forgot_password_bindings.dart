import 'package:santra_seller/controllers/auth_controller/forgot_password_controller.dart';
import 'package:get/get.dart';

class FogotPassowordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}
