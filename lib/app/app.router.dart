// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i9;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as _i10;
import 'package:santra_seller/ui/views/forgot/forgot_view.dart' as _i4;
import 'package:santra_seller/ui/views/login/login_view.dart' as _i3;
import 'package:santra_seller/ui/views/main/main_view.dart' as _i5;
import 'package:santra_seller/ui/views/notifications/notifications_view.dart'
    as _i7;
import 'package:santra_seller/ui/views/order_detail/order_detail_view.dart'
    as _i6;
import 'package:santra_seller/ui/views/order_history/order_history_view.dart'
    as _i8;
import 'package:santra_seller/ui/views/promotion_request_detail/promotion_request_detail_view.dart'
    as _i13;
import 'package:santra_seller/ui/views/promotion_requests/promotion_requests_view.dart'
    as _i12;
import 'package:santra_seller/ui/views/welcome/welcome_view.dart' as _i2;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i11;

class Routes {
  static const welcomeView = '/';

  static const loginView = '/login-view';

  static const forgotView = '/forgot-view';

  static const mainView = '/main-view';

  static const orderDetailView = '/order-detail-view';

  static const notificationsView = '/notifications-view';

  static const orderHistoryView = '/order-history-view';

  static const promotionRequestsView = '/promotion-requests-view';

  static const promotionRequestDetailView = '/promotion-request-detail-view';

  static const all = <String>{
    welcomeView,
    loginView,
    forgotView,
    mainView,
    orderDetailView,
    notificationsView,
    orderHistoryView,
    promotionRequestsView,
    promotionRequestDetailView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.welcomeView,
      page: _i2.WelcomeView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i3.LoginView,
    ),
    _i1.RouteDef(
      Routes.forgotView,
      page: _i4.ForgotView,
    ),
    _i1.RouteDef(
      Routes.mainView,
      page: _i5.MainView,
    ),
    _i1.RouteDef(
      Routes.orderDetailView,
      page: _i6.OrderDetailView,
    ),
    _i1.RouteDef(
      Routes.notificationsView,
      page: _i7.NotificationsView,
    ),
    _i1.RouteDef(
      Routes.orderHistoryView,
      page: _i8.OrderHistoryView,
    ),
    _i1.RouteDef(
      Routes.promotionRequestsView,
      page: _i12.PromotionRequestsView,
    ),
    _i1.RouteDef(
      Routes.promotionRequestDetailView,
      page: _i13.PromotionRequestDetailView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.WelcomeView: (data) {
      final args = data.getArgs<WelcomeViewArguments>(
        orElse: () => const WelcomeViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.WelcomeView(key: args.key),
        settings: data,
      );
    },
    _i3.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.LoginView(key: args.key),
        settings: data,
      );
    },
    _i4.ForgotView: (data) {
      final args = data.getArgs<ForgotViewArguments>(
        orElse: () => const ForgotViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.ForgotView(key: args.key),
        settings: data,
      );
    },
    _i5.MainView: (data) {
      final args = data.getArgs<MainViewArguments>(
        orElse: () => const MainViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.MainView(key: args.key),
        settings: data,
      );
    },
    _i6.OrderDetailView: (data) {
      final args = data.getArgs<OrderDetailViewArguments>(nullOk: false);
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i6.OrderDetailView(key: args.key, orderId: args.orderId),
        settings: data,
      );
    },
    _i7.NotificationsView: (data) {
      final args = data.getArgs<NotificationsViewArguments>(
        orElse: () => const NotificationsViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.NotificationsView(key: args.key),
        settings: data,
      );
    },
    _i8.OrderHistoryView: (data) {
      final args = data.getArgs<OrderHistoryViewArguments>(
        orElse: () => const OrderHistoryViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.OrderHistoryView(key: args.key),
        settings: data,
      );
    },
    _i12.PromotionRequestsView: (data) {
      final args = data.getArgs<PromotionRequestsViewArguments>(
        orElse: () => const PromotionRequestsViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.PromotionRequestsView(key: args.key),
        settings: data,
      );
    },
    _i13.PromotionRequestDetailView: (data) {
      final args = data.getArgs<PromotionRequestDetailViewArguments>(nullOk: false);
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i13.PromotionRequestDetailView(key: args.key, requestId: args.requestId),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class WelcomeViewArguments {
  const WelcomeViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant WelcomeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ForgotViewArguments {
  const ForgotViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ForgotViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class MainViewArguments {
  const MainViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant MainViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class OrderDetailViewArguments {
  const OrderDetailViewArguments({
    this.key,
    required this.orderId,
  });

  final _i10.Key? key;

  final int orderId;

  @override
  String toString() {
    return '{"key": "$key", "orderId": "$orderId"}';
  }

  @override
  bool operator ==(covariant OrderDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.orderId == orderId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ orderId.hashCode;
  }
}

class NotificationsViewArguments {
  const NotificationsViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant NotificationsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class OrderHistoryViewArguments {
  const OrderHistoryViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant OrderHistoryViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class PromotionRequestsViewArguments {
  const PromotionRequestsViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant PromotionRequestsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class PromotionRequestDetailViewArguments {
  const PromotionRequestDetailViewArguments({
    this.key,
    required this.requestId,
  });

  final _i10.Key? key;

  final int requestId;

  @override
  String toString() {
    return '{"key": "$key", "requestId": "$requestId"}';
  }

  @override
  bool operator ==(covariant PromotionRequestDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.requestId == requestId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ requestId.hashCode;
  }
}

extension NavigatorStateExtension on _i11.NavigationService {
  Future<dynamic> navigateToWelcomeView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.welcomeView,
        arguments: WelcomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForgotView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.forgotView,
        arguments: ForgotViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMainView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.mainView,
        arguments: MainViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderDetailView({
    _i10.Key? key,
    required int orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderDetailView,
        arguments: OrderDetailViewArguments(key: key, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNotificationsView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.notificationsView,
        arguments: NotificationsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderHistoryView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderHistoryView,
        arguments: OrderHistoryViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPromotionRequestsView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.promotionRequestsView,
        arguments: PromotionRequestsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPromotionRequestDetailView({
    _i10.Key? key,
    required int requestId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.promotionRequestDetailView,
        arguments: PromotionRequestDetailViewArguments(key: key, requestId: requestId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithWelcomeView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.welcomeView,
        arguments: WelcomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithForgotView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.forgotView,
        arguments: ForgotViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMainView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.mainView,
        arguments: MainViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderDetailView({
    _i10.Key? key,
    required int orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderDetailView,
        arguments: OrderDetailViewArguments(key: key, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNotificationsView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.notificationsView,
        arguments: NotificationsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderHistoryView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderHistoryView,
        arguments: OrderHistoryViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
