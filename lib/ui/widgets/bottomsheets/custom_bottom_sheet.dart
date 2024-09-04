import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santra_seller/utils/uidata.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key, required this.bottomsheetBody, this.padding});
  final Widget bottomsheetBody;
  final EdgeInsets? padding ;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      shadowColor: Colors.black,
      elevation: 20,
      backgroundColor: UIDataColors.whiteColor,
    enableDrag: false,
    
      onClosing: (){
       return ; 
    },builder: (context) =>Container(
      padding: padding?? EdgeInsets.symmetric(horizontal: 38.w).copyWith(top: 32.h),
      child: bottomsheetBody
),);
  }
}