import 'package:provider/provider.dart';
import 'package:santra_seller/provider/setting_provider/change_password_provider.dart';
import 'package:santra_seller/provider/setting_provider/reset_password_provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '../../widgets/textfields/common_textfield.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Widget bodyData(context) {
    return GetBuilder<AppTranslations>(
      builder: (tr) {
        return Consumer<ChangePasswordProvider>(
          builder: (context, _, child) {
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
                            icon: UIDATAIcons.lockIcon, btntxt: tr.translateData("change_password_title")),
                        CommonTextField(
                          controller: _.currentPasswordController,
                          labelText: tr.translateData("change_password_current"),
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.text,
                          togglePassword: true,
                          prefixIcon: UIDATAIcons.unlockIcon,
                          toggleIcon: _.currentPasswordSecuretext == true
                              ? UIDATAIcons.viewOffIcon
                              : UIDATAIcons.viewIcon,
                          toggleFunction: () {
                            _.currentPasswordSecuretext =
                                !_.currentPasswordSecuretext;
                            setState(() {});
                          },
                          isTextHidden: _.currentPasswordSecuretext,
                          validator: (val) {
                            if (val.isEmpty) {
                              return tr.translateData("enter_current_password");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing5,
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
                              return tr.translateData("password_confirmation_error");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
                        _.isUpdatePassLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PrimaryButtonWithIcon(
                                btntxt: tr.translateData("change_password_save_button"),
                                iconImage: UIDATAIcons.sendIcon,
                                onPressed: () {
                                  _.updatePassword();
                                },
                              )
                      ],
                    ).marginOnly(left: 20.0, right: 20.0),
                  ),
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
