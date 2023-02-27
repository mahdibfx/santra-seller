import 'package:get/get.dart';

class MoreScreenController extends GetxController {
  bool isLoading = true;
  @override
  void onInit() async {
    isLoading = false;
    update();
    super.onInit();
    update();
  }
}