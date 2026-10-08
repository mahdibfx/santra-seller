import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'services/push_service.dart';
import 'package:flutter/foundation.dart';

import 'services/api/api_endpoints.dart';
import 'services/session_migration.dart';
import 'services/token_service.dart';
import 'services/version_check.dart';
import 'ui/common/app_colors.dart';

/// Runs in its own isolate — it may only wake Firebase up, nothing else.
@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// Firebase + notifications. Everything in here is for push, and push is not
/// worth a shop's whole app: if a plugin channel never answers, the Android
/// launch image stays on screen for ever and the app looks dead.
Future<void> _initMessaging() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  await localNotifications.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: onLocalNotificationTap,
  );
  await localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(kPushChannel);
}

/// Runs a startup step that must never hold the app on its splash screen.
/// A failure here costs a feature; a hang costs the whole app.
Future<void> _guard(String what, Future<void> Function() step,
    {int seconds = 8}) async {
  try {
    await step().timeout(Duration(seconds: seconds));
  } catch (e) {
    debugPrint('startup: $what failed or timed out — continuing. $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await _guard('messaging', _initMessaging);

  // Which backend this build talks to, so "am I on staging or production?"
  // is never a guess. Debug only — it says nothing a shop should see.
  if (kDebugMode) debugPrint('API base: ${ApiEndpoints.base}');
  await _guard('version', VersionCheck.load, seconds: 5);
  // One-time sign-out for shops updating from the legacy backend — before
  // TokenService reads anything.
  await _guard('session migration', SessionMigration.run, seconds: 5);
  await setupLocator();

  // A partner already signed in gets push straight away; a fresh login starts
  // it from the login screen.
  if (locator<TokenService>().isLoggedIn) {
    unawaited(locator<PushService>().start());
  }
  debugPrint('startup: reached runApp');
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const SantraSellerApp(),
    ),
  );
}

class SantraSellerApp extends StatelessWidget {
  const SantraSellerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Santra partners',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.brand, primary: AppColors.brand),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      initialRoute: Routes.welcomeView,
    );
  }
}
