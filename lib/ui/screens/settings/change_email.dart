import 'package:santra_seller/controllers/settings_controller/change_email_controller.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import '../../../utils/routes/app_routes.dart';
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
                    const Text(
                      'Change Email',
                      textScaleFactor: 2,
                    ),
                    SpacingHeight.heightlistspacing15,
                    CommonTextField(
                      controller: _.emailController,
                      fieldHeading: "New Email",
                      hintText: "New Email",
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
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
                    SpacingHeight.heightlistspacing10,
                    CommonTextField(
                      controller: _.confirmeEmailController,
                      fieldHeading: "Confirm Email",
                      hintText: "Confirm Email",
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
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
                    SpacingHeight.heightlistspacing10,
                    CommonTextField(
                      controller: _.passwordController,
                      fieldHeading: "Password",
                      hintText: "Password",
                      isTextHidden: _.securetext,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      togglePassword: true,
                      toggleIcon: _.securetext == true
                          ? Icons.visibility_off
                          : Icons.remove_red_eye,
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
                    Obx(
                      () => _.isUpdateEmailLoading.isTrue
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
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
                                _.updateEmail();
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
