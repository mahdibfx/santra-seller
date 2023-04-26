// ignore_for_file: depend_on_referenced_packages

import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/screens/more_setting/about_us_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/contact_us/contact_us_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/customer_reviews.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/my_customer_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/privacy_policy_screen.dart';
import 'package:santra_seller/ui/screens/product_setting/product_setting_screen.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';
import '../settings/settings.dart';

class MoreSettingScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  MoreSettingScreen({super.key});

  Widget bodyData() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingWithIcon(icon: UIDATAIcons.moreHorizontal, btntxt: "More"),
            SpacingHeight.heightlistspacing15,
            ReusableIconSetting(
              icon: UIDATAIcons.settingsIcon,
              onPressed: () {
                Get.to(() => Settings());
              },
              btntxt: 'settings',
            ),
            ReusableIconSetting(
              icon: UIDATAIcons.dashboardIcon,
              onPressed: () {
                Get.to(() => ProductSettingScreen());
              },
              btntxt: 'Products',
            ),
            ReusableIconSetting(
              icon: UIDATAIcons.customersIcon,
              onPressed: () {
                Get.to(() => const MyCustomerScreen());
              },
              btntxt: 'Customers List',
            ),
            ReusableIconSetting(
              icon: UIDATAIcons.starIcon,
              onPressed: () {
                Get.to(() => CustomerReviews());
              },
              btntxt: 'Customer Reviews',
            ),
            // ReusableIconSetting(
            //   icon: UIDATAIcons.walletIcon,
            //   onPressed: () {
            //     Get.toNamed(Routes.walletscreen);
            //   },
            //   btntxt: 'Wallet',
            // ),
            ReusableIconSetting(
              icon: UIDATAIcons.whatsappIcon,
              onPressed: () {
                Get.to(() => ContactUsScreen());
              },
              btntxt: 'Contact Customer Service',
            ),
            ReusableIconSetting(
              icon: UIDATAIcons.santraVectorIcon,
              onPressed: () {
                Get.to(() => AboutUsScreen());
              },
              btntxt: 'About Us',
            ),
            ReusableIconSetting(
              icon: UIDATAIcons.securityIcon,
              onPressed: () {
                Get.to(() => PrivacyScreen());
              },
              btntxt: 'Privacy Policy',
            ),
            SpacingHeight.heightlistspacing50
          ],
        ).paddingSymmetric(horizontal: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
      isBackArrowShow: false,
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
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
