//Flutter Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/controllers/home_controller/home_controller.dart';
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
    return GetMaterialApp(
      title: UIData.appName,
      theme: ThemeData(
          primaryColor: Colors.black,
          fontFamily: UIDataFonts.quickFont,
          primarySwatch: Colors.blue,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(LoginController());
        Get.put(CartController());
        Get.put(HomeController());
        Get.put(AddManualOrderController());

        

      }),
      debugShowCheckedModeBanner: false,
      defaultTransition: Get.defaultTransition,
      showPerformanceOverlay: false,
      localizationsDelegates: [
        // const TranslationsDelegate(),
      ],
      enableLog: true,
      translations: AppTranslations(),
      // logWriterCallback: Logger.write,
      // supportedLocales: [const Locale("en", "US")],
       locale: const Locale('en', 'us'),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
