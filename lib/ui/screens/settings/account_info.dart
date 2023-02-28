import 'package:santra_seller/controllers/settings_controller/account_info_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../widgets/textfields/common_textfield.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class AccountInfo extends StatelessWidget {
  AccountInfo({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  Widget bodyData(context) {
    return GetBuilder<AccountInfoController>(
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
                      'Account Info',
                      textScaleFactor: 2,
                    ),
                    SpacingHeight.heightlistspacing15,
                    CommonTextField(
                      controller: _.emailController,
                      fieldHeading: "Email",
                      hintText: "Email",
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your email";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    CommonTextField(
                      controller: _.fNameController,
                      fieldHeading: "First Name",
                      hintText: "First Name",
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your first name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    CommonTextField(
                      controller: _.lNameController,
                      fieldHeading: "Last Name",
                      hintText: "Last Name",
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your last name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    CommonTextField(
                      controller: _.dobController,
                      fieldHeading: "Date Of Birth",
                      hintText: "Date Of Birth",
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your Date Of Birth";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    RaisedGradientButton(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xff006EB8),
                          Color(0xff006EB8),
                        ],
                      ),
                      btntxt: "Save".tr,
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
