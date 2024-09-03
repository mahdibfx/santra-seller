
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
       8.verticalSpace,
       OrderBarCodeWidget(),8.verticalSpace
      ],),
    );
  }
}