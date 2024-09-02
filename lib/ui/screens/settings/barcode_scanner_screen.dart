import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/barcode/barcode_provider.dart';
import 'package:santra_seller/ui/widgets/barcode/barcode_scanner_camera.dart';
import 'package:santra_seller/ui/widgets/barcode/barcodes_list_widget.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/barcode/camera_permission_widget.dart';
import 'package:santra_seller/ui/widgets/scaffold/common_scaffold.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
var tr = Get.put(AppTranslations());

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<BarcodeProvider>(context,listen: false).chekCameraPermissions();
  }
  @override
  Widget build(BuildContext context) {
    return  CommonScaffold(showAppBar: true,      backgroundcolor: UIDataColors.whiteColor,
      appbarcolor: UIDataColors.whiteColor,
showActions: false,
      backGroundImage: UIDataImage.backgroundImage,
      bodyData: Consumer<BarcodeProvider>(
        builder: (context, value, child) {
          if(value.isLoading) {
            return Center(child: CupertinoActivityIndicator(),);
          } else {
return Column(children: [
            HeadingWithIcon(
                                  icon: UIDATAIcons.barcodeScanIcon,
                                  
                                  btntxt:"Scan Barcode"),
                              SpacingHeight.heightlistspacing20,
                           if(!value.isCameraPermissionsGranted)   CameraPermissionWidget(),
                           if(value.isCameraPermissionsGranted) BarcodeScannerCamera(),
                            16.verticalSpace,
                              Container(
                                width: 180.w,
                                child: Text("Align barcode with frame to scan",style: UIDataTextStyles.title,textAlign: TextAlign.center,)),
                         20.verticalSpace,
                           if(value.isCameraPermissionsGranted) BarcodesListWidget(),
                                
                                Expanded(child: SizedBox()),
                                BorderButton(btntxt: "Link to order",iconImage: UIDATAIcons.linkIcon,),
                                24.verticalSpace,
        ],).paddingSymmetric(horizontal: 16);
 
          }
        },
   ),
      );
  }
}