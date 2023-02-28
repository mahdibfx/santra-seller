import 'package:santra_seller/controllers/settings_controller/change_email_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../widgets/textfields/account_info_text_fields.dart';
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
                    AccountInfoTextFields(
                        infoController: _,
                        hint: "Email",
                        title: "Email",
                        controller: _.emailController,
                        validatorText: "Please Enter Email"),
                    SpacingHeight.heightlistspacing10,
                    AccountInfoTextFields(
                        infoController: _,
                        hint: "Confirm Email",
                        title: "Confirm Email",
                        controller: _.confirmeEmailController,
                        validatorText: "Please Enter Email Again To Confirm"),
                    SpacingHeight.heightlistspacing10,
                    AccountInfoTextFields(
                        infoController: _,
                        hint: "Password",
                        title: "Password",
                        controller: _.passwordController,
                        validatorText: "Please Enter Password"),
                    SpacingHeight.heightlistspacing10,
                    RaisedGradientButton(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xff006EB8),
                          Color(0xff006EB8),
                        ],
                      ),
                      btntxt: "Submit".tr,
                      buttontxtColor: UIDataColors.white,
                      onPressed: () {
                        // _.loginfunction();
                      },
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
