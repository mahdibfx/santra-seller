// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../services/api/api_auth_service.dart';
import '../services/api/api_chat_service.dart';
import '../services/api/api_notifications_service.dart';
import '../services/api/api_orders_service.dart';
import '../services/api/api_profile_service.dart';
import '../services/api/api_promotions_service.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/dio_service.dart';
import '../services/language_service.dart';
import '../services/notifications_service.dart';
import '../services/orders_service.dart';
import '../services/profile_service.dart';
import '../services/promotions_service.dart';
import '../services/toast_service.dart';
import '../services/token_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator(
    {String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DioService());
  locator.registerLazySingleton(() => TokenService());
  locator.registerLazySingleton(() => ToastService());
  locator.registerLazySingleton(() => LanguageService());
  locator.registerLazySingleton(() => ApiAuthService());
  locator.registerLazySingleton(() => ApiOrdersService());
  locator.registerLazySingleton(() => ApiNotificationsService());
  locator.registerLazySingleton(() => ApiProfileService());
  locator.registerLazySingleton(() => ApiChatService());
  locator.registerLazySingleton(() => ApiPromotionsService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => OrdersService());
  locator.registerLazySingleton(() => NotificationsService());
  locator.registerLazySingleton(() => ProfileService());
  locator.registerLazySingleton(() => ChatService());
  locator.registerLazySingleton(() => PromotionsService());
}
