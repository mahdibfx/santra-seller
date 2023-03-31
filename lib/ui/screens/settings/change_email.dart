import 'package:santra_seller/controllers/settings_controller/change_email_controller.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class ChangeEmail extends StatelessWidget {
  ChangeEmail({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  Widget bodyData(context) {
    return GetBuilder<ChangeEmailController>(
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height / 1.1,
              ),
              child: Form(
                key: _.form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingWithIcon(
                        icon: UIDATAIcons.infoIcon, btntxt: "Change Email"),
                    SpacingHeight.heightlistspacing15,
                    CommonTextField(
                      controller: _.emailController,
                      labelText: "New Email",
                      prefixIcon: UIDATAIcons.emailIcon,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        bool email = _.emailRegex.hasMatch(val);
                        if (val.isEmpty) {
                          return "please enter your email";
                        } else if (!email) {
                          return "please enter valid email address";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing5,
                    CommonTextField(
                      controller: _.confirmeEmailController,
                      labelText: "Confirm Email",
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      prefixIcon: UIDATAIcons.emailIcon,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        bool email = _.emailRegex.hasMatch(val);
                        if (val.isEmpty) {
                          return "please enter your email";
                        } else if (!email) {
                          return "please enter valid email address";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing5,
                    CommonTextField(
                      controller: _.passwordController,
                      labelText: "Password",
                      isTextHidden: _.securetext,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
                      togglePassword: true,
                      prefixIcon: UIDATAIcons.unlockIcon,
                      toggleIcon: _.securetext == true
                          ? UIDATAIcons.viewOffIcon
                          : UIDATAIcons.viewIcon,
                      toggleFunction: () {
                        _.securetext = !_.securetext;
                        _.update();
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your password";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    Obx(() => _.isUpdateEmailLoading.isTrue
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : PrimaryButtonWithIcon(
                                btntxt: "Submit",
                                iconImage: UIDATAIcons.sendIcon,
                                onPressed: () {
                                  _.updateEmail();
                                },
                              )
                        // RaisedGradientButton(
                        //     gradient: const LinearGradient(
                        //       colors: <Color>[
                        //         Color(0xff006EB8),
                        //         Color(0xff006EB8),
                        //       ],
                        //     ),
                        //     btntxt: "Submit".tr,
                        //     buttontxtColor: UIDataColors.whiteColor,
                        //     onPressed: () {
                        //       _.updateEmail();
                        //     },
                        //   ),
                        ),
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
