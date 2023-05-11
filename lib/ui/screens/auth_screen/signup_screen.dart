import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/more_settings_provider/privacy_provider.dart';
import 'package:santra_seller/provider/auth_providers/sign_up_provider.dart';
import 'package:santra_seller/ui/screens/auth_screen/login_screen.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';

import '../../../utils/uidata/textStyles.dart';
import '../../widgets/dropdown/common_dropdown.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../widgets/textfields/common_textfield.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  hitAllApis() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrivacyProvider>(context, listen: false).termsAndCondition();
    });

    await Future.microtask(
        () => context.read<SignUpProvider>().signUpProviderOnInit());
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
  }

  Widget bodyData(context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<AppTranslations>(
          builder: (context, tr, child) {
        return Consumer<SignUpProvider>(
          builder: (context, _, child) {
            return SafeArea(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  child: Form(
                    key: _.form,
                    child: Column(
                      children: [
                        HeadingWithIcon(
                            icon: UIDATAIcons.userIcon,
                            iconColor: UIDataColors.primaryColor,
                            btntxt: tr.translateData("signup_title")),
                        Column(children: [
                          CommonTextField(
                            controller: _.businessController,
                            labelText: tr.translateData("signup_business"),
                            prefixIcon: UIDATAIcons.dashboardIcon,
                            isTextHidden: false,
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.isEmpty) {
                                return tr.translateData("business_name_validation");
                              }
                            },
                          ),
                          CommonTextField(
                            controller: _.fullNameController,
                            prefixIcon: UIDATAIcons.userIcon,
                            labelText: tr.translateData("signup_fullname"),
                            isTextHidden: false,
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.isEmpty) {
                                return tr.translateData("full_name_validation");
                              }
                            },
                          ),
                          CommonTextField(
                            controller: _.emailController,
                            labelText: tr.translateData("signup_email"),
                            prefixIcon: UIDATAIcons.emailIcon,
                            isTextHidden: false,
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              bool email = _.emailRegex.hasMatch(val);
                              if (val.isEmpty) {
                                return tr.translateData("email_validation");
                              } else if (!email) {
                                return  tr.translateData("valid_email_validation");
                              }
                            },
                          ),
                          CommonTextField(
                            controller: _.phoneController,
                            prefixIcon: UIDATAIcons.callIcon,
                            labelText: tr.translateData("signup_mobile"),
                            inputFormatters: [_.phoneMask],
                            isTextHidden: false,
                            hintText: " 501234567",
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.number,
                            maxLength: 12,
                            onChanged: (val) {
                              String? check0;

                              if (val.isNotEmpty && val.length > 3) {
                                check0 = val.substring(0, 4);
                                if (check0 == "9710") {
                                  _.phoneController.clear();
                                }
                              }
                            },
                            validator: (val) {
                              String? name;
                              if (val.isEmpty || val.length < 12) {
                                return tr.translateData("valid_phone");
                              } else if (val.isNotEmpty && val.length > 3) {
                                name = val.substring(0, 3);

                                if (name != "971") {
                                  return tr.translateData("valid_phone_971");
                                }
                              } else {
                                return null;
                              }
                            },
                          ),
                          CommonTextField(
                            controller: _.passwordController,
                            labelText: tr.translateData('signup_password'),
                            prefixIcon: UIDATAIcons.lockIcon,
                            keyboardType: TextInputType.text,
                            fillcolor: UIDataColors.whiteColor,
                            togglePassword: true,
                            toggleIcon: _.passwordSecuretext == true
                                ? UIDATAIcons.viewOffIcon
                                : UIDATAIcons.viewIcon,
                            toggleFunction: () {
                              _.passwordSecuretext = !_.passwordSecuretext;
                              setState(() {});
                            },
                            isTextHidden: _.passwordSecuretext,
                            validator: (val) {
                              if (val.isEmpty) {
                                return tr.translateData("password_blank");
                              }
                            },
                          ),
                          CommonTextField(
                            controller: _.conformPasswordController,
                            labelText: tr.translateData('signup_cpassword'),
                            prefixIcon: UIDATAIcons.lockIcon,
                            keyboardType: TextInputType.text,
                            fillcolor: UIDataColors.whiteColor,
                            togglePassword: true,
                            toggleIcon: _.confirmPasswordSecuretext == true
                                ? UIDATAIcons.viewOffIcon
                                : UIDATAIcons.viewIcon,
                            toggleFunction: () {
                              _.confirmPasswordSecuretext =
                                  !_.confirmPasswordSecuretext;
                              setState(() {});
                            },
                            isTextHidden: _.confirmPasswordSecuretext,
                            validator: (val) {
                              if (val.isEmpty) {
                                return tr.translateData("password_blank");
                              } else if (val != _.passwordController.text) {
                                return tr.translateData("password_confirmation_error");
                              }
                            },
                          ),
                          MyDropdown(
                              label: tr.translateData("signup_city"),
                              validator: (value) {
                                if (value == null) {
                                  return tr.translateData("valid_city");
                                }
                              },
                              prefixIcon: UIDATAIcons.location,
                              options: _.citiesList,
                              onChanged: (val) {
                                _.sellerCity = val;
                              },
                              selectedOption: _.sellerCity),
                          SpacingHeight.heightlistspacing5,
                          CommonTextField(
                            controller: _.addressController,
                            labelText: tr.translateData('signup_address'),
                            prefixIcon: UIDATAIcons.locationPin,
                            isTextHidden: false,
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val.isEmpty) {
                                return tr.translateData("valid_address");
                              }
                            },
                          ),
                        ]),
                        SpacingHeight.heightlistspacing5,
                        Row(
                          children: [
                            FlutterSwitch(
                              activeColor: UIDataColors.primaryColor,
                              width: size.width * 0.11,
                              toggleColor: UIDataColors.whiteColor,
                              padding: 2,
                              height: size.height * 0.03,
                              value: _.isAgree,
                              onToggle: (val) {
                                _.isAgree = val;
                                setState(() {});
                              },
                            ),
                            SpacingWidth.widthlistspacing5,
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    barrierColor:
                                        UIDataColors.blackColor.withOpacity(0.4),
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        // insetPadding: EdgeInsets.zero,
                                        content: Consumer<PrivacyProvider>(
                                          builder: (context, pValue, child) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                 Text(
                                                  tr.translateData("signup_agree_link"),
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Text(tr.translateData("privacy_policy_data")),
                                                SpacingHeight.heightlistspacing15,
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: PrimaryButtonWithIcon(
                                                    btntxt: tr.translateData("button_accept"),
                                                    onPressed: () {
                                                      Get.back();
                                                      _.changeIsAgree(true);
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: BorderButton(
                                                    borderColor: Colors.red,
                                                    buttontxtColor: Colors.red,
                                                    backEndColor: Colors.white,
                                                    btntxt: tr.translateData("button_reject"),
                                                    onPressed: () {
                                                      Get.back();
                                                      _.changeIsAgree(false);
                                                    },
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    });
                              },
                              child: Row(
                                children:  [
                                  Text(tr.translateData("signup_agree"),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Markpro',
                                        fontWeight: FontWeight.w600,
                                      )),
                                  Text(tr.translateData("signup_agree_link"),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: UIDataColors.primaryColor,
                                        fontFamily: 'Markpro',
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                        SpacingHeight.heightlistspacing15,
                        _.isLoading
                            ? const SizedBox(
                                child: Center(
                                child: CircularProgressIndicator(),
                              ))
                            : PrimaryButtonWithIcon(
                                btntxt: tr.translateData("button_signup"),
                                iconImage: UIDATAIcons.signupIcon,
                                onPressed: () {
                                  if (_.isAgree) {
                                    _.signupMethod();
                                  } else {
                                    exceptionDialog(tr.translateData("alert"),
                                        tr.translateData("agree_terms"));
                                  }
                                },
                              ),
                        SpacingHeight.heightlistspacing15,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(tr.translateData("question_signup"),
                                style: UIDataTextStyles.title),
                            GestureDetector(
                                onTap: () {
                                  Get.offAll(() => const LoginScreen());
                                },
                                child: Text(tr.translateData("sign_in"),
                                    style: UIDataTextStyles.title.copyWith(
                                        color: UIDataColors.primaryColor)))
                          ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      showActions: false,
      backGroundImage: UIDataImage.backgroundImage,
      showAppBar: true,
      appTitle: "SIGN UP",
      appbarcolor: UIDataColors.whiteColor,
      elevation: 0.0,
      backarrow: UIDataColors.blackColor,
      backgroundcolor: UIDataColors.whiteColor,
    );
  }
}
