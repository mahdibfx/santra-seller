import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import '../../../provider/setting_provider/change_email_provider.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '../add_manual_order/add_manual_order.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  hitAllApis() async {
    await Future.microtask(() => context.read<ChangeEmailProvider>().onInit());
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
  }

  Widget bodyData(context) {
    return Consumer<AppTranslations>(
          builder: (context, tr, child) {
        return Consumer<ChangeEmailProvider>(
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
                            icon: UIDATAIcons.infoIcon, btntxt: tr.translateData("change_email_title")),
                        IgnorePointer(
                          ignoring: true,
                          child: CommonTextField(
                            controller: _.currentEmailController,
                            labelText: tr.translateData("setting_email"),
                            isTextHidden: false,
                            fillcolor: UIDataColors.whiteColor,
                            prefixIcon: UIDATAIcons.emailIcon,
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.isEmpty) {
                                return tr.translateData("email_validation");
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        CommonTextField(
                          controller: _.emailController,
                          labelText: tr.translateData("setting_new_email"),
                          prefixIcon: UIDATAIcons.emailIcon,
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            bool email = _.emailRegex.hasMatch(val);
                            if (val.isEmpty) {
                              return tr.translateData("email_validation");
                            } else if (!email) {
                              return tr.translateData("valid_email_validation");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing5,
                        CommonTextField(
                          controller: _.confirmeEmailController,
                          labelText: tr.translateData("setting_confirm_email"),
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          prefixIcon: UIDATAIcons.emailIcon,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            bool email = _.emailRegex.hasMatch(val);
                            if (val.isEmpty) {
                              return tr.translateData("email_validation");
                            } else if (!email) {
                              return tr.translateData("valid_email_validation");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing5,
                        CommonTextField(
                          controller: _.passwordController,
                          labelText: tr.translateData("user_password_hint_signin"),
                          isTextHidden: _.securetext,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.text,
                          togglePassword: true,
                          prefixIcon: UIDATAIcons.unlockIcon,
                          toggleIcon: _.securetext == true
                              ? UIDATAIcons.viewOffIcon
                              : UIDATAIcons.viewIcon,
                          toggleFunction: () {
                            _.securetext = !_.securetext;
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
                        SpacingHeight.heightlistspacing10,
                        _.isUpdateEmailLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : PrimaryButtonWithIcon(
                                btntxt: tr.translateData("change_email_save_button"),
                                iconImage: UIDATAIcons.sendIcon,
                                onPressed: () {
                                  _.updateEmail();
                                },
                              )
                        // RaisedGradientButton(
                        //     gradient: const LinearGradient(
                        //       colors: <Color>[
                        //         Color(0xff006EB8),
                        //         Color(0xff006EB8),
                        //       ],
                        //     ),
                        //     btntxt: "Submit".tr,
                        //     buttontxtColor: UIDataColors.whiteColor,
                        //     onPressed: () {
                        //       _.updateEmail();
                        //     },
                        //   ),
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
