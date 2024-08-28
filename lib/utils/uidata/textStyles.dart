import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_translation/app_translation.dart';
import '../uidata.dart';

var tr = Get.put(AppTranslations());

class UIDataTextStyles {
  static var counth1 = TextStyle(
    fontSize: 32,
    fontFamily: tr.getFont(),
    letterSpacing: 0.0,
  );
  static var counth2 = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var countTitle = TextStyle(
    fontSize: 16,
    fontFamily: tr.getFont(),
    letterSpacing: 0.0,
  );
  static var h1Heavy = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var h1 = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var h2 = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var title = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);

  static var title13Normal = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var caption = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var subTitle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var subTitleMedium = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var dialogTitle = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var dialogMsg = TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var dialogButton = TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var heading15Medium = TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w500,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);

  static var kHead = TextStyle(
    fontFamily: tr.getFont(),
    fontSize: 25.0,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static var rating = TextStyle(
    fontFamily: tr.getFont(),
    fontSize: 32.0,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static var textMedium = TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);

  static var textMediumColoredBlue = TextStyle(
      color: UIDataColors.primaryColor,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
  static var dateStyle = const TextStyle(
      color: UIDataColors.primaryColor,
      fontSize: 15,
      fontWeight: FontWeight.bold,
      // fontFamily: tr.getFont(),
      letterSpacing: 0.0);

  static var monthStyle = const TextStyle(
      color: UIDataColors.primaryColor,
      fontSize: 12,
      // fontWeight: FontWeight.bold,
      // fontFamily: tr.getFont(),
      letterSpacing: 0.0);

  static var dayStyle = const TextStyle(
      color: UIDataColors.primaryColor,
      fontSize: 15,
      // fontWeight: FontWeight.bold,
      // fontFamily: tr.getFont(),
      letterSpacing: 0.0);

  static var h3 = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      fontFamily: tr.getFont(),
      letterSpacing: 0.0);
}
