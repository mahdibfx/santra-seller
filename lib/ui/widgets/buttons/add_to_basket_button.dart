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
          borderRadius: BorderRadius.circular(8),
          color: UIDataColors.blackColor),
      child: Row(
        children: [
          Text("add_basket".tr,
              style:
                  UIDataTextStyles.h2.copyWith(color: UIDataColors.whiteColor)),
          Spacer(),
          Text("AED 30",
              style:
                  UIDataTextStyles.h2.copyWith(color: UIDataColors.whiteColor))
        ],
      ).paddingSymmetric(horizontal: 12, vertical: 12),
    );
  }
}
