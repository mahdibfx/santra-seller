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
      children: const [
        Text(
          "Product Name",
          style: UIDataTextStyles.h1,
        ),
        Text(
          "60 AED",
          style: UIDataTextStyles.h1Heavy,
        )
      ],
    );
  }
}
