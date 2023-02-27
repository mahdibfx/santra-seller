import '../../../controllers/auth_controller/login_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../widgets/textfields/common_textfield.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  Widget bodyData(context) {
    return GetBuilder<LoginController>(
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
                  children: [
                    SpacingHeight.heightlistspacing10,
                    // Image.asset(
                    //   UIDataImage.logo,
                    //   height: Get.height / 5,
                    //   width: Get.width / 2.5,
                    // ),
                    SpacingHeight.heightlistspacing10,

                    SpacingHeight.heightlistspacing10,
                    Container(
                      height: 60,
                      width: 354,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: UIDataColors.containerlogin,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("SIGN IN ", style: UIDataTextStyles.logintitlt2),
                          Text("YOUR ACCOUNT",
                              style: UIDataTextStyles.logintitle)
                        ],
                      ),
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text("Welcome".tr,
                    //         style: UIDataTextStyles.loginscreenStyle),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Text("Sign In To Continue".tr,
                    //         style:
                    //             UIDataTextStyles.loginscreentitleStyle),
                    //   ],
                    // ),
                    SpacingHeight.heightlistspacing15,
                    CommonTextField(
                      controller: _.email,
                      hintText: 'Email'.tr,
                      prefixIcon: Icons.email_outlined,
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        bool email = _.emailRegex.hasMatch(val);
                        if (val.isEmpty) {
                          return "please enter your email";
                        } else if (email == null) {
                          return "please enter valid email address";
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    CommonTextField(
                      controller: _.password,
                      hintText: 'Password'.tr,
                      prefixIcon: Icons.lock_outline,
                      keyboardType: TextInputType.text,
                      fillcolor: UIDataColors.white,
                      togglePassword: true,
                      toggleIcon: _.securetext == true
                          ? Icons.visibility_off
                          : Icons.remove_red_eye,
                      toggleFunction: () {
                        _.securetext = !_.securetext;
                        _.update();
                      },
                      isTextHidden: _.securetext,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "password should not be blank";
                        }
                        // else if (val.length < 6) {
                        //   return "password should contains 6 chractors";
                        // }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    Row(
                      children: [
                        // Checkbox(
                        //   value: _.remember,
                        //   onChanged: (val) {
                        //     val == true
                        //         ? _.rememberselect.text = "1"
                        //         : _.rememberselect.text = "0";
                        //     _.remember = val!;
                        //     print(_.rememberselect.text);
                        //     _.update();
                        //   },
                        // ),
                        // Text(
                        //   "Remeber Me".tr,
                        //   style: UIDataTextStyles.forgotpassStyle,
                        // ),

                        Spacer(),

                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.forgotpasswordRoutes);
                          },
                          child: Text("Forgot Password?".tr,
                              style: UIDataTextStyles.forgetregular),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),

                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Obx(
                          () => _.isLoading.value
                              ? SizedBox(
                                  child: Center(
                                  child: CircularProgressIndicator(),
                                ))
                              : RaisedGradientButton(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xff006EB8),
                                      Color(0xff006EB8),
                                    ],
                                  ),
                                  btntxt: "SIGN IN".tr,
                                  buttontxtColor: UIDataColors.white,
                                  onPressed: () {
                                    _.loginfunction();
                                  },
                                ),
                        ),
                      ),
                    ),

                    SpacingHeight.heightlistspacing15,
                    SpacingHeight.heightlistspacing15,
                    Divider(
                      height: 1,
                      color: UIDataColors.dividercolor,
                      thickness: 1.5,
                    ),
                    SpacingHeight.heightlistspacing15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account ? ",
                            style: UIDataTextStyles.donthaveaccount),
                        GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.signuproutes);
                            },
                            child: Text("SIGN UP",
                                style: UIDataTextStyles.logintitle))
                      ],
                    ),
                    SpacingHeight.heightlistspacing15,
                    Divider(
                      height: 1,
                      color: UIDataColors.dividercolor,
                      thickness: 1.5,
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
    );
  }
}
