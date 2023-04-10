//Flutter Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/controllers/home_controller/home_controller.dart';
import 'package:santra_seller/controllers/splash_controller.dart';
import 'package:santra_seller/provider/all_orders_manual.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/provider/login_provider.dart';
import 'package:santra_seller/provider/my_customer_provider.dart';
import 'package:santra_seller/provider/notification_provider.dart';
import 'package:santra_seller/provider/product_setting_provider.dart';
import 'package:santra_seller/provider/sign_up_provider.dart';
import 'package:santra_seller/ui/screens/splash/splash_screen.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/routes/app_pages.dart';

//Lib Imports
import './utils/uidata.dart';
import 'controllers/add_manual_order_controller.dart/add_manual_order_controller.dart';
import 'controllers/auth_controller/login_controller.dart';
import 'controllers/cart_controller/cart_controller.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SplashProvider>(create: (_) => SplashProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<AddManualOrderProvider>(
            create: (_) => AddManualOrderProvider()),
        ChangeNotifierProvider<MyCustomerProvider>(
            create: (_) => MyCustomerProvider()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<SignUpProvider>(create: (_) => SignUpProvider()),
        ChangeNotifierProvider<ProductSettingsProvider>(
            create: (_) => ProductSettingsProvider()),
            ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider()),
      ],
      child: GetMaterialApp(
        title: UIData.appName,
        theme: ThemeData(
          primaryColor: Colors.black,
          fontFamily: UIDataFonts.quickFont,
          primarySwatch: Colors.blue,
        ),
        initialBinding: BindingsBuilder(() {
          Get.put(LoginController());
          // Get.put(CartController());
          // Get.put(HomeController());
          // Get.put(AddManualOrderController());
        }),
        debugShowCheckedModeBanner: false,
        defaultTransition: Get.defaultTransition,
        showPerformanceOverlay: false,
        localizationsDelegates: [
          // const TranslationsDelegate(),
        ],
        home: SplashScreen(),
        enableLog: true,
        translations: AppTranslations(),
        // logWriterCallback: Logger.write,
        // supportedLocales: [const Locale("en", "US")],
        locale: const Locale('en', 'us'),
        // initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  }
}
