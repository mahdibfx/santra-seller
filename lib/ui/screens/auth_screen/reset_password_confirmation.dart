import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/auth_screen/reset_password.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../../provider/auth_providers/forgot_password_provider.dart';
import '../add_manual_order/add_manual_order.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class ForgotPasswordConfirmation extends StatelessWidget {
  ForgotPasswordConfirmation({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final form = GlobalKey<FormState>();
  Widget bodyData(context) {
    return GetBuilder<AppTranslations>(
      builder: (tr) {
        return Consumer<ForgotPasswordProvider>(
          builder: (context, _, child) {
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
                          Text(tr.translateData("santra"),
                              style: UIDataTextStyles.h1
                                  .copyWith(fontSize: 30, letterSpacing: 2)),
                          Text(tr.translateData("seller"),
                              style: UIDataTextStyles.h1.copyWith(
                                  fontSize: 20,
                                  letterSpacing: 2,
                                  color: UIDataColors.secondaryColor)),
                        ],
                      ),
                      SpacingHeight.heightlistspacing15,
                       Center(
                        child: Text(tr.translateData("forgot_password_otp_text"),
                            textAlign: TextAlign.center,
                            style: UIDataTextStyles.h1),
                      ),
                      SpacingHeight.heightlistspacing15,
                       Center(
                        child: Text(
                            tr.translateData("forgot_password_otp_text2"),
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
                          labelText: tr.translateData("otp"),
                          maxLength: 6,
                          controller: _.otpController,
                          validator: (val) {
                            if (val.isEmpty) {
                              return tr.translateData("otp_confirmation");
                            } else if (_.otpController.text.toString() !=
                                _.otpCode.toString()) {
                              return tr.translateData("otp_valid");
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),

                      SpacingHeight.heightlistspacing5,
                      BorderButton(
                        btntxt: tr.translateData("forgot_password_verify"),
                        backEndColor: Colors.white,
                        borderColor: UIDataColors.primaryColor,
                        buttontxtColor: UIDataColors.primaryColor,
                        onPressed: () {
                          if (form.currentState!.validate()) {
                            Get.to(() => ResetPasswordAfterConfirmation());
                            // Get.toNamed(Routes.resetPasswordAfterConfirmation);
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
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
