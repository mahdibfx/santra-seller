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
                    child: _.isCheckLanguage ? Center(child: CircularProgressIndicator()) : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadingWithIcon(
                              icon: UIDATAIcons.languageIcon,
                              btntxt: "side_menu_language_signin".tr),

                          Consumer<SplashProvider>(builder: (context, splashPro, child) {
                              return BorderButton(
                                onPressed: ()  {
                                   setState(() {
                                  _.isCheckLanguage = true;
                                  print(_.isCheckLanguage);
                                });
                                   _.setTrue("ar_AE");
                                  splashPro.setLanguage("ar_AE");
                                
                                  _.setFalseValue();
                                   Future.delayed(const Duration(seconds: 2),
          () {
            setState(() {
                                  _.isCheckLanguage = false;
                                  print(_.isCheckLanguage);
                                });
                              Get.back();
          });
                               
                                },
                                btntxt: "عربي",
                                backEndColor: Colors.white,
                                borderColor: Colors.transparent,
                                buttontxtColor: UIDataColors.blackColor,
                              );
                            }
                          ),
                          SpacingHeight.heightlistspacing15,
                          Consumer<SplashProvider>(builder: (context, splashPro, child) {
                              return BorderButton(
                                
                                onPressed: ()  {
                                setState(() {
                                  _.isCheckLanguage = true;
                                });
                                  _.setTrue("en_us");
                                  splashPro.setLanguage("en_us");
                                  _.setFalseValue();
                                  Future.delayed(const Duration(seconds: 2),
          () {
            setState(() {
                                  _.isCheckLanguage = false;
                                  print(_.isCheckLanguage);
                                });
                              Get.back();
          });
                                   
                                },
                                btntxt: "English",
                                backEndColor: Colors.white,
                                borderColor: UIDataColors.primaryColor,
                                buttontxtColor: UIDataColors.primaryColor,
                              );
                            }
                          ),

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
  }

  @override
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
