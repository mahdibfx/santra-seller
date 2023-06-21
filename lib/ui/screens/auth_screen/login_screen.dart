import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/auth_screen/fogot_password.dart';
import 'package:santra_seller/ui/screens/auth_screen/signup_screen.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import '../../../provider/auth_providers/login_provider.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../widgets/textfields/common_textfield.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final form = GlobalKey<FormState>();
  Widget bodyData(context) {
    return GetBuilder<AppTranslations>(builder: (tr) {
      return Consumer<LoginProvider>(
        builder: (context, _, child) {
          return Form(
            key: form,
            child: Column(
              children: [
                SizedBox(
                  height: 270,
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: Get.locale!.languageCode == 'en'? MainAxisAlignment.end :MainAxisAlignment.start,
                        crossAxisAlignment: Get.locale!.languageCode == 'en'? CrossAxisAlignment.end:CrossAxisAlignment.start,
                        children: [
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              
                              width: 140,
                              height: 140,
                              decoration: const BoxDecoration(
                                color: UIDataColors.secondaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  bottomLeft: Radius.circular(5000),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 20,
                        top: 60,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: Container(
                              // height: 40,
                              // width: 40,
                              decoration: BoxDecoration(
                                  color: UIDataColors.primaryColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(UIDATAIcons.menuIcon),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 125,
                        right: 136,
                        child: Image.asset(
                          Get.locale!.languageCode == 'en'
                              ? UIDataImage.santraLogoEnglish
                              : UIDataImage.santraLogoArabic,
                          height: 145,
                          width: 117,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                SpacingHeight.heightlistspacing20,
                
                Column(
                  children: [
                    CommonTextField(
                      textInputAction: TextInputAction.next,
                      controller: _.email,
                      hintText: tr.translateData('user_number_hint_signin'),
                      labelText: tr.translateData("emailpassword_hint_signin"),
                      prefixIcon: UIDATAIcons.userIcon,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        // bool email = _.emailRegex.hasMatch(val);
                        if (val.isEmpty) {
                          return tr.translateData("enter_email_phone");
                        }
                        // else if (!email) {
                        //   return "Please enter valid email address";
                        // }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    CommonTextField(
                      controller: _.password,
                      hintText: tr.translateData('user_password_hint_signin'),
                      //prefixIcon: Icons.lock_outline,
                      keyboardType: TextInputType.text,
                      fillcolor: UIDataColors.whiteColor,
                      togglePassword: true,
                      labelText: tr.translateData("signup_password"),
                      prefixIcon: UIDATAIcons.lockIcon,
                      toggleIcon: _.securetext == true
                          ? UIDATAIcons.viewOffIcon
                          : UIDATAIcons.viewIcon,
                      toggleFunction: () {
                        _.securetext = !_.securetext;
                        setState(() {});
                      },
                      isTextHidden: _.securetext,
                      validator: (val) {
                        if (val.isEmpty) {
                          return tr.translateData("password_blank");
                        }
                        // else if (val.length < 6) {
                        //   return "password should contains 6 chractors";
                        // }
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const forgotPassowrd());
                            // Get.toNamed(Routes.forgotpasswordRoutes);
                          },
                          child: Text(
                              tr.translateData("forgot_password_text_signin"),
                              style: UIDataTextStyles.title),
                        ),
                      ],
                    ),
                    SpacingHeight.heightlistspacing10,
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _.isLoading
                          ? const SizedBox(
                              child: Center(
                              child: CircularProgressIndicator(),
                            ))
                          : RaisedGradientButton(
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  UIDataColors.primaryColor,
                                  UIDataColors.primaryColor,
                                ],
                              ),
                              btntxt: tr.translateData("login_button_signin"),
                              iconImage: SvgPicture.asset(
                                UIDATAIcons.sendIcon,
                                height: 25,
                                width: 25,
                                fit: BoxFit.fitWidth,
                              ),
                              buttontxtColor: UIDataColors.whiteColor,
                              onPressed: () {
                                if (form.currentState!.validate()) {
                                  _.loginfunction();
                                }
                              },
                            ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Get.updateLocale(const Locale('ar', 'AE'));
                    //   },
                    //   child: const Icon(Icons.add),
                    // ),
            
                    SpacingHeight.heightlistspacing25,
            
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tr.translateData("signup_text_signin"),
                            style: UIDataTextStyles.title),
                        GestureDetector(
                            onTap: () {
                              Get.to(() => SignUpScreen());
                            },
                            child: Text(tr.translateData("signup_link_signin"),
                                style: UIDataTextStyles.title.copyWith(
                                    color: UIDataColors.primaryColor)))
                      ],
                    ),
                  ],
                ).marginOnly(left: 20.0, right: 20.0),
                const Spacer(),
                Row(
                  mainAxisAlignment: Get.locale!.languageCode == 'en'? MainAxisAlignment.start :MainAxisAlignment.end,
                        // crossAxisAlignment: Get.locale!.languageCode == 'en'? CrossAxisAlignment.end:CrossAxisAlignment.start,
                  children: [
                  Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              color: Color(0xff78CDC8),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5000),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                          ),
                ],)
              ],
            ),
          );
        },
      );
    });
  }

  hitAllApis() async {
    await Future.microtask(() => context.read<LoginProvider>().onInit());
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      resizeToAvoid: false,
      showDrawer: true,
      bodyData: bodyData(context),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
    );
  }
}
