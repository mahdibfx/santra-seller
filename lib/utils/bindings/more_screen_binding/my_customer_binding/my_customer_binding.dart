
import 'package:get/get.dart';
import '../../../../controllers/more_screen_controller.dart/my_customer/my_customer_controller.dart';

class MyCustomerBindings extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut<MyCustomerController>(() => MyCustomerController());
  }

}