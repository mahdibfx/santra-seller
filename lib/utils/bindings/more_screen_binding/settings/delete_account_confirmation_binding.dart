import 'package:get/get.dart';

import 'package:santra_seller/controllers/settings_controller/change_password_controller.dart';
import 'package:santra_seller/controllers/settings_controller/delete_account_controller.dart';

class DeleteAccountConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteAccountController>(() => DeleteAccountController());
  }
}
