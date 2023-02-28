
import 'package:get/get.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/my_customer/add_customer_controller.dart';

class AddNewCustomerBindings extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut<AddNewCustomerController>(() => AddNewCustomerController());
  }

}