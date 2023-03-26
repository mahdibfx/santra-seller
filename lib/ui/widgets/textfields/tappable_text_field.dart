import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TappableTextField extends StatelessWidget {
  String? heading;
  double? fieldHeight;
  String? value;
  String? prefixIcon;
  var ontap;
  TappableTextField(
      {Key? key,
      this.heading,
      this.fieldHeight,
      required this.value,
      this.prefixIcon,
      required this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 7,
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: fieldHeight,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: const Color(0xff757575).withOpacity(0.7))),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  prefixIcon ?? "",
                ).paddingSymmetric(vertical: 11, horizontal: 12),
                Text(
                  value!,
                  style: const TextStyle(fontSize: 16),
                ),
                // const Spacer(),
                // GestureDetector(
                //   child: SvgPicture.asset(
                //     prefixIcon ?? "",
                //   ).paddingSymmetric(vertical: 11, horizontal: 0),
                // ),
              ],
            ).paddingOnly(right: 14),
          ),
        ],
      ),
    );
  }
}
