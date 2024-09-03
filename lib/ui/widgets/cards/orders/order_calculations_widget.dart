import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';

class OrderCalculations extends StatelessWidget {
  final AppTranslations tr;
  final String? title;
  final String? amount;
  const OrderCalculations({
    super.key,
    required this.tr,
    this.amount,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(tr.translateData(title ?? ""),
            style: UIDataTextStyles.textMediumColoredBlue.copyWith(
              color: UIDataColors.blackColor,
            )),
        SpacingWidth.widthlistspacing,
        Text('$amount AED',
            style: UIDataTextStyles.textMediumColoredBlue.copyWith(
              color: UIDataColors.primaryColor,
            )),
      ],
    ).paddingOnly(
      right: Get.locale?.languageCode == "ar" ? 0 : 10,
      bottom: 8,
      left: Get.locale?.languageCode == "ar" ? 10 : 0,
    );
  }
}