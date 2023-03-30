import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/uidata.dart';

class CustomerReviewsController extends GetxController {
  bool isLoading = true;
  List<Color> barColors = [
    UIDataColors.green,
    UIDataColors.greenLite,
    UIDataColors.amber,
    UIDataColors.pink,
    UIDataColors.orange,
  ];
  List<int> noOfStars = [5, 4, 3, 2, 1];
  @override
  void onInit() async {
    isLoading = false;
    update();
    super.onInit();
    update();
  }
}
