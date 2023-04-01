import 'package:flutter_svg/flutter_svg.dart';

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
  final form = GlobalKey<FormState>();
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
                key: form,
                child: Column(
                  children: [
                    SpacingHeight.heightlistspacing35,
                    SvgPicture.asset(
                      UIDataImage.sellerLogoIconSVG,
                      height: 90,
                      width: 90,
                      fit: BoxFit.fitWidth,
                    ),
                    SpacingHeight.heightlistspacing10,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Santra",
                            style: UIDataTextStyles.h1
                                .copyWith(fontSize: 30, letterSpacing: 2)),
                        Text("Seller",
                            style: UIDataTextStyles.h1.copyWith(
                                fontSize: 20,
                                letterSpacing: 2,
                                color: UIDataColors.secondaryColor)),
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     Text("Sign In To Continue",
                    //         style:
                    //             UIDataTextStyles.loginscreentitleStyle),
                    //   ],
                    // ),
                    SpacingHeight.heightlistspacing35,
                    CommonTextField(
                      //
                      controller: _.email,
                      hintText: 'Your Email or Mobile Number',
                      labelText: "Email",
                      prefixIcon: UIDATAIcons.userIcon,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        // bool email = _.emailRegex.hasMatch(val);
                        if (val.isEmpty) {
                          return "Please enter your email or phone";
                        }
                        // else if (!email) {
                        //   return "Please enter valid email address";
                        // }
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
                      labelText: "Password",
                      prefixIcon: UIDATAIcons.lockIcon,
                      toggleIcon: _.securetext == true
                          ? UIDATAIcons.viewOffIcon
                          : UIDATAIcons.viewIcon,
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
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.forgotpasswordRoutes);
                          },
                          child: const Text("Forgot your password?",
                              style: UIDataTextStyles.title),
                        ),
                      ],
                    ),
                    SpacingHeight.heightlistspacing10,
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _.isLoading
                          ? const SizedBox(
                              child: Center(
                              child: CircularProgressIndicator(),
                            ))
                          : RaisedGradientButton(
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  UIDataColors.secondaryColor,
                                  UIDataColors.secondaryColor,
                                ],
                              ),
                              btntxt: "Login",
                              iconImage: SvgPicture.asset(
                                UIDATAIcons.sendIcon,
                                height: 25,
                                width: 25,
                                fit: BoxFit.fitWidth,
                              ),
                              buttontxtColor: UIDataColors.whiteColor,
                              onPressed: () {
                                if (form.currentState!.validate()) {
                                  _.loginfunction();
                                }
                              },
                            ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Get.updateLocale(const Locale('ar', 'AE'));
                    //   },
                    //   child: const Icon(Icons.add),
                    // ),

                    SpacingHeight.heightlistspacing25,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account ? ",
                            style: UIDataTextStyles.title),
                        GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.signuproutes);
                            },
                            child: Text("Sign Up",
                                style: UIDataTextStyles.title.copyWith(
                                    color: UIDataColors.primaryColor)))
                      ],
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
    );
  }
}
