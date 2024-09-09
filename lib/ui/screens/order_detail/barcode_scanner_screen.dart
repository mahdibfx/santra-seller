
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  const BarcodeScannerScreen({super.key, required this.orderNumber});
  final String orderNumber;
  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<BarcodeProvider>(context, listen: false)
        .chekCameraPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      showFAB: true,
      qrCallback: (){
Provider.of<BarcodeProvider>(context,listen: false).addBarcodeWithImage("33544566", Uint8List(35));
      },
      showAppBar: true, backgroundcolor: UIDataColors.whiteColor,
      appbarcolor: UIDataColors.whiteColor,
      showActions: false,
      backGroundImage: UIDataImage.backgroundImage,
      bodyData: Consumer<BarcodeProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else {
            return Column(
              children: [
                HeadingWithIcon(
                    icon: UIDATAIcons.barcodeScanIcon,
                    btntxt: tr.translateData("scan_barcode")),
                SpacingHeight.heightlistspacing20,

                ///this logic is used to either show the permissions enabling window or camera scanner
                if (!value.isCameraPermissionsGranted)
                  const CameraPermissionWidget(),
                if (value.isCameraPermissionsGranted)
                  const BarcodeScannerCamera(),

                16.verticalSpace,
                SizedBox(
                    width: 180.w,
                    child: Text(
                      tr.translateData("align_barcode_with_frame_to_scan"),
                      style: UIDataTextStyles.title,
                      textAlign: TextAlign.center,
                    )),
                20.verticalSpace,
                if (value.isCameraPermissionsGranted)
                  const BarcodesListWidget(),
                if (value.barcodes.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      value.resumeScanning();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tr.translateData("add_more"),
                          style: UIDataTextStyles.textMedium.copyWith(
                            color: UIDataColors.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        8.horizontalSpace,
                        const Icon(
                          Icons.add,
                          color: UIDataColors.primaryColor,
                        )
                      ],
                    ),
                  ),
                const Expanded(child: SizedBox()),
                value.linkingOrders
                    ? CupertinoActivityIndicator()
                    : BorderButton(
                        btntxt: value.barcodes.isEmpty &&
                                value.alreadyBarcodes.isNotEmpty
                            ? tr.translateData("save")
                            : tr.translateData("link_to_order"),
                        iconImage: UIDATAIcons.linkIcon,
                        onPressed: !compareArrays(
                                value.barcodes, value.alreadyBarcodes)
                            ? () {
                                value.linkBarcodesToOrder(widget.orderNumber);
                              }
                            : null,
                      ),
                24.verticalSpace,
              ],
            ).paddingSymmetric(horizontal: 16);
          }
        },
      ),
    );
  }

  bool compareArrays(List array1, List array2) {
    if (array1.length == array2.length) {
      return array1.every((value) => array2.contains(value));
    } else {
      return false;
    }
  }
}
