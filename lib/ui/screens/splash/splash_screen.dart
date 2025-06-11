import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../provider/splash_provider.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata.dart';
import '../../widgets/scaffold/common_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  var tr = Get.put(AppTranslations());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashProvider.checkUpdateAndMakeDescision();
      splashProvider.setOldLang();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
