import 'dart:async';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../provider/setting_provider/language_settings_controller.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

var tr = Get.put(AppTranslations());

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  // final localization = AppTranslations();

  Widget bodyData(context) {
    return GetBuilder<AppTranslations>(builder: (tr) {
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
                          BorderButton(
                            onPressed: () {
                              setState(() {
                                _handleButtonTap();
                              });
                              _.setLanguage("ar_AE");
                              tr.setNewLanguage("ar_AE");
                            },
                            btntxt: "عربي",
                            backEndColor: Colors.white,
                            borderColor: tr.selectedLanguage == 'ar_AE'
                                ? UIDataColors.primaryColor
                                : Colors.transparent,
                            buttontxtColor: tr.selectedLanguage == 'ar_AE'
                                ? UIDataColors.primaryColor
                                : UIDataColors.blackColor,
                          ),
                          SpacingHeight.heightlistspacing15,
                          BorderButton(
                            onPressed: () {
                              _handleButtonTap();
                              _.setLanguage("en_us");
                              tr.setNewLanguage("en_us");
                            },
                            btntxt: "English",
                            backEndColor: Colors.white,
                            borderColor: tr.selectedLanguage == 'en_us'
                                ? UIDataColors.primaryColor
                                : Colors.transparent,
                            buttontxtColor: tr.selectedLanguage == 'en_us'
                                ? UIDataColors.primaryColor
                                : Colors.black,
                          ),
                          SpacingHeight.heightlistspacing15,
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
    Timer timer = Timer(const Duration(milliseconds: 1000), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
              height: 150,
              width: 300,
              color: Colors.transparent,
              child: const Center(
                  child: CircularProgressIndicator(
                color: UIDataColors.primaryColor,
              ))),
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
        tr.setNewLanguage(lang);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tr.setNewLanguage('en_us');
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
