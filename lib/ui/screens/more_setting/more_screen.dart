// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:santra_seller/controllers/more_screen_controller.dart/more_controller.dart';

import '../../../controllers/home_controller/home_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class MoreSettingScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  MoreSettingScreen({super.key});

  Widget bodyData() {
    return GetBuilder<MoreScreenController>(
      builder: (_) {
        return _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingWithIcon(
                          icon: UIDATAIcons.moreHorizontal, btntxt: "More"),
                      SpacingHeight.heightlistspacing15,
                      ReusableIconSetting(
                        icon: UIDATAIcons.settingsIcon,
                        onPressed: () {
                          Get.toNamed(Routes.settings);
                        },
                        btntxt: 'settings',
                      ),
                      ReusableIconSetting(
                        icon: UIDATAIcons.dashboardIcon,
                        onPressed: () {},
                        btntxt: 'Products',
                      ),
                      ReusableIconSetting(
                        icon: UIDATAIcons.customersIcon,
                        onPressed: () {
                          Get.toNamed(Routes.mycustomerscreen);
                        },
                        btntxt: 'Customers List',
                      ),
                      ReusableIconSetting(
                        icon: UIDATAIcons.walletIcon,
                        onPressed: () {
                          Get.toNamed(Routes.walletscreen);
                        },
                        btntxt: 'Wallet',
                      ),
                      ReusableIconSetting(
                        icon: UIDATAIcons.whatsappIcon,
                        onPressed: () {
                          // Get.toNamed(Routes.walletscreen);
                        },
                        btntxt: 'Contact Customer Service',
                      ),
                      ReusableIconSetting(
                        icon: UIDATAIcons.santraVectorIcon,
                        onPressed: () {
                          Get.toNamed(Routes.aboutscreen);
                        },
                        btntxt: 'About Us',
                      ),
                      ReusableIconSetting(
                        icon: UIDATAIcons.securityIcon,
                        onPressed: () {
                          // Get.toNamed(Routes.contactscreen);
                        },
                        btntxt: 'Privacy Policy',
                      )
                    ],
                  ).paddingSymmetric(horizontal: 20),
                ),
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
      appTitle: 'Add customer',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.signuproutes);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
