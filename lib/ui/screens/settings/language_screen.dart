import 'dart:async';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../provider/setting_provider/language_settings_controller.dart';

import '../../../provider/splash_provider.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  // final localization = AppTranslations();

  Widget bodyData(context) {
    return Consumer<AppTranslations>(builder: (context, tr, child) {
      return Consumer<LangaugeSettingsProvider>(
        builder: (context, _, child) {
          return SafeArea(
            child: _.isLoadings
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: Get.height / 1.1,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadingWithIcon(
                              icon: UIDATAIcons.languageIcon,
                              btntxt: tr
                                  .translateData("side_menu_language_signin")),

                          Consumer<AppTranslations>(
                              builder: (context, tr, child) {
                            return BorderButton(
                              onPressed: () {
                                setState(() {
                                  _handleButtonTap();
                                  _.isCheckLanguage = true;
                                });
                                _.setTrue("ar_AE");
                                tr.setNewLanguage("ar_AE");

                                _.setFalseValue();
                              },
                              btntxt: "عربي",
                              backEndColor: Colors.white,
                              borderColor: tr.selectedLanguage == 'ar_AE'
                                  ? UIDataColors.primaryColor
                                  : Colors.transparent,
                              buttontxtColor: tr.selectedLanguage == 'ar_AE'
                                  ? UIDataColors.primaryColor
                                  : UIDataColors.blackColor,
                            );
                          }),
                          SpacingHeight.heightlistspacing15,
                          Consumer<AppTranslations>(
                              builder: (context, tr, child) {
                            return BorderButton(
                              onPressed: () {
                                _handleButtonTap();
                                setState(() {
                                  _.isCheckLanguage = true;
                                });
                                _.setTrue("en_us");
                                tr.setNewLanguage("en_us");
                                _.setFalseValue();
                                Future.delayed(const Duration(seconds: 2), () {
                                  setState(() {
                                    _.isCheckLanguage = false;
                                    print(_.isCheckLanguage);
                                  });

                                  // Get.back();
                                });
                              },
                              btntxt: "English",
                              backEndColor: Colors.white,
                              borderColor: tr.selectedLanguage == 'en_us'
                                  ? UIDataColors.primaryColor
                                  : Colors.transparent,
                              buttontxtColor: tr.selectedLanguage == 'en_us'
                                  ? UIDataColors.primaryColor
                                  : Colors.black,
                            );
                          }),

                          SpacingHeight.heightlistspacing15,
                          // Obx(() => _.isLoading
                          //         ? const Center(
                          //             child: CircularProgressIndicator(),
                          //           )
                          //         :
                          // PrimaryButtonWithIcon(
                          //   btntxt: "Save",
                          //   iconImage: UIDATAIcons.saveIcon,
                          //   onPressed: () {},
                          // )

                          //),
                        ],
                      ).marginOnly(left: 20.0, right: 20.0),
                    ),
                  ),
          );
        },
      );
    });
  }

  void _handleButtonTap() {
    Timer timer = Timer(Duration(milliseconds: 3000), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
              height: 150,
              width: 300,
              color: Colors.white,
              child: Center(child: CircularProgressIndicator())),
        );
      },
    ).then((value) {
      // dispose the timer in case something else has triggered the dismiss.
      timer.cancel();
      // timer = null;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLang();
  }

  checkLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var checkLange = prefs.get("selectedlanguage");
    if (checkLange != null) {
      String lang = prefs.get("selectedlanguage") as String;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AppTranslations>(context, listen: false)
            .setNewLanguage(lang);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AppTranslations>(context, listen: false)
            .setNewLanguage('en_us');
      });
    }
  }

  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      // scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: '',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
