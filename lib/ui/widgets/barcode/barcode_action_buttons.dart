
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:santra_seller/ui/screens/settings/barcode_scanner_screen.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/raised_gradient_button.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';

class ActionButtonsBarcode extends StatelessWidget {
  const ActionButtonsBarcode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppTranslations>(
      builder:(tr)=> Container(
        margin: EdgeInsets.all( 16),
        child: Row(
          children: [
            Expanded(
              child: BorderButton(
                onPressed: () {},
                btntxt: tr.translateData("button_cancel"),
                buttontxtColor: UIDataColors.redColor,
                borderColor: UIDataColors.redColor,
                backEndColor: UIDataColors.whiteColor,
              ),
            ),
            SizedBox(width: 16,),
            Expanded(
                child: RaisedGradientButton(
              btntxt: 'Scan Barcode',
              buttontxtColor: UIDataColors.whiteColor,
              onPressed: (){
                Get.to(()=>BarcodeScannerScreen());
              },
              gradient: const LinearGradient(
                colors: <Color>[
                  UIDataColors.primaryColor,
                  UIDataColors.primaryColor,
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
