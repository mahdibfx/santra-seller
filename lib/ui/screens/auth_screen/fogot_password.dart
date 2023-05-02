import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/auth_screen/login_screen.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import '../../../provider/auth_providers/forgot_password_provider.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../widgets/textfields/common_textfield.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class forgotPassowrd extends StatelessWidget {
  const forgotPassowrd({super.key});

  Widget bodyData(context) {
    final form = GlobalKey<FormState>();
    return Consumer<ForgotPasswordProvider>(
      builder: (context, _, child) {
        return SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height / 1.1,
              ),
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
                   Center(
                    child: Text("forgot_password".tr,
                        textAlign: TextAlign.center,
                        style: UIDataTextStyles.h1),
                  ),
                  SpacingHeight.heightlistspacing15,
                   Center(
                    child: Text(
                        "forgot_password_text".tr,
                        textAlign: TextAlign.center,
                        style: UIDataTextStyles.title),
                  ),
                  SpacingHeight.heightlistspacing15,
                  Form(
                    key: form,
                    child: CommonTextField(
                      //
                      controller: _.phoneController,
                      hintText: 'user_number_hint_signin'.tr,
                      labelText: "emailpassword_hint_signin".tr,
                      prefixIcon: UIDATAIcons.userIcon,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        // bool email = _.emailRegex.hasMatch(val);
                        if (val.isEmpty) {
                          return "enter_email_phone".tr;
                        }
                        // else if (!email) {
                        //   return "Please enter valid email address";
                        // }
                      },
                    ),
                  ),
                  SpacingHeight.heightlistspacing10,
                  _.isOtpLoading
                      ? const SizedBox(
                          child: Center(
                          child: CircularProgressIndicator(),
                        ))
                      : BorderButton(
                          btntxt: "forgot_password_button_reset".tr,
                          borderColor: UIDataColors.primaryColor,
                          backEndColor: Colors.white,
                          buttontxtColor: UIDataColors.primaryColor,
                          onPressed: () {
                            if (form.currentState!.validate()) {
                              _.confirmSellerAndGetOtp();
                            }
                          },
                        ),
                  SpacingHeight.heightlistspacing25,
                  GestureDetector(
                      onTap: () {
                        Get.to(() => const LoginScreen());
                      },
                      child: Text("forgot_password_backtologin".tr,
                          style: UIDataTextStyles.title
                              .copyWith(color: UIDataColors.primaryColor))),
                  SpacingHeight.heightlistspacing15,
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
    );
  }
}
