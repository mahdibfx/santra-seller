import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    Future.delayed(const Duration(seconds: 3), () {
      checkAlreadyLogin();
    });
    update();
    super.onInit();
  }

  checkAlreadyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var checkemail = prefs.getString("email");
    // var checkpassword = prefs.getString("password");
    if (checkemail != null) {
      Get.offAllNamed(Routes.homeRoutes);
      // Get.offAndToNamed(Routes.loginRoutes);
    } else {
      Get.offAndToNamed(Routes.loginRoutes);
    }
  }
}
