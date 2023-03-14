import 'package:flutter/material.dart';

import '../../../utils/uidata/textStyles.dart';

class PriceOnSelection extends StatelessWidget {
  var onPlus;
  var onMinus;
  PriceOnSelection({Key? key, required this.onMinus, required this.onPlus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Price On Selection",
          style: UIDataTextStyles.heading15Medium,
        ),
        const Spacer(),
        GestureDetector(
          onTap: onMinus,
          child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: const Icon(Icons.remove)),
        ),
        const Text(
          "2",
          style: UIDataTextStyles.h1Heavy,
        ),
        GestureDetector(
          onTap: onPlus,
          child: Container(
              padding: const EdgeInsets.only(left: 5),
              alignment: Alignment.centerRight,
              child: const Icon(Icons.add)),
        )
      ],
    );
  }
}
