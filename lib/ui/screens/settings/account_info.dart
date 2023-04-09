import 'package:intl/intl.dart';
import 'package:santra_seller/controllers/settings_controller/account_info_controller.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../widgets/textfields/common_textfield.dart';
import 'package:flutter/material.dart';
import '../../widgets/textfields/tappable_text_field.dart';
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
                    HeadingWithIcon(
                        icon: UIDATAIcons.infoIcon, btntxt: "Account Info"),
                    SpacingHeight.heightlistspacing15,
                    CommonTextField(
                      controller: _.emailController,
                      labelText: "Email",
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      prefixIcon: UIDATAIcons.emailIcon,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your email";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing5,
                    CommonTextField(
                      controller: _.fNameController,
                      labelText: "First Name",
                      isTextHidden: false,
                      prefixIcon: UIDATAIcons.userIcon,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your first name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing5,
                    CommonTextField(
                      controller: _.lNameController,
                      labelText: "Last Name",
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      prefixIcon: UIDATAIcons.userIcon,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your last name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing5,
                    TappableTextField(
                      ontap: () {
                        _.pickUserDob(context);
                      },
                      prefixIcon: UIDATAIcons.calendarIcon,
                      fieldHeight: 50,
                      value: _.userDob != null
                          ? DateFormat('yyyy-MM-dd').format(_.userDob!)
                          : _.userDob.toString(),
                    ),
                    SpacingHeight.heightlistspacing20,
                    Obx(() => _.isUpdateAccInfoLoading.isTrue
                            ? const Center(child: CircularProgressIndicator())
                            : PrimaryButtonWithIcon(
                                btntxt: "Save",
                                iconImage: UIDATAIcons.saveIcon,
                                onPressed: () {
                                  _.updateAccountInfo();
                                },
                              )

                        // RaisedGradientButton(
                        //     gradient: const LinearGradient(
                        //       colors: <Color>[
                        //         Color(0xff006EB8),
                        //         Color(0xff006EB8),
                        //       ],
                        //     ),
                        //     btntxt: "Save".tr,
                        //     buttontxtColor: UIDataColors.whiteColor,
                        //     onPressed: () {
                        //       _.updateAccountInfo();
                        //     },
                        //   ),
                        ),
                  ],
                ).paddingSymmetric(horizontal: 20),
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
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
