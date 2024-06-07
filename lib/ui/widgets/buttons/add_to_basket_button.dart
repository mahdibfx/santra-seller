import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class AddToBasketButton extends StatelessWidget {
  const AddToBasketButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTranslations>(builder: (context, tr, child) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: UIDataColors.blackColor),
        child: Row(
          children: [
            Text(tr.translateData("add_basket"),
                style: UIDataTextStyles.h2
                    .copyWith(color: UIDataColors.whiteColor)),
            const Spacer(),
            Text("AED 30",
                style: UIDataTextStyles.h2
                    .copyWith(color: UIDataColors.whiteColor))
          ],
        ).paddingSymmetric(horizontal: 12, vertical: 12),
      );
    });
  }
}
