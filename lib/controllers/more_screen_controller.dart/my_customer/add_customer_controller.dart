import 'package:get/get.dart';

class AddNewCustomerController extends GetxController {
  bool isLoading = true;
  @override
  void onInit() async {
    isLoading = false;
    update();
    super.onInit();
    update();
  }
}
