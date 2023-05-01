import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:santra_seller/ui/screens/more_setting/about_us_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/contact_us/contact_us_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/privacy_policy_screen.dart';
import 'package:santra_seller/ui/screens/settings/language_screen.dart';
import '../../../utils/uidata/textStyles.dart';
import '/utils/uidata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ClipDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final homecont = Get.find<HomeController>();
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 40),
        decoration: const BoxDecoration(
          color: UIDataColors.whiteColor,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft, child: const CloseButton()
                    //  IconButton(
                    //   icon: Icon(
                    //     Icons.close,
                    //     color: UIDataColors.whiteColor,
                    //   ),
                    //   onPressed: () async {
                    //     Scaffold.of(context).closeEndDrawer();
                    //   },
                    // ),
                    ),
                Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        UIDataImage.sellerLogoIconSVG,
                        height: 40,
                        width: 40,
                        fit: BoxFit.fitWidth,
                      ),
                      SpacingHeight.heightlistspacing10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Santra",
                              style: UIDataTextStyles.h1
                                  .copyWith(fontSize: 20, letterSpacing: 2)),
                          Text("Seller",
                              style: UIDataTextStyles.h1.copyWith(
                                  fontSize: 14,
                                  letterSpacing: 2,
                                  color: UIDataColors.secondaryColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                SpacingHeight.heightlistspacing20,
                itemList(() {
                  Get.to(() => AboutUsScreen());
                }, UIDATAIcons.santraVectorIcon,  "side_menu_about_signin".tr),
                const Divider(
                  height: 30,
                ),
                itemList(() {
                  Get.to(() => ContactUsScreen());
                }, UIDATAIcons.whatsappIcon, "side_menu__contact_signin".tr),
                const Divider(
                  height: 30,
                ),
                itemList(() {
                  Get.to(() => const LanguageSettings());
                }, UIDATAIcons.languageIcon, "side_menu_language_signin".tr),
                const Divider(
                  height: 30,
                ),
                itemList(() {
                  Get.to(() => PrivacyScreen());
                }, UIDATAIcons.securityIcon, "side_menu_privacy_signin".tr),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemList(var onTap, String icon, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SpacingWidth.widthlistspacing,
          Text(title,
              style:
                  UIDataTextStyles.title.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 50, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
