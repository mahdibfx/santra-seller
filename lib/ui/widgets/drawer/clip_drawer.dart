import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/more_setting/about_us_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/contact_us/contact_us_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/privacy_policy_screen.dart';
import 'package:santra_seller/ui/screens/settings/language_screen.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata/textStyles.dart';
import '/utils/uidata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ClipDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final homecont = Get.find<HomeController>();
    return GetBuilder<AppTranslations>(
      builder: (tr) {
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
                    // Container(
                        // alignment: Alignment.centerLeft, child: const CloseButton()
                        Row(
                          mainAxisAlignment: Get.locale!.languageCode == 'en' ?MainAxisAlignment.start : MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                               onTap: () async {
                                  Scaffold.of(context).closeEndDrawer();
                                },
                              child: Container(height: 32,width: 32,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.13),
                                borderRadius: BorderRadius.all(Radius.circular(16))
                              ),
                                                   child:  Center(
                              child: Icon(
                                size:22,
                                  Icons.close_sharp,
                                  color: UIDataColors.blackColor,
                                ),
                               
                                
                                                   ),
                              ),
                            ),
                          ],
                        ).paddingOnly(top: 20),
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                          Get.locale!.languageCode == 'en'
                              ? UIDataImage.santraLogoEnglish
                              : UIDataImage.santraLogoArabic,
                          height: 79,
                          width: 63,
                          fit: BoxFit.fitWidth,
                        ),
                         
                        ],
                      ),
                    ),
                    SpacingHeight.heightlistspacing35,
                    itemList(() {
                      Get.to(() => AboutUsScreen());
                    }, UIDATAIcons.santraVectorIcon,  tr.translateData("side_menu_about_signin")),
                    const Divider(
                      height: 30,
                    ),
                    itemList(() {
                      Get.to(() => ContactUsScreen());
                    }, UIDATAIcons.whatsappIcon, tr.translateData("side_menu__contact_signin")),
                    const Divider(
                      height: 30,
                    ),
                    itemList(() {
                      Get.to(() => const LanguageSettings());
                    }, UIDATAIcons.languageIcon, Get.locale!.languageCode == 'en' ? 'اللغة' : 'Language'),
                    const Divider(
                      height: 30,
                    ),
                    itemList(() {
                      Get.to(() => PrivacyScreen());
                    }, UIDATAIcons.securityIcon, tr.translateData("side_menu_privacy_signin")),
                  ],
                ),
              ),
            ),
          ),
        );
      }
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
