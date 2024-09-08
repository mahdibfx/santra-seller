import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:santra_seller/ui/widgets/bottomsheets/custom_bottom_sheet.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
final tr = Get.put(AppTranslations());
class LinkedSuccesfulyBottomsheet extends StatelessWidget {
  const LinkedSuccesfulyBottomsheet({super.key, required this.orderNumber});
final String orderNumber;
  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(bottomsheetBody:
    Column(children: [
      SvgPicture.asset(UIDATAIcons.done),
      16.verticalSpace,
      Text(tr.translateData("congrats"),style: UIDataTextStyles.h2,),
      16.verticalSpace,
     Text( "${tr.translateData("the_barcode_has_added")} $orderNumber",textAlign: TextAlign.center,style: UIDataTextStyles.dialogMsg,),
     16.verticalSpace,
     BorderButton(btntxt: tr.translateData("back"),onPressed: (){
      Navigator.of(context).pop();
      Navigator.of(context).pop();

     },)
    ],),);
  }
}