import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../utils/uidata.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../../provider/splash_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashProvider.checkUpdateAndMakeDescision();
      splashProvider.setOldLang();
    });

    super.initState();
  }

  Widget bodyData() {
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
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.whiteColor,
    );
  }
}
