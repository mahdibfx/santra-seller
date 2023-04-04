// ignore_for_file: depend_on_referenced_packages
import 'package:santra_seller/controllers/more_screen_controller.dart/about_us_controller.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class AboutUsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  AboutUsScreen({super.key});

  Widget bodyData() {
    return GetBuilder<AboutUsController>(
      builder: (_) {
        return _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                    child: _.hasAboutUsError
                        ? const Text(
                            "Something Went Wrong, Please Try Again In a While")
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeadingWithIcon(
                                  icon: UIDATAIcons.santraVectorIcon,
                                  btntxt: "About Us"),
                              Text(
                                _.aboutUsText ?? "No Data To Show",
                                style: UIDataTextStyles.title,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ).marginOnly(left: 20, right: 20)),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'About Us',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
