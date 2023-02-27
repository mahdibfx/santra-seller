
import 'package:get/get.dart';
import '../../../controllers/more_screen_controller.dart/more_controller.dart';

class MoreScreenBindings extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut<MoreScreenController>(() => MoreScreenController());
  }

}