// ignore_for_file: depend_on_referenced_packages
import 'package:santra_seller/controllers/more_screen_controller.dart/about_us_controller.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/privacy_controller.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class PrivacyScreen extends StatelessWidget {
  PrivacyScreen({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Widget bodyData() {
    return GetBuilder<PrivacyController>(
      builder: (_) {
        return _.isPrivacyLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                    child: _.hasPrivacyError
                        ? const Text(
                            "Something Went Wrong, Please Try Again In a While")
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeadingWithIcon(
                                  icon: UIDATAIcons.santraVectorIcon,
                                  btntxt: "Privacy Policy"),
                              Obx(
                                () => Text(
                                  _.msg.value,
                                  style: UIDataTextStyles.title,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              SpacingHeight.heightlistspacing50
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
        Get.offAll(() =>  const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
