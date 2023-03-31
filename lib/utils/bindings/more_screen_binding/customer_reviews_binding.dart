import 'package:santra_seller/controllers/more_screen_controller.dart/customer_reviews_controller.dart';

import '/controllers/splash_controller.dart';
import 'package:get/get.dart';

class CustomerReviewsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerReviewsController>(() => CustomerReviewsController());
  }
}
