import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/auth_screen/fogot_password.dart';
import 'package:santra_seller/ui/screens/auth_screen/signup_screen.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget bodyData(context) {
    return Consumer<LoginProvider>(
      builder: (context, _, child) {
        return SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(220, -170),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: UIDataColors.secondaryColor),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 60,
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
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -170),
                  child: Column(
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

                      SpacingHeight.heightlistspacing35,
                      CommonTextField(
                        //
                        controller: _.email,
                        hintText: 'Your Email or Mobile Number',
                        labelText: "Email/Number",
                        prefixIcon: UIDATAIcons.userIcon,
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          // bool email = _.emailRegex.hasMatch(val);
                          if (val.isEmpty) {
                            return "Please enter your email or phone";
                          }
                          // else if (!email) {
                          //   return "Please enter valid email address";
                          // }
                        },
                      ),
                      SpacingHeight.heightlistspacing10,
                      CommonTextField(
                        controller: _.password,
                        hintText: 'Password',
                        //prefixIcon: Icons.lock_outline,
                        keyboardType: TextInputType.text,
                        fillcolor: UIDataColors.whiteColor,
                        togglePassword: true,
                        labelText: "Password",
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
                            return "Password should not be blank";
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
                            child: const Text("Forgot your password?",
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
                                btntxt: "Login",
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
                          const Text("Don't have an account ? ",
                              style: UIDataTextStyles.title),
                          GestureDetector(
                              onTap: () {
                                Get.to(() => SignUpScreen());
                              },
                              child: Text("Sign Up",
                                  style: UIDataTextStyles.title.copyWith(
                                      color: UIDataColors.primaryColor)))
                        ],
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(-220, 120),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xff78CDC8)),
                      ),
                    ],
                  ),
                ),
              ],
            ).marginOnly(left: 20.0, right: 20.0),
          ),
        );
      },
    );
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
      showDrawer: true,
      bodyData: bodyData(context),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
    );
  }
}
