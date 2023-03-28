import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/uidata.dart';

import '../../../utils/uidata/textStyles.dart';

class PriceOnSelection extends StatelessWidget {
  var onPlus;
  var onMinus;
  var quantity;
  PriceOnSelection({Key? key, required this.onMinus, required this.onPlus, required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // const Text(
        //   "Price Upon Selection",
        //   style: UIDataTextStyles.heading15Medium,
        // ),
        const Spacer(),
        GestureDetector(
          onTap: onMinus,
          child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: UIDataColors.primaryColor)),
              padding: const EdgeInsets.all(2),
              alignment: Alignment.center,
              child: const Icon(Icons.remove)),
        ),
         Text(
         quantity,
          style: UIDataTextStyles.h1Heavy,
        ).paddingSymmetric(horizontal: 10),
        GestureDetector(
          onTap: onPlus,
          child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: UIDataColors.primaryColor)),
              padding: const EdgeInsets.all(2),
              alignment: Alignment.center,
              child: const Icon(Icons.add)),
        )
      ],
    );
  }
}
