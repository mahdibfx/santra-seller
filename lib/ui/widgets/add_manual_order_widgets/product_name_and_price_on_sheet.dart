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
        const Text(
          "Product Name",
          style: UIDataTextStyles.kHead,
        ),
        RichText(
          text: const TextSpan(
            text: 'AED',
            style: UIDataTextStyles.heading15Medium,
            children: <TextSpan>[
              TextSpan(text: "450", style: UIDataTextStyles.kHead),
            ],
          ),
        )
      ],
    );
  }
}
