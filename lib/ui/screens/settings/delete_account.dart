import 'package:santra_seller/controllers/settings_controller/change_email_controller.dart';
import 'package:santra_seller/controllers/settings_controller/delete_account_controller.dart';
import 'package:santra_seller/controllers/settings_controller/language_settings_controller.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class DeleteAccount extends StatelessWidget {
  DeleteAccount({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  Widget bodyData(context) {
    return GetBuilder<DeleteAccountController>(
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
                        icon: UIDATAIcons.deleteIcon, btntxt: "Delete Account"),
                    SpacingHeight.heightlistspacing15,
                    const Text(
                      "Can you please share to us what was not working? We are fixing bugs as soon as we spot them. if somthing slipped though our fingers, we'd be so grateful to be aware of it and fix it.",
                      style: UIDataTextStyles.title,
                    ),
                    SpacingHeight.heightlistspacing15,
                    CommonTextField(
                      maxlines: 5,
                      isTextHidden: false,
                      fillcolor: Colors.white,
                      keyboardType: TextInputType.phone,
                      hintText: "Your explanation is entirely optional",
                    ),
                    Form(
                        key: _.formDeleteAccScreen1,
                        child: CommonTextField(
                          controller: _.phoneController,
                          isTextHidden: false,
                          fillcolor: Colors.white,
                          keyboardType: TextInputType.phone,
                          labelText: "Your Mobile Number",
                          maxLength: 12,
                          validator: (val) {
                            String? name;
                            if (val.isEmpty || val.length < 12) {
                              return "Please Enter Valid Phone Number";
                            } else if (val.isNotEmpty && val.length > 3) {
                              name = val.substring(0, 3);

                              if (name != "971") {
                                return "Phone Number Must Start With 971";
                              }
                            } else {
                              return null;
                            }
                          },
                        )),
                    SpacingHeight.heightlistspacing5,
                    _.isOtpLoading
                        ? Center(child: CircularProgressIndicator())
                        : BorderButton(
                            btntxt: "Continue",
                            backEndColor: Colors.white,
                            borderColor: UIDataColors.secondaryColor,
                            buttontxtColor: UIDataColors.secondaryColor,
                            onPressed: () {
                              _.getOtp();
                              // Get.toNamed(Routes.deleteAccountConfirmation);
                            },
                          ),
                    SpacingHeight.heightlistspacing15,
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
        Get.offAllNamed(Routes.signuproutes);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
