import 'package:flutter_svg/svg.dart';
import 'package:santra_seller/controllers/auth_controller/forgot_password_controller.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../../utils/routes/app_routes.dart';
import '../../ui/widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class ForgotPasswordConfirmation extends StatelessWidget {
  ForgotPasswordConfirmation({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final form = GlobalKey<FormState>();
  Widget bodyData(context) {
    return GetBuilder<ForgotPasswordController>(
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height / 1.1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                    child: Text("Check Your Email Or Phone",
                        textAlign: TextAlign.center,
                        style: UIDataTextStyles.h1),
                  ),
                  SpacingHeight.heightlistspacing15,
                  const Center(
                    child: Text(
                        "Please enter 6 Digit OTP code we have just sent you",
                        textAlign: TextAlign.center,
                        style: UIDataTextStyles.title),
                  ),

                  SpacingHeight.heightlistspacing15,
                  Form(
                    key: form,
                    child: CommonTextField(
                      isTextHidden: false,
                      fillcolor: Colors.white,
                      keyboardType: TextInputType.phone,
                      labelText: "OTP",
                      maxLength: 6,
                      controller: _.otpController,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please Enter 6 Digits OTP Code";
                        } else if (_.otpController.text.toString() !=
                            _.otpCode.toString()) {
                          return "Incorrect OTP Code";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  SpacingHeight.heightlistspacing5,
                  BorderButton(
                    btntxt: "Verify",
                    backEndColor: Colors.white,
                    borderColor: UIDataColors.primaryColor,
                    buttontxtColor: UIDataColors.primaryColor,
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        Get.toNamed(Routes.resetPasswordAfterConfirmation);
                      }
                      //_.deleteAccount();
                    },
                  ),

                  SpacingHeight.heightlistspacing15,
                  // Obx(() => _.isLoading
                  //         ? const Center(
                  //             child: CircularProgressIndicator(),
                  //           )
                  //         :

                  //),
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
