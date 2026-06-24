import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/api/api_auth_service.dart';
import '../services/api/api_chat_service.dart';
import '../services/api/api_notifications_service.dart';
import '../services/api/api_orders_service.dart';
import '../services/api/api_profile_service.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/dio_service.dart';
import '../services/language_service.dart';
import '../services/notifications_service.dart';
import '../services/orders_service.dart';
import '../services/profile_service.dart';
import '../services/toast_service.dart';
import '../ui/views/forgot/forgot_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/main/main_view.dart';
import '../ui/views/notifications/notifications_view.dart';
import '../ui/views/order_detail/order_detail_view.dart';
import '../ui/views/order_history/order_history_view.dart';
import '../ui/views/welcome/welcome_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: WelcomeView, initial: true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: ForgotView),
    MaterialRoute(page: MainView),
    MaterialRoute(page: OrderDetailView),
    MaterialRoute(page: NotificationsView),
    MaterialRoute(page: OrderHistoryView),
    // Tab views (OrdersView / ChatView / ProfileView) are hosted inside
    // MainView's IndexedStack, so they need no standalone routes.
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DioService),
    LazySingleton(classType: ToastService),
    LazySingleton(classType: LanguageService),

    // API (HTTP) layer
    LazySingleton(classType: ApiAuthService),
    LazySingleton(classType: ApiOrdersService),
    LazySingleton(classType: ApiNotificationsService),
    LazySingleton(classType: ApiProfileService),
    LazySingleton(classType: ApiChatService),

    // Business layer
    LazySingleton(classType: AuthService),
    LazySingleton(classType: OrdersService),
    LazySingleton(classType: NotificationsService),
    LazySingleton(classType: ProfileService),
    LazySingleton(classType: ChatService),
  ],
)
class App {}
