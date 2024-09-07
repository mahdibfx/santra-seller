
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/barcode/barcode_provider.dart';
import 'package:santra_seller/ui/widgets/barcode/order_barcode_widget.dart';

class OrderLinkedBarCodes extends StatelessWidget {
  const OrderLinkedBarCodes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     color: Colors.white,
      child: Column(children: [
  Consumer<BarcodeProvider>(
    builder: (context,provider,_) {
    return   provider.isLoading ?  const SizedBox():
       ListView.builder(itemBuilder: (context, index) => Padding(
        padding:  EdgeInsets.symmetric(vertical: 4.h),
        child:  OrderBarCodeWidget(barcode: provider.alreadyBarcodes[index],),
      ),itemCount: provider.alreadyBarcodes.length,shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),);
    }
  )
      ],),
    );
  }
}