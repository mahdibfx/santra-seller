import 'package:get/get.dart';

class MyCustomerController extends GetxController {
  bool isLoading = true;
  @override
  void onInit() async {
    isLoading = false;
    update();
    super.onInit();
    update();
  }
}
