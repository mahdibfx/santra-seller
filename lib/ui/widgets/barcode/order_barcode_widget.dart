
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:santra_seller/utils/uidata.dart';

class OrderBarCodeWidget extends StatelessWidget {
  const OrderBarCodeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration( 
            color: Colors.grey.shade200,
      
      ),
      child: ListTile(
        title: Text("5494877857846"),
        trailing: InkWell(
          onTap: () {
     Clipboard.setData(ClipboardData(text: "5494877857846") );
     Fluttertoast.showToast(msg: "Text Copied !");
          },
          child: SvgPicture.asset(UIDATAIcons.copy)),
       leading: SvgPicture.asset(UIDATAIcons.barcodeScanIcon),
      ));
  }
}


