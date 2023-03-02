import 'package:get/get.dart';
import 'package:santra_seller/controllers/settings_controller/account_info_controller.dart';

class AccountInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountInfoController>(() => AccountInfoController());
  }
}
