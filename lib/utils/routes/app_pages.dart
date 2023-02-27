import 'package:get/get.dart';
import 'package:santra_seller/ui/screens/customer/add_customer.dart';
import 'package:santra_seller/utils/routes/app_routes.dart';

import '../../ui/screens/auth_screen/login_screen.dart';
import '../../ui/screens/auth_screen/signup_screen.dart';
import '../../ui/screens/home_page/home_screen.dart';
import '../../ui/screens/more_setting/more_screen.dart';
import '../../ui/screens/splash/splash_screen.dart';
import '../bindings/auth_binding/login_binding.dart';
import '../bindings/auth_binding/signup_binding.dart';
import '../bindings/customer_binding/customer_binding.dart';
import '../bindings/home_binding/home_screen_binding.dart';
import '../bindings/more_screen_binding/more_screen_binding.dart';
import '../bindings/splash_binding.dart';

class AppPages {
  static const INITIAL = Routes.splashRoutes;

  static final routes = [
    // < -------------------- Splash Page ----------------->
    GetPage(
      name: Routes.splashRoutes,
      page: () => SplashScreen(),
      binding: SplashBindings(),
    ),

    //<-------------- Forgotpassword Page Define ------------------>
    // GetPage(
    //   name: Routes.forgotpasswordRoutes,
    //   page: () => ForgetPasswordScreen(),
    //   binding: ForgotpasswordBinding(),
    // ),

    GetPage(
      name: Routes.homeRoutes,
      page: () => HomeScreen(),
      binding: HomeBindings(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
        name: Routes.signuproutes,
        page: () => SignUpScreen(),
        binding: SignupBinding()
        // middlewares: [AuthMiddleware()],
        ),
    GetPage(
        name: Routes.loginRoutes,
        page: () => LoginScreen(),
        binding: LoginBinding()
        // middlewares: [AuthMiddleware()],
        ),
        GetPage(
        name: Routes.addCustomer,
        page: () => CustomerScreen(),
        binding: CustomerBindings(),
        ),
        GetPage(
        name: Routes.moreScreen,
        page: () => MoreSettingScreen(),
        binding: MoreScreenBindings(),
        ),
  ];

}        