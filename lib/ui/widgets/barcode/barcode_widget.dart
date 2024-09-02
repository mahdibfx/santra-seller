import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/barcode/barcode_provider.dart';
import 'package:santra_seller/utils/uidata.dart';

class BarcodeWidget extends StatelessWidget {
  const BarcodeWidget({super.key, required this.barcode});
  final String barcode;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
          color: UIDataColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                blurRadius: 10, color: UIDataColors.blackColor.withOpacity(.1))
          ]),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 22.w),
        title: Text(barcode),
        trailing: IconButton(
            onPressed: () {
              Provider.of<BarcodeProvider>(context,listen: false).deleteBarcode(barcode);
            }, icon: SvgPicture.asset(UIDATAIcons.delete,color: UIDataColors.grayColor2,)),
      ),
    );
  }
}
