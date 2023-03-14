import 'package:flutter/material.dart';

import '../../../utils/uidata/textStyles.dart';

class ProductNameAndPriceOnSheet extends StatelessWidget {
  const ProductNameAndPriceOnSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Product Name",
          style: UIDataTextStyles.h2.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          "60 AED",
          style: UIDataTextStyles.h1Heavy,
        )
      ],
    );
  }
}
