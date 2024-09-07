
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:santra_seller/utils/uidata.dart';

class OrderBarCodeWidget extends StatelessWidget {
  const OrderBarCodeWidget({
    super.key, required this.barcode,
  });
    final String barcode ; 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration( 
            color: Colors.grey.shade200,
      
      ),
      child: ListTile(
        title: Text(barcode),
        trailing: InkWell(
          onTap: () {
     Clipboard.setData(ClipboardData(text: barcode) );
     Fluttertoast.showToast(msg: "Text Copied !");
          },
          child: SvgPicture.asset(UIDATAIcons.copy)),
       leading: SvgPicture.asset(UIDATAIcons.barcodeScanIcon),
      ));
  }
}


