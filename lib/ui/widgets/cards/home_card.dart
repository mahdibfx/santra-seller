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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
              border: Border.all(color: Colors.blue)),
          child: Column(
            children: [
              SizedBox(
                height: 140,
                child: SvgPicture.asset(
                  imageAsset,
                  fit: BoxFit.fitWidth,
                ),
              ).marginOnly(left: 20, right: 20, top: 10),
              SpacingHeight.heightlistspacing10,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: UIDataTextStyles.caption
                        .copyWith(color: UIDataColors.primaryColor),
                  ),
                  const Spacer(),
                  Text(
                    count,
                    style: UIDataTextStyles.counth2.copyWith(fontSize: 16),
                  ),
                ],
              ).marginOnly(left: 10, right: 10, bottom: 10),
            ],
          ),
        ),
      ),
    );
  }
}
