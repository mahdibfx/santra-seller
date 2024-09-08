
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/barcode/barcode_provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/ui/screens/order_detail/barcode_scanner_screen.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/raised_gradient_button.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';

class ActionButtonsBarcode extends StatelessWidget {
  const ActionButtonsBarcode({
    super.key, required this.orderNumber, required this.isModifying, required this.showCancelButton,
  });
  final String orderNumber ; 
  final bool isModifying;
  final bool showCancelButton ; 
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppTranslations>(
      builder:(tr)=> Container(
        margin: const EdgeInsets.all( 16),
        child: Row(
          children: [
       if(showCancelButton)     Expanded(
              child: BorderButton(
                onPressed: () {
                  Provider.of<HomeProvider>(context,listen: false).cancelOrdermethod(orderNumber);
                },
                btntxt: tr.translateData("button_cancel"),
                buttontxtColor: UIDataColors.redColor,
                borderColor: UIDataColors.redColor,
                backEndColor: UIDataColors.whiteColor,
              ),
            ),
                 if(showCancelButton)  const SizedBox(width: 16,),
            Expanded(
                child: RaisedGradientButton(
              btntxt:tr.translateData( isModifying ? "change_barcode": 'scan_barcode'),
              buttontxtColor: UIDataColors.whiteColor,
              onPressed: (){
               Provider.of<BarcodeProvider>(context,listen: false).loadExistingBarCodesToFrontendForModification();
                Get.to(()=>ChangeNotifierProvider.value(value:  Provider.of<BarcodeProvider>(context),child:  BarcodeScannerScreen(orderNumber: orderNumber,)));
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
