import 'package:flutter_svg/svg.dart';

import '../../../utils/uidata.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '/controllers/splash_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Widget bodyData() {
    return GetBuilder<SplashController>(
      builder: (_) {
        return Center(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: SvgPicture.asset(
              UIDataImage.splashScreenImage,
              fit: BoxFit.fitWidth,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.commonColor,
    );
  }
}
