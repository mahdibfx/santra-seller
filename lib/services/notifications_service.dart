import 'package:fpdart/fpdart.dart';

import '../app/app.locator.dart';
import '../extensions/api_response_extension.dart';
import '../models/app_notification.dart';
import '../models/failure.dart';
import 'api/api_notifications_service.dart';

class NotificationsService {
  final _api = locator<ApiNotificationsService>();

  Future<Either<Failure, List<AppNotification>>> fetchNotifications() =>
      _api.fetchNotifications().toEither();

  Future<Either<Failure, int>> unreadCount() => _api.unreadCount().toEither();

  Future<Either<Failure, Unit>> markRead(int id) => _api.markRead(id).toEither();

  Future<Either<Failure, Unit>> markAllRead() => _api.markAllRead().toEither();
}
