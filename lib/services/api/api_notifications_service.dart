import 'package:fpdart/fpdart.dart';

import '../../models/api_response.dart';
import '../../models/app_notification.dart';
import '../mock_data.dart';
import 'api_endpoints.dart';

/// Notifications HTTP layer (STUB — serves [MockData]).
class ApiNotificationsService {
  // final _dio = locator<DioService>().dio;

  /// GET [ApiEndpoints.notifications]
  /// Response: `{ "success": true, "data": { "notifications": [ <notif>, ... ] } }`
  /// `<notif>`:
  /// ```json
  /// { "id": 1, "group": "today", "tone": "brand", "icon": "bag",
  ///   "unread": true, "title": "…", "titleAr": "…", "body": "…",
  ///   "bodyAr": "…", "time": "8m", "timeAr": "٨ د" }
  /// ```
  Future<ApiResponse<List<AppNotification>>> fetchNotifications() async {
    // final res = await _dio.get(ApiEndpoints.notifications);
    // return ApiResponse<List<AppNotification>>.fromJson(res.data as Map<String, dynamic>, res.statusCode!,
    //     (d) => (d['notifications'] as List? ?? []).map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList());
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return ApiResponse<List<AppNotification>>.mock(MockData.notifications());
  }

  /// POST [ApiEndpoints.markNotificationRead]  → `{ "success": true }`
  Future<ApiResponse<Unit>> markRead(int id) async {
    // final res = await _dio.post(ApiEndpoints.markNotificationRead(id));
    // return ApiResponse<Unit>.fromJson(res.data as Map<String, dynamic>, res.statusCode!, (_) => unit);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return ApiResponse<Unit>.mock(unit);
  }

  /// POST [ApiEndpoints.markAllNotificationsRead]  → `{ "success": true }`
  Future<ApiResponse<Unit>> markAllRead() async {
    // final res = await _dio.post(ApiEndpoints.markAllNotificationsRead);
    // return ApiResponse<Unit>.fromJson(res.data as Map<String, dynamic>, res.statusCode!, (_) => unit);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return ApiResponse<Unit>.mock(unit);
  }
}
