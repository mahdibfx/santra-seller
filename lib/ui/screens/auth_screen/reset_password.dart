import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/auth_providers/forgot_password_provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import 'package:flutter/material.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class ResetPasswordAfterConfirmation extends StatefulWidget {
  ResetPasswordAfterConfirmation({super.key});

  @override
  State<ResetPasswordAfterConfirmation> createState() =>
      _ResetPasswordAfterConfirmationState();
}

class _ResetPasswordAfterConfirmationState
    extends State<ResetPasswordAfterConfirmation> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final form = GlobalKey<FormState>();

  Widget bodyData(context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(context),
      child: Consumer<AppTranslations>(
            builder: (context, tr, child) {
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
                          child: Text(tr.translateData("set_new_password"),
                              textAlign: TextAlign.center,
                              style: UIDataTextStyles.h1),
                        ),
    
                        SpacingHeight.heightlistspacing15,
                        Form(
                          key: form,
                          child: Column(
                            children: [
                              CommonTextField(
                                controller: _.newPasswordController,
                                labelText: tr.translateData("change_password_new"),
                                isTextHidden: _.newPasswordSecuretext,
                                fillcolor: UIDataColors.whiteColor,
                                keyboardType: TextInputType.text,
                                togglePassword: true,
                                prefixIcon: UIDATAIcons.unlockIcon,
                                toggleIcon: _.newPasswordSecuretext == true
                                    ? UIDATAIcons.viewOffIcon
                                    : UIDATAIcons.viewIcon,
                                toggleFunction: () {
                                  _.newPasswordSecuretext = !_.newPasswordSecuretext;
                                  setState(() {});
                                },
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return tr.translateData("enter_password");
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SpacingHeight.heightlistspacing5,
                              CommonTextField(
                                controller: _.confirmNewPasswordController,
                                labelText: tr.translateData("change_password_new_confirm"),
                                isTextHidden: _.confirmPasswordSecuretext,
                                fillcolor: UIDataColors.whiteColor,
                                keyboardType: TextInputType.text,
                                togglePassword: true,
                                prefixIcon: UIDATAIcons.unlockIcon,
                                toggleIcon: _.confirmPasswordSecuretext == true
                                    ? UIDATAIcons.viewOffIcon
                                    : UIDATAIcons.viewIcon,
                                toggleFunction: () {
                                  _.confirmPasswordSecuretext =
                                      !_.confirmPasswordSecuretext;
                                  setState(() {});
                                },
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return tr.translateData("enter_password");
                                  } else if (val != _.newPasswordController.text) {
                                    return tr.translateData("password_confirmation_error");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
    
                        SpacingHeight.heightlistspacing5,
                        _.isResetPassLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : BorderButton(
                                btntxt: tr.translateData("reset_password"),
                                backEndColor: Colors.white,
                                borderColor: UIDataColors.primaryColor,
                                buttontxtColor: UIDataColors.primaryColor,
                                onPressed: () {
                                  if (form.currentState!.validate()) {
                                    _.resetPassword();
                                  }
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
      ),
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
