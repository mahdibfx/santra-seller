import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class HomeCardWidget extends StatelessWidget {
  final String heading;
  final String count;
  final String imageAsset;
  final void Function() onTap;
  const HomeCardWidget(
      {super.key,
      required this.heading,
      required this.count,
      required this.onTap,
      required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: size.height * 0.25,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
              border: Border.all(color: Colors.blue)),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: size.height * 0.15,
                  child: SvgPicture.asset(
                    imageAsset,
                    fit: BoxFit.fill,
                  ),
                ).marginOnly(left: 0, right: 0, top: 0),
                // const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      heading,
                      style: UIDataTextStyles.h2.copyWith(
                          color: UIDataColors.primaryColor, fontSize: 13),
                    ),
                    // const Spacer(),
                    Text(
                      count,
                      style: UIDataTextStyles.counth1.copyWith(fontSize: 18),
                    ),
                  ],
                ).marginOnly(left: 10, right: 10, bottom: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
