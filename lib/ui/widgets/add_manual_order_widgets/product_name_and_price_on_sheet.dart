import 'package:flutter/material.dart';

import '../../../utils/uidata/textStyles.dart';

class ProductNameAndPriceOnSheet extends StatelessWidget {
  String? productName;
  String? productPrice;
  ProductNameAndPriceOnSheet(
      {Key? key, required this.productName, required this.productPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          productName ?? "",
          style: UIDataTextStyles.h2.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          "${productPrice ?? ""} AED",
          style: UIDataTextStyles.h1Heavy,
        )
      ],
    );
  }
}
