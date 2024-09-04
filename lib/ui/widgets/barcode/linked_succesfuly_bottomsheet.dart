import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:santra_seller/ui/widgets/bottomsheets/custom_bottom_sheet.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';

class LinkedSuccesfulyBottomsheet extends StatelessWidget {
  const LinkedSuccesfulyBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(bottomsheetBody:
    Column(children: [
      SvgPicture.asset(UIDATAIcons.done),
      16.verticalSpace,
      Text("Congratulations!",style: UIDataTextStyles.h2,),
      16.verticalSpace,
     Text( "The barcode has been successfuly added to order Number 1324",textAlign: TextAlign.center,style: UIDataTextStyles.dialogMsg,),
     16.verticalSpace,
     BorderButton(btntxt: "Back",onPressed: (){
      Navigator.of(context).pop();
     },)
    ],),);
  }
}