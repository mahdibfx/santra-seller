import 'dart:ui';

import '/utils/uidata.dart';
import 'package:get/get.dart';

class CommonSnackbar
{
  static void getSnackbar(String title, String message, Color snackbarColor) {
    Get.snackbar(
      title,
      message,
      colorText: UIDataColors.white,
      backgroundColor: snackbarColor,
    );
  }
}