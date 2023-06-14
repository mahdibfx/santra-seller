//Flutter Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/myApp.dart';
import 'package:santra_seller/ui/widgets/snackbar/common_snackbar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
//Lib Imports
import './utils/uidata.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'provider/language_provider/language_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );
  print('Handling a background message ${message.messageId}');
}

void _removeBadge() {
  FlutterAppBadger.removeBadge();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _removeBadge();
  // RemoteMessage? initialMessage =
  //     await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Got a message whilst in the foreground!');
    }
    CommonSnackbar.getSnackbar("${message.notification!.title.toString()}",
        "${message.notification!.body.toString()}", UIDataColors.redColor);
    // Get.snackbar("${message.notification!.title.toString()}",
    //     "${message.notification!.body.toString()}");

    print('Message data: ${message.notification!.title.toString()}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: UIDataColors.blackColor, // status bar color
          systemNavigationBarColor: Color(0xFF222222),

  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // await initServices();
   final localization = AppTranslations();
  // await localization.fetchTranslations();
  runApp(MyApp(),
   
    );
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // 'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
