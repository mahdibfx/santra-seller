import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/controllers/cutomer_controller/customer-controller.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/my_customer/my_customer_controller.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/privacy_controller.dart';
import 'package:santra_seller/models/customers/view_all_customers.dart';
import 'package:santra_seller/provider/sign_up_provider.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';

import '../../../controllers/auth_controller/signup_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
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
  PrivacyController priCont = Get.put(PrivacyController());
  // SignUpController regCont = Get.put(SignUpController());
  hitAllApis() async {
    await Future.microtask(
        () => context.read<SignUpProvider>().onInit());
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
  }

  Widget bodyData(context) {
    Size size = MediaQuery.of(context).size;
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
                        btntxt: "Create a New Acccount"),
                    Column(children: [
                      CommonTextField(
                        controller: _.businessController,
                        labelText: "Business Name",
                        prefixIcon: UIDATAIcons.dashboardIcon,
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please enter your business name";
                          }
                        },
                      ),
                      CommonTextField(
                        controller: _.fullNameController,
                        prefixIcon: UIDATAIcons.userIcon,
                        labelText: "Full Name",
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please enter your full name";
                          }
                        },
                      ),
                      CommonTextField(
                        controller: _.emailController,
                        labelText: "Email",
                        prefixIcon: UIDATAIcons.emailIcon,
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          bool email = _.emailRegex.hasMatch(val);
                          if (val.isEmpty) {
                            return "Please enter your email";
                          } else if (!email) {
                            return "Please enter valid email address";
                          }
                        },
                      ),
                      CommonTextField(
                        controller: _.phoneController,
                        prefixIcon: UIDATAIcons.callIcon,
                        labelText: "Mobile",
                        hintText: "971#########",
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        validator: (val) {
                          String? name;
                          if (val.isEmpty || val.length < 12) {
                            return "Please enter valid phone number";
                          } else if (val.isNotEmpty && val.length > 3) {
                            name = val.substring(0, 3);

                            if (name != "971") {
                              return "Phone number must start with 971";
                            }
                          } else {
                            return null;
                          }
                        },
                      ),
                      CommonTextField(
                        controller: _.passwordController,
                        labelText: 'Password'.tr,
                        prefixIcon: UIDATAIcons.lockIcon,
                        keyboardType: TextInputType.text,
                        fillcolor: UIDataColors.whiteColor,
                        togglePassword: true,
                        toggleIcon: _.passwordSecuretext == true
                            ? UIDATAIcons.viewOffIcon
                            : UIDATAIcons.viewIcon,
                        toggleFunction: () {
                          _.passwordSecuretext = !_.passwordSecuretext;
                        // @todo 
                        //setstate the value
                        },
                        isTextHidden: _.passwordSecuretext,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Password should not be blank";
                          }
                        },
                      ),
                      CommonTextField(
                        controller: _.conformPasswordController,
                        labelText: 'Confirm Password'.tr,
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
                            // @todo 
                        //setstate the value
                        },
                        isTextHidden: _.confirmPasswordSecuretext,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Password should not be blank";
                          } else if (val != _.passwordController.text) {
                            return "Both passwords should be same";
                          }
                        },
                      ),
                      MyDropdown(
                          label: "City",
                          validator: (value) {
                            if (value == null) {
                              return "Please select city";
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
                        labelText: 'Address'.tr,
                        prefixIcon: UIDATAIcons.locationPin,
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please enter your Address";
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
                              // @todo 
                        //setstate the value
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
                                    content: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Terms & Conditions",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Obx(() => priCont.isLoading.isTrue
                                            ? const CircularProgressIndicator()
                                            : priCont.hasError
                                                ? const Text(
                                                    "Error Loading T&Cs")
                                                : Text(priCont.terms.value
                                                    .toString())),
                                        SpacingHeight.heightlistspacing15,
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: PrimaryButtonWithIcon(
                                            btntxt: "Accept",
                                            onPressed: () {
                                              Get.back();
                                              _.changeIsAgree(true);
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: BorderButton(
                                            borderColor: Colors.red,
                                            buttontxtColor: Colors.red,
                                            backEndColor: Colors.white,
                                            btntxt: "Reject",
                                            onPressed: () {
                                              Get.back();
                                              _.changeIsAgree(false);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            children: const [
                              Text("I agree ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Markpro',
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text("Terms and Conditions ",
                                  style: TextStyle(
                                    fontSize: 15,
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
                            btntxt: "Sign Up",
                            iconImage: UIDATAIcons.signupIcon,
                            onPressed: () {
                              if (_.isAgree) {
                                _.signupMethod();
                              } else {
                                exceptionDialog("Alert",
                                    "Please agree to Santra's terms and conditions before you signup");
                              }
                            },
                          ),
                    SpacingHeight.heightlistspacing15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account ?",
                            style: UIDataTextStyles.title),
                        GestureDetector(
                            onTap: () {
                              Get.offAllNamed(Routes.loginRoutes);
                            },
                            child: Text("Sign In",
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
