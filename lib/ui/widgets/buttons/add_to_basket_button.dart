import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class AddToBasketButton extends StatelessWidget {
  const AddToBasketButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: UIDataColors.black),
      child: Row(
        children: const [
          Text(
            "Add To Basket",
            style: UIDataTextStyles.headingbtn,
          ),
          Spacer(),
          Text(
            "AED 30",
            style: UIDataTextStyles.headingbtn,
          )
        ],
      ).paddingSymmetric(horizontal: 12, vertical: 12),
    );
  }
}
