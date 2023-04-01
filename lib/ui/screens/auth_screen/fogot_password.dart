import 'package:flutter_svg/flutter_svg.dart';
import 'package:santra_seller/controllers/auth_controller/forgot_password_controller.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';

import '../../../controllers/auth_controller/login_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../widgets/textfields/common_textfield.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class forgotPassowrd extends StatelessWidget {
  Widget bodyData(context) {
    return GetBuilder<ForgotPasswordController>(
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height / 1.1,
              ),
              child: Form(
                //key: _.form,
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
                    SpacingHeight.heightlistspacing15,
                    const Center(
                      child: Text("Forgot password?",
                          textAlign: TextAlign.center,
                          style: UIDataTextStyles.h1),
                    ),
                    SpacingHeight.heightlistspacing15,
                    const Center(
                      child: Text(
                          "Enter your recovery phone number or email address",
                          textAlign: TextAlign.center,
                          style: UIDataTextStyles.title),
                    ),
                    SpacingHeight.heightlistspacing15,
                    CommonTextField(
                      //
                      //  controller: _.email,
                      hintText: 'Your Email or Mobile Number',
                      labelText: "Email or Phone",
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
                    _.isLoading
                        ? const SizedBox(
                            child: Center(
                            child: CircularProgressIndicator(),
                          ))
                        : BorderButton(
                            btntxt: "Reset password",
                            borderColor: UIDataColors.primaryColor,
                            backEndColor: Colors.white,
                            buttontxtColor: UIDataColors.primaryColor,
                          ),
                    // TextButton(
                    //   onPressed: () {
                    //     Get.updateLocale(const Locale('ar', 'AE'));
                    //   },
                    //   child: const Icon(Icons.add),
                    // ),

                    SpacingHeight.heightlistspacing25,

                    GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.loginRoutes);
                        },
                        child: Text("Back To Login Page",
                            style: UIDataTextStyles.subTitle
                                .copyWith(color: UIDataColors.primaryColor))),
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
