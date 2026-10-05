import 'package:fpdart/fpdart.dart';

import '../../app/app.locator.dart';
import '../../models/api_response.dart';
import '../../models/app_notification.dart';
import '../dio_service.dart';
import 'api_endpoints.dart';

class ApiNotificationsService {
  final _dio = locator<DioService>().dio;

  Future<ApiResponse<List<AppNotification>>> fetchNotifications() async {
    final res = await _dio.get(ApiEndpoints.notifications);
    return ApiResponse<List<AppNotification>>.fromJson(
        res.data as Map<String, dynamic>,
        res.statusCode!,
        (d) => (d as List? ?? [])
            .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
            .toList());
  }

  Future<ApiResponse<int>> unreadCount() async {
    final res = await _dio.get(ApiEndpoints.unreadCount);
    return ApiResponse<int>.fromJson(
        res.data as Map<String, dynamic>,
        res.statusCode!,
        (d) => d is Map ? (d['count'] as int? ?? 0) : (d as int? ?? 0));
  }

  Future<ApiResponse<Unit>> markRead(int id) async {
    await _dio.patch(ApiEndpoints.markNotificationRead(id));
    return ApiResponse.mock(unit);
  }

  Future<ApiResponse<Unit>> registerDevice(
      {required String token, required String platform}) async {
    await _dio.post(ApiEndpoints.devices,
        data: {'token': token, 'platform': platform});
    return ApiResponse.mock(unit);
  }

  /// Stops pushes to this device for the account — call while still signed in.
  Future<ApiResponse<Unit>> unregisterDevice({required String token}) async {
    await _dio.delete(ApiEndpoints.devices, data: {'token': token});
    return ApiResponse.mock(unit);
  }

  Future<ApiResponse<Unit>> markAllRead() async {
    await _dio.post(ApiEndpoints.markAllNotificationsRead);
    return ApiResponse.mock(unit);
  }
}
