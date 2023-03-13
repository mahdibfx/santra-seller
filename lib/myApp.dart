//Flutter Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/routes/app_pages.dart';

//Lib Imports
import './utils/uidata.dart';

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
