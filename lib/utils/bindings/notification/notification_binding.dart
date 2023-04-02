import 'package:get/get.dart';
import 'package:santra_seller/controllers/notification/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}
