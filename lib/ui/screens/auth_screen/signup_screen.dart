import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart';
import 'package:santra_seller/controllers/cutomer_controller/customer-controller.dart';
import 'package:santra_seller/models/customers/view_all_customers.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';

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

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  CustomerController custCont = Get.put(CustomerController());
  Widget bodyData(context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<SignUpController>(
      builder: (_) {
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
                        controller: _.username,
                        labelText: "Business Name",
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
                        controller: _.firstname,
                        labelText: "Full Name",
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please enter your full Name";
                          }
                        },
                      ),
                      CommonTextField(
                        controller: _.email,
                        hintText: 'Email'.tr,
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
                        controller: _.phonenumber,
                        labelText: "Mobile",
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          String? name;
                          if (val.isEmpty || val.length < 12) {
                            return "Please enter valid phonen Number";
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
                        controller: _.password,
                        hintText: 'Password'.tr,
                        keyboardType: TextInputType.text,
                        fillcolor: UIDataColors.whiteColor,
                        togglePassword: true,
                        toggleIcon: _.securetext == true
                            ? UIDATAIcons.viewOffIcon
                            : UIDATAIcons.viewIcon,
                        toggleFunction: () {
                          _.securetext = !_.securetext;
                          _.update();
                        },
                        isTextHidden: _.securetext,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "password should not be blank";
                          } else if (val.length < 6) {
                            return "password should contains 6 chractors";
                          }
                        },
                      ),
                      CommonTextField(
                        controller: _.conformpassword,
                        hintText: 'Confirm Password'.tr,
                        keyboardType: TextInputType.text,
                        fillcolor: UIDataColors.whiteColor,
                        togglePassword: true,
                        toggleIcon: _.securetext == true
                            ? UIDATAIcons.viewOffIcon
                            : UIDATAIcons.viewIcon,
                        toggleFunction: () {
                          _.securetext = !_.securetext;
                          _.update();
                        },
                        isTextHidden: _.securetext,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "password should not be blank";
                          } else if (val.length < 6) {
                            return "password should contains 6 chractors";
                          }
                        },
                      ),
                      // Expanded(
                      //     child: MyDropdown(
                      //         label: "City",
                      //         validator: (value) {
                      //           if (value == null) {
                      //             return "Please select city";
                      //           }
                      //         },
                      //         prefixIcon: UIDATAIcons.location,
                      //         options: _.citiesList!,
                      //         selectedOption: _.city)),
                      CommonTextField(
                        controller: _.address,
                        hintText: 'Address'.tr,
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "please enter your Address";
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
                          value: true,
                          onToggle: (val) {},
                        ),
                        SpacingWidth.widthlistspacing5,
                        InkWell(
                          onTap: () async {},
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
                    Obx(() => _.isLoading.value
                        ? const SizedBox(
                            child: Center(
                            child: CircularProgressIndicator(),
                          ))
                        : PrimaryButtonWithIcon(
                            btntxt: "Sign Up",
                            iconImage: UIDATAIcons.signupIcon,
                            onPressed: () {},
                          )),
                    SpacingHeight.heightlistspacing15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account ? ",
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
