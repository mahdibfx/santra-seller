import 'package:santra_seller/controllers/settings_controller/change_email_controller.dart';
import 'package:santra_seller/controllers/settings_controller/language_settings_controller.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class LanguageSettings extends StatelessWidget {
  LanguageSettings({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  Widget bodyData(context) {
    return GetBuilder<LangaugeSettingsController>(
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height / 1.1,
              ),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingWithIcon(
                        icon: UIDATAIcons.languageIcon, btntxt: "Language"),
                    SpacingHeight.heightlistspacing10,
                    BorderButton(
                      btntxt: "عربي",
                      backEndColor: Colors.white,
                      borderColor: Colors.transparent,
                      buttontxtColor: UIDataColors.blackColor,
                    ),
                    SpacingHeight.heightlistspacing15,
                    BorderButton(
                      btntxt: "English",
                      backEndColor: Colors.white,
                      borderColor: UIDataColors.primaryColor,
                      buttontxtColor: UIDataColors.primaryColor,
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
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: '',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
