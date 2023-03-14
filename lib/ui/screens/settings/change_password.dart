import 'package:santra_seller/controllers/settings_controller/change_password_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '../../widgets/textfields/common_textfield.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  Widget bodyData(context) {
    return GetBuilder<ChangePasswordController>(
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
                    const Text(
                      'Password',
                      textScaleFactor: 2,
                    ),
                    SpacingHeight.heightlistspacing15,
                    CommonTextField(
                      controller: _.currentPasswordController,
                      fieldHeading: "Current Password",
                      hintText: "Current Password",
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      togglePassword: true,
                      prefixIcon: UIDATAIcons.unlockIcon,
                      toggleIcon: _.currentPasswordSecuretext == true
                          ? UIDATAIcons.viewOffIcon
                          : UIDATAIcons.viewOffIcon,
                      toggleFunction: () {
                        _.currentPasswordSecuretext =
                            !_.currentPasswordSecuretext;
                        _.update();
                      },
                      isTextHidden: _.currentPasswordSecuretext,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your current password";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    CommonTextField(
                      controller: _.newPasswordController,
                      fieldHeading: "New Password",
                      hintText: "New Password",
                      isTextHidden: _.newPasswordSecuretext,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      togglePassword: true,
                      prefixIcon: UIDATAIcons.unlockIcon,
                      toggleIcon: _.newPasswordSecuretext == true
                          ? UIDATAIcons.viewOffIcon
                          : UIDATAIcons.viewOffIcon,
                      toggleFunction: () {
                        _.newPasswordSecuretext = !_.newPasswordSecuretext;
                        _.update();
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your new password";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    CommonTextField(
                      controller: _.confirmNewPasswordController,
                      fieldHeading: "Confirm New Password",
                      hintText: "Confirm New Password",
                      isTextHidden: _.confirmPasswordSecuretext,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      togglePassword: true,
                      prefixIcon: UIDATAIcons.unlockIcon,
                      toggleIcon: _.confirmPasswordSecuretext == true
                          ? UIDATAIcons.viewOffIcon
                          : UIDATAIcons.viewOffIcon,
                      toggleFunction: () {
                        _.confirmPasswordSecuretext =
                            !_.confirmPasswordSecuretext;
                        _.update();
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter new password again";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    Obx(
                      () => _.isUpdatePassLoading.isTrue
                          ? const Center(child: CircularProgressIndicator())
                          : RaisedGradientButton(
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Color(0xff006EB8),
                                  Color(0xff006EB8),
                                ],
                              ),
                              btntxt: "Submit".tr,
                              buttontxtColor: UIDataColors.white,
                              onPressed: () {
                                _.updatePassword();
                              },
                            ),
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
      backgroundcolor: UIDataColors.commonColor,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.white,
      appTitle: '',
      backarrow: UIDataColors.black,
      qrCallback: () {
        Get.offAllNamed(Routes.signuproutes);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
