import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';
import 'api/api_notifications_service.dart';

/// Android needs a channel for heads-up notifications; iOS shows them itself.
const AndroidNotificationChannel kPushChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

/// Push notifications: permission, token registration, and what a tap opens.
///
/// A message's `data` carries `action` (e.g. `refund_bank_details`),
/// `referenceType` + `referenceId`, and `orderId` — a tap on anything about an
/// order opens that order.
class PushService {
  final _api = locator<ApiNotificationsService>();

  String? _token;
  String? get token => _token;

  bool _started = false;

  /// Call once the partner is logged in — registering a device token before
  /// that would attach it to no account.
  Future<void> start() async {
    if (_started) return;
    _started = true;

    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _registerToken();
    FirebaseMessaging.instance.onTokenRefresh.listen(_sendToken);

    FirebaseMessaging.onMessage.listen(_showForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(_openFrom);

    // Opened from terminated by tapping a notification.
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _openFrom(initial);
  }

  /// Stops this device receiving pushes for the account being signed out.
  /// Must run BEFORE `/auth/logout`: the DELETE needs the still-valid token.
  Future<void> stop() async {
    _started = false;
    try {
      final token = _token ?? await FirebaseMessaging.instance.getToken();
      if (token != null) await _api.unregisterDevice(token: token);
    } catch (e) {
      log('push: unregister failed: $e');
    }
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      log('push: deleteToken failed: $e');
    }
    _token = null;
  }

  Future<void> _registerToken() async {
    try {
      if (Platform.isIOS) {
        // iOS cannot mint an FCM token until APNs has handed one over, and
        // that lands a moment after permission is granted. Asking too early
        // returns null, this launch registers nothing, and the shop silently
        // gets no pushes until some later launch happens to be luckier.
        for (var i = 0; i < 8; i++) {
          if (await FirebaseMessaging.instance.getAPNSToken() != null) break;
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
      }
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _sendToken(token);
      } else {
        log('push: no FCM token — APNs not configured, or the simulator');
      }
    } catch (e) {
      // No APNs token (simulator, permission refused, missing APNs key) —
      // never fatal, the in-app notification list still works.
      log('push: getToken failed: $e');
    }
  }

  Future<void> _sendToken(String token) async {
    _token = token;
    final result = await _api
        .registerDevice(
            token: token, platform: Platform.isIOS ? 'ios' : 'android')
        .toEitherLogged();
    log('push: device registered=$result');
  }

  Future<void> _showForeground(RemoteMessage message) async {
    final n = message.notification;
    if (n == null) return;
    await localNotifications.show(
      id: n.hashCode,
      title: n.title,
      body: n.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          kPushChannel.id,
          kPushChannel.name,
          importance: Importance.high,
          priority: Priority.high,
          // Same white silhouette as the launch-time default. Without it a
          // foreground notification falls back to the app icon, which Android
          // renders as a white square.
          icon: 'ic_notification',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: orderIdOf(message.data)?.toString(),
    );
  }

  /// Everything the partner API pushes today is about one order.
  void _openFrom(RemoteMessage message) => openOrder(orderIdOf(message.data));

  static void openOrder(int? id) {
    if (id == null) return;
    locator<NavigationService>().navigateToOrderDetailView(orderId: id);
  }

  /// `orderId`, or `referenceId` when `referenceType` is an order.
  static int? orderIdOf(Map<String, dynamic> data) {
    final raw = data['orderId'] ??
        (data['referenceType'] == 'order' ? data['referenceId'] : null);
    return raw == null ? null : int.tryParse(raw.toString());
  }
}

extension on Future<dynamic> {
  /// Device registration is best-effort: a failure must never block login.
  Future<bool> toEitherLogged() async {
    try {
      await this;
      return true;
    } catch (e) {
      log('push: device registration failed: $e');
      return false;
    }
  }
}

/// Tapping a notification the app itself raised while in the foreground.
@pragma('vm:entry-point')
void onLocalNotificationTap(NotificationResponse response) =>
    PushService.openOrder(int.tryParse(response.payload ?? ''));
