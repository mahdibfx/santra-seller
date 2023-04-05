import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/uidata.dart';

class VoucherTile extends StatelessWidget {
  int? index;
  String? icon;
  String? title;
  String? subtitle;
  String? buttonTitle;
  VoucherTile(
      {super.key,
      this.index,
      this.icon,
      required this.title,
      required this.subtitle,
      required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          border: Border.all(color: UIDataColors.primaryColor, width: 0.3),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            icon ?? UIDATAIcons.voucerReal,
            height: 23,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.7)),
              ),
              Text(
                subtitle ?? "",
                style: TextStyle(
                    fontSize: 12, color: Colors.black.withOpacity(0.8)),
              ),
            ],
          ),
        ),
        TextButton(
            onPressed: () {},
            // double.parse(value.vouchersList[index!].capAmount.toString()) >
            //         value.subTotal
            //     ? null
            //     : buttonTitle != "Apply"
            //         ? null
            //         : () {
            //             value.voucherTileDiscountMethod(index);
            //             if (buttonTitle == "Apply") {
            //               value.toggleApplied(index);
            //             }
            //           },
            child: Text(
              buttonTitle ?? "",
              style: const TextStyle(color: UIDataColors.grayColor),
            ))
      ]),
    ).paddingOnly(right: 15);
  }
}
