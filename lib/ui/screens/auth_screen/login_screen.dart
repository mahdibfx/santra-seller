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

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text("Welcome",
                    //         style: UIDataTextStyles.loginscreenStyle),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Text("Sign In To Continue",
                    //         style:
                    //             UIDataTextStyles.loginscreentitleStyle),
                    //   ],
                    // ),
                    SpacingHeight.heightlistspacing15,
                    CommonTextField(
                      fieldHeading: 'enter_mail'.tr,
                      controller: _.email,
                      hintText: 'Email',
                      prefixIcon: UIDATAIcons.emailIcon,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
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
                      hintText: 'Password',
                      //prefixIcon: Icons.lock_outline,
                      keyboardType: TextInputType.text,
                      fillcolor: UIDataColors.whiteColor,
                      togglePassword: true,
                      prefixIcon: UIDATAIcons.lockIcon,
                      toggleIcon: _.securetext == true
                          ? UIDATAIcons.viewOffIcon
                          : UIDATAIcons.viewOffIcon,
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
                        //   "Remeber Me",
                        //   style: UIDataTextStyles.forgotpassStyle,
                        // ),

                        Spacer(),

                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.forgotpasswordRoutes);
                          },
                          child: Text("Forgot Password?",
                              style: UIDataTextStyles.subTitle),
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
                                  btntxt: "SIGN IN",
                                  buttontxtColor: UIDataColors.whiteColor,
                                  onPressed: () {
                                    _.loginfunction();
                                  },
                                ),
                        ),
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Get.updateLocale(const Locale('ar', 'AE'));
                    //   },
                    //   child: const Icon(Icons.add),
                    // ),

                    SpacingHeight.heightlistspacing15,
                    SpacingHeight.heightlistspacing15,
                    Divider(
                      height: 1,
                      color: UIDataColors.primaryColor,
                      thickness: 1.5,
                    ),
                    SpacingHeight.heightlistspacing15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account ? ",
                            style: UIDataTextStyles.subTitle),
                        GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.signuproutes);
                            },
                            child: Text("SIGN UP",
                                style: UIDataTextStyles.subTitle))
                      ],
                    ),
                    SpacingHeight.heightlistspacing15,
                    Divider(
                      height: 1,
                      color: UIDataColors.primaryColor,
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
      backgroundcolor: UIDataColors.whiteColor,
    );
  }
}
