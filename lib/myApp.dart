//Flutter Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/language_provider/language_provider.dart';
import 'package:santra_seller/provider/more_settings_provider/contact_us_provider.dart';
import 'package:santra_seller/provider/more_settings_provider/privacy_provider.dart';
import 'package:santra_seller/provider/more_settings_provider/customer_reviews_provider.dart';
import 'package:santra_seller/provider/more_settings_provider/about_us_provider.dart';
import 'package:santra_seller/provider/setting_provider/logout_controller.dart';
import 'package:santra_seller/provider/setting_provider/change_password_provider.dart';
import 'package:santra_seller/provider/splash_provider.dart';
import 'package:santra_seller/provider/all_orders_manual.dart';
import 'package:santra_seller/provider/auth_providers/forgot_password_provider.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/provider/auth_providers/login_provider.dart';
import 'package:santra_seller/provider/more_settings_provider/my_customer_provider.dart';
import 'package:santra_seller/provider/notification_provider.dart';
import 'package:santra_seller/provider/more_settings_provider/product_setting_provider.dart';
import 'package:santra_seller/provider/setting_provider/account_info_provider.dart';
import 'package:santra_seller/provider/setting_provider/change_email_provider.dart';
import 'package:santra_seller/provider/setting_provider/delete_account_provider.dart';
import 'package:santra_seller/provider/setting_provider/reset_password_provider.dart';
import 'package:santra_seller/provider/auth_providers/sign_up_provider.dart';
import 'package:santra_seller/ui/screens/splash/splash_screen.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
//Lib Imports
import './utils/uidata.dart';
import 'provider/setting_provider/language_settings_controller.dart';

class MyApp extends StatelessWidget {

  const MyApp({super.key});
   

  @override
  Widget build(BuildContext context) {
    var _ = Get.put(AppTranslations());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SplashProvider>(create: (_) => SplashProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider(_)),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider(_)),
        ChangeNotifierProvider<AddManualOrderProvider>(
            create: (_) => AddManualOrderProvider()),
        ChangeNotifierProvider<MyCustomerProvider>(
            create: (_) => MyCustomerProvider()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<SignUpProvider>(create: (_) => SignUpProvider(_)),
        ChangeNotifierProvider<ProductSettingsProvider>(
            create: (_) => ProductSettingsProvider()),
        ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider(_)),
        ChangeNotifierProvider<AccountInfoProvider>(
            create: (_) => AccountInfoProvider(_)),
        ChangeNotifierProvider<ChangeEmailProvider>(
            create: (_) => ChangeEmailProvider(_)),
        ChangeNotifierProvider<ForgotPasswordProvider>(
            create: (_) => ForgotPasswordProvider(_)),
        ChangeNotifierProvider<ResetPasswordProvider>(
            create: (_) => ResetPasswordProvider(_)),
        ChangeNotifierProvider<ChangePasswordProvider>(
            create: (_) => ChangePasswordProvider(_)),
        ChangeNotifierProvider<DeleteAccountProvider>(
            create: (_) => DeleteAccountProvider(_)),
        ChangeNotifierProvider<LogoutProvider>(create: (_) => LogoutProvider()),
        ChangeNotifierProvider<LangaugeSettingsProvider>(
            create: (_) => LangaugeSettingsProvider()),
        ChangeNotifierProvider<AboutUsProvider>(
            create: (_) => AboutUsProvider()),
        ChangeNotifierProvider<CustomerReviewsProvider>(
            create: (_) => CustomerReviewsProvider()),
        ChangeNotifierProvider<PrivacyProvider>(
            create: (_) => PrivacyProvider()),
        ChangeNotifierProvider<ContactUsProvider>(
            create: (_) => ContactUsProvider(_)),
        // ChangeNotifierProvider<LanguageProvider>(
        //     create: (_) => LanguageProvider()),
      ],
      child:GetMaterialApp(
        title: UIData.appName,
        theme: ThemeData(
          primaryColor: Colors.black,
          fontFamily: UIDataFonts.quickFont,
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        defaultTransition: Get.defaultTransition,
        showPerformanceOverlay: false,
        home: const SplashScreen(),
        enableLog: true,
        fallbackLocale: const Locale('en', 'US'),
        locale: _.selectedLanguage == 'en_us' ? const Locale('en', 'us') :const Locale('ar', 'AE'),
        // initialRoute: AppPages.INITIAL,
        // getPages: AppPages.routes,
      ),
    );
  }
}
