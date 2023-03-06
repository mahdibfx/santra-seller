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
                      Row(
                        children: const [
                          Icon(Icons.menu),
                          SpacingWidth.widthlistspacing,
                           Text(
                            'More',
                            textScaleFactor: 2,
                          ),
                        ],
                      ),
                      SpacingHeight.heightlistspacing20,
                      ReusableIconSetting(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Get.toNamed(Routes.settings);
                        },
                        btntxt: const Text('settings'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.business),
                        onPressed: () {
                          Get.toNamed(Routes.aboutscreen);
                        },
                        btntxt: const Text('About Us'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.widgets),
                        onPressed: () {},
                        btntxt: const Text('Products'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.group),
                        onPressed: () {
                          Get.toNamed(Routes.mycustomerscreen);
                        },
                        btntxt: const Text('My Customers'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.message),
                        onPressed: () {
                          Get.toNamed(Routes.cartroute);
                        },
                        btntxt: const Text('Get Help'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.wallet),
                        onPressed: () {
                          Get.toNamed(Routes.walletscreen);
                        },
                        btntxt: const Text('Wallet'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.call),
                        onPressed: () {
                          Get.toNamed(Routes.contactscreen);
                        },
                        btntxt: const Text('Contact Us'),
                      )
                    ],
                  ).marginAll(10),
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
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.white,
      appTitle: 'Add customer',
      backarrow: UIDataColors.black,
      qrCallback: () {
        Get.offAllNamed(Routes.signuproutes);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
