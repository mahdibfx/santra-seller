import 'package:get/get.dart';
import 'package:santra_seller/controllers/auth_controller/reset_password_confirmation.dart';
import 'package:santra_seller/models/home_model.dart';
import 'package:santra_seller/ui/screens/auth_screen/fogot_password.dart';
import 'package:santra_seller/ui/screens/auth_screen/reset_password.dart';

import 'package:santra_seller/ui/screens/cart/cart_screen.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/screens/customer/add_customer.dart';
import 'package:santra_seller/ui/screens/more_setting/customer_reviews.dart';
import 'package:santra_seller/ui/screens/more_setting/privacy_policy_screen.dart';
import 'package:santra_seller/ui/screens/notification/notification_screen.dart';
import 'package:santra_seller/ui/screens/order_detail/all_order_screen.dart';
import 'package:santra_seller/ui/screens/order_detail/manual_order_screen.dart';
import 'package:santra_seller/ui/screens/order_detail/pending_order_screen.dart';
import 'package:santra_seller/ui/screens/settings/account_info.dart';
import 'package:santra_seller/ui/screens/settings/change_email.dart';
import 'package:santra_seller/ui/screens/settings/change_password.dart';
import 'package:santra_seller/ui/screens/settings/delete_account.dart';
import 'package:santra_seller/ui/screens/settings/delete_account_confirmation.dart';
import 'package:santra_seller/ui/screens/settings/language_screen.dart';
import 'package:santra_seller/ui/screens/settings/settings.dart';
import 'package:santra_seller/utils/bindings/cart_binding/cart_binding.dart';
import 'package:santra_seller/utils/bindings/add_manual_order_binding/add_manual_order_binding.dart';
import 'package:santra_seller/utils/bindings/more_screen_binding/customer_reviews_binding.dart';
import 'package:santra_seller/utils/bindings/more_screen_binding/privacy_bindings.dart';
import 'package:santra_seller/utils/bindings/more_screen_binding/settings/account_info_binding.dart';
import 'package:santra_seller/utils/bindings/more_screen_binding/settings/change_email_binding.dart';
import 'package:santra_seller/utils/bindings/more_screen_binding/settings/change_password_binding.dart';
import 'package:santra_seller/ui/screens/more_setting/contact_us/contact_us_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/add_customer.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/edit_customer_details.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/my_customer_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/wallet_screen.dart';
import 'package:santra_seller/utils/bindings/more_screen_binding/my_customer_binding/my_customer_binding.dart';
import 'package:santra_seller/utils/bindings/more_screen_binding/settings/delete_account_bindings.dart';
import 'package:santra_seller/utils/bindings/more_screen_binding/settings/delete_account_confirmation_binding.dart';
import 'package:santra_seller/utils/bindings/more_screen_binding/settings/language_settings_binding.dart';
import 'package:santra_seller/utils/bindings/more_screen_binding/wallet_binding.dart';
import 'package:santra_seller/utils/routes/app_routes.dart';

import '../../ui/screens/auth_screen/login_screen.dart';
import '../../ui/screens/auth_screen/signup_screen.dart';
import '../../ui/screens/home_page/home_screen.dart';
import '../../ui/screens/more_setting/about_us_screen.dart';
import '../../ui/screens/more_setting/more_screen.dart';
import '../../ui/screens/more_setting/my_customer/view_customer_details.dart';
import '../../ui/screens/order_detail/santra_order_screen.dart';
import '../../ui/screens/product_setting/product_setting_screen.dart';
import '../../ui/screens/splash/splash_screen.dart';
import '../bindings/auth_binding/forgot_password_bindings.dart';
import '../bindings/auth_binding/login_binding.dart';
import '../bindings/auth_binding/signup_binding.dart';
import '../bindings/customer_binding/customer_binding.dart';
import '../bindings/home_binding/home_screen_binding.dart';
import '../bindings/more_screen_binding/about_us_binding.dart';
import '../bindings/more_screen_binding/contact_binding/contact_us_binding.dart';
import '../bindings/more_screen_binding/more_screen_binding.dart';
import '../bindings/more_screen_binding/settings/settings_bindings.dart';
import '../bindings/notification/notification_binding.dart';
import '../bindings/products/product_settings_bindings.dart';
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
    GetPage(
        name: Routes.forgotpasswordRoutes,
        page: () => forgotPassowrd(),
        binding: FogotPassowordBinding()),
    GetPage(
        name: Routes.privacy,
        page: () => PrivacyScreen(),
        binding: PrivacyBindings()),
    GetPage(
        name: Routes.forgotPasswordConfirmation,
        page: () => ForgotPasswordConfirmation(),
        binding: FogotPassowordBinding()),
    GetPage(
        name: Routes.resetPasswordAfterConfirmation,
        page: () => ResetPasswordAfterConfirmation(),
        binding: FogotPassowordBinding()),
    GetPage(
      name: Routes.homeRoutes,
      page: () => HomeScreen(),
      binding: HomeBindings(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.santraorders,
      page: () => SantraOrderScreen(),
      binding: HomeBindings(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.manualOrderScreen,
      page: () => ManualOrderScreen(),
      binding: HomeBindings(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.allOrderScreen,
      page: () => AllOrderScreen(),
      binding: HomeBindings(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.pendingOrderScreen,
      page: () => PendingOrderScreen(),
      binding: HomeBindings(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.notificationscreen,
      page: () => NotificationScreen(),
      binding: NotificationBinding(),
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
      name: Routes.addManualOrder,
      page: () => AddManulOrder(),
      binding: AddManualOrderBinding(),
    ),
    GetPage(
      name: Routes.productSetting,
      page: () => ProductSettingScreen(),
      binding: ProductSettingsBinding(),
    ),
    GetPage(
      name: Routes.moreScreen,
      page: () => MoreSettingScreen(),
      binding: MoreScreenBindings(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => Settings(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: Routes.accountInfoRoute,
      page: () => AccountInfo(),
      binding: AccountInfoBinding(),
    ),
    GetPage(
      name: Routes.changeEmail,
      page: () => ChangeEmail(),
      binding: ChangeEmailBinding(),
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => ChangePassword(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: Routes.aboutscreen,
      page: () => AboutUsScreen(),
      binding: AboutUsBindings(),
    ),
    GetPage(
      name: Routes.walletscreen,
      page: () => WalletScreen(),
      binding: WalletBindings(),
    ),
    GetPage(
      name: Routes.contactscreen,
      page: () => ContactUsScreen(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: Routes.mycustomerscreen,
      page: () => MyCustomerScreen(),
      binding: MyCustomerBindings(),
    ),
    GetPage(
      name: Routes.mycustomerscreenview,
      page: () => ViewCustomerDetails(),
      binding: MyCustomerBindings(),
    ),
    GetPage(
      name: Routes.addNewcustomer,
      page: () => AddCustomerScreen(),
      binding: MyCustomerBindings(),
    ),
    GetPage(
      name: Routes.editcustomer,
      page: () => EditCustomerDetails(),
      binding: MyCustomerBindings(),
    ),
    GetPage(
      name: Routes.cartroute,
      page: () => CartScreen(),
      binding: CartBindings(),
    ),
    GetPage(
      name: Routes.languageSettings,
      page: () => LanguageSettings(),
      binding: LanguageSettingsBinding(),
    ),
    GetPage(
      name: Routes.deleteAccount,
      page: () => DeleteAccount(),
      binding: DeleteAccountBinding(),
    ),
    GetPage(
      name: Routes.deleteAccountConfirmation,
      page: () => DeleteAccountConfirmation(),
      binding: DeleteAccountConfirmationBinding(),
    ),
    GetPage(
      name: Routes.customerReviews,
      page: () => CustomerReviews(),
      binding: CustomerReviewsBindings(),
    ),
  ];
}
