import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/myApp.dart';
import 'package:santra_seller/provider/barcode/barcode_provider.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';

class CameraPermissionWidget extends StatelessWidget {
  const CameraPermissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      height: 233.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(image: AssetImage(UIDataImage.barcode))),
      child: Container(
        decoration: BoxDecoration(
          color: UIDataColors.blackColor.withOpacity(.8),
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _cameraIcon(),
           10.verticalSpace,

            Text("Camera Access",style: UIDataTextStyles.title.copyWith(color: UIDataColors.whiteColor,fontWeight: FontWeight.w500)),
            Container(
              width: 220.w,
              child: Text('We need to enable camera so you can scan barcodes',style: UIDataTextStyles.textMedium.copyWith(color: UIDataColors.whiteColor,fontWeight: FontWeight.w400,),textAlign: TextAlign.center,))
         ,
           10.verticalSpace,
         
         Container(
          width: 230.w,
          child: BorderButton(btntxt: "Enable Camera",onPressed: () {
            Provider.of<BarcodeProvider>(context,listen: false).demandPermissions();
          },)),
          ],
        ),
      ),
    );
  }

  Container _cameraIcon() {
    return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                
                color: UIDataColors.primaryColor),
            child: SvgPicture.asset(UIDATAIcons.camera),
          );
  }
}
