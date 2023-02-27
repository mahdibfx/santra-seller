library uidata;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'uidata/color.dart';
part 'uidata/image.dart';
part 'uidata/vector.dart';
part 'uidata/icon.dart';
part 'uidata/font.dart';
part 'uidata/spacingwidth.dart';
part 'uidata/spacingheight.dart';




class UIData {
  //strings
  static const String appName ="Santra Seller";


  //gneric
  static const String success = "Success";

  
//  Page Orientation Dimentions
  static final double responsiveHeight = (Get.height.ceil()).toDouble();
  static final double responsiveWidth = (Get.width.ceil()).toDouble();



}
