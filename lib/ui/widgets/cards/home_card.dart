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
          height: size.height * 0.26,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
              border: Border.all(color: Colors.blue)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 140,
                  child: SvgPicture.asset(
                    imageAsset,
                    fit: BoxFit.fitWidth,
                  ),
                ).marginOnly(left: 20, right: 20, top: 10),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      heading,
                      style: UIDataTextStyles.h2
                          .copyWith(color: UIDataColors.primaryColor),
                    ),
                    const Spacer(),
                    Text(
                      count,
                      style: UIDataTextStyles.counth1.copyWith(fontSize: 18),
                    ),
                  ],
                ).marginOnly(left: 10, right: 10, bottom: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
