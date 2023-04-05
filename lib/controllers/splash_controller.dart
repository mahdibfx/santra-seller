import 'package:get/get.dart';
import 'package:santra_seller/ui/screens/auth_screen/login_screen.dart';
import 'package:santra_seller/ui/screens/home_page/home_screen.dart';
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
          Future.delayed(const Duration(seconds: 1),
        () => Get.offAll(() => HomeScreen()));
      // Get.offAndToNamed(Routes.loginRoutes);
    } else {
      Get.offAll(() => LoginScreen());
    }
  }
}
