
import 'package:get/get.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/my_customer/edit_customer_details_controller.dart';

class EditCustomerBindings extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut<EditCustomerController>(() => EditCustomerController());
  }

}