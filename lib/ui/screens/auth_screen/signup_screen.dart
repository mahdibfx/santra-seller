import '../../../controllers/auth_controller/signup_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../widgets/textfields/common_textfield.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  Widget bodyData(context) {
    return GetBuilder<SignUpController>(
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Form(
                key: _.form,
                child: Column(
                  children: [
                    SpacingHeight.heightlistspacing10,
                    // Image.asset(
                    //   UIDataImage.logo,
                    //   height: Get.height / 10,
                    //   width: Get.width / 2.5,
                    // ),
                    SizedBox(height: 10),

                    SizedBox(height: 10),
                    Container(
                      child: Column(children: [
                        CommonTextField(
                          controller: _.username,
                          hintText: "User Name".tr,
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "please enter your User Name";
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
                        CommonTextField(
                          controller: _.firstname,
                          hintText: 'First Name'.tr,
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "please enter your First Name";
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
                        CommonTextField(
                          controller: _.lastname,
                          hintText: 'Last Name'.tr,
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "please enter your Last Name";
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
                        CommonTextField(
                          controller: _.email,
                          hintText: 'Email'.tr,
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            bool email = _.emailRegex.hasMatch(val);
                            if (val.isEmpty) {
                              return "please enter your email";
                            } else if (email == null) {
                              return "please enter valid email address";
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
                        CommonTextField(
                          controller: _.phonenumber,
                          hintText: 'Phone Number'.tr,
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "please enter your phone Number";
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
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
                        SpacingHeight.heightlistspacing10,
                        CommonTextField(
                          controller: _.password,
                          hintText: 'Password'.tr,
                          keyboardType: TextInputType.text,
                          fillcolor: UIDataColors.whiteColor,
                          togglePassword: true,
                          toggleIcon: _.securetext == true
                              ? UIDATAIcons.viewOffIcon
                              : UIDATAIcons.viewOffIcon,
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
                        SpacingHeight.heightlistspacing10,
                        CommonTextField(
                          controller: _.conformpassword,
                          hintText: 'Confirm Password'.tr,
                          keyboardType: TextInputType.text,
                          fillcolor: UIDataColors.whiteColor,
                          togglePassword: true,
                          toggleIcon: _.securetext == true
                              ? UIDATAIcons.viewOffIcon
                              : UIDATAIcons.viewOffIcon,
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
                      ]),
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text("Welcome".tr,
                    //         style: UIDataTextStyles.loginscreenStyle),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Text("Sign In To Continue".tr,
                    //         style:
                    //             UIDataTextStyles.loginscreentitleStyle),
                    //   ],
                    // ),

                    SizedBox(height: 10),

                    Obx(
                      () => _.isLoading.value
                          ? SizedBox(
                              child: Center(
                              child: CircularProgressIndicator(),
                            ))
                          : RaisedGradientButton(
                              onPressed: () async {
                                // _.signupMethod();
//@Todo
                                _.update();
                                // alertbox(_, context);

                                // Get.toNamed(Routes.homeRoutes);
                              },
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Color(0xff006EB8),
                                  Color(0xff006EB8),
                                ],
                              ),
                              btntxt: "SIGN UP".tr,
                              buttontxtColor: UIDataColors.whiteColor,
                            ),
                    ),

                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: _.remember,
                    //       onChanged: (val) {
                    //         val == true
                    //             ? _.rememberselect.text = "1"
                    //             : _.rememberselect.text = "0";
                    //         _.remember = val!;
                    //         print(_.rememberselect.text);
                    //         _.update();
                    //       },
                    //     ),
                    //     Flexible(
                    //       child: Text("I agree to the".tr,
                    //           style: UIDataTextStyles.donthaveaccount),
                    //     ),
                    //
                    //
                    //   ],
                    // ),
                    Row(
                      children: [
                        Checkbox(
                          value: _.remember,
                          onChanged: (val) {
                            val == true
                                ? _.rememberselect.text = "1"
                                : _.rememberselect.text = "0";
                            _.remember = val!;
                            print(_.rememberselect.text);
                            _.update();
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            // const path = 'assets/images/TERMS OF USE.pdf';
                            // final file = await PDFApi.loadAsset(path);
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           PDFViewerPage(file: file)),
                            // );
                            // openPDF(context, file);
                            // Get.toNamed(Routes.termandconditon);
                          },
                          child: Row(
                            children: const [
                              Text("I agree to the ",
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                              Text("Terms & Conditions ",
                                  // "Privacy \nPolicy.".tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    color: Color(0xff006EB8),
                                    fontFamily: 'Poppins-SemiBold',
                                    fontWeight: FontWeight.w700,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 1,
                      color: UIDataColors.primaryColor,
                      thickness: 1.5,
                    ),
                    SpacingHeight.heightlistspacing15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have the account? ",
                            style: UIDataTextStyles.subTitle),
                        GestureDetector(
                            onTap: () {
                              Get.offAllNamed(Routes.loginRoutes);
                            },
                            child: const Text("SIGN IN",
                                style: UIDataTextStyles.subTitle))
                      ],
                    ),
                    SpacingHeight.heightlistspacing15,
                    Divider(
                      height: 1,
                      color: UIDataColors.primaryColor,
                      thickness: 1.5,
                    ),
                  ],
                ).marginOnly(left: 10.0, right: 10.0),
              ),
            ),
          ),
        );
      },
    );
  }

  alertbox(SignUpController _, context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "NOTIFCATION",
          style: UIDataTextStyles.subTitle,
        ),
        content: Container(
          height: Get.height / 8,
          width: 200,
          child: Column(
            children: [
              Text(
                  "An OTP verification code has been sent to your email. Please verify.",
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff000000),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500)),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.emailverifyroutes);
                  _.update();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "VERIFY",
                      style: UIDataTextStyles.subTitle,
                    )
                  ],
                ),
              )
            ],
          ),

          // Column(
          //   children: [
          //     Expanded(
          //       child: SingleChildScrollView(
          //         child: Column(
          //           children: [
          //             Row(
          //               children: [
          //                 Text(
          //                   "Title",
          //                   style: UIDataTextStyles.dialogeboxtitleStyle,
          //                 ),
          //                 Spacer(),
          //               ],
          //             ),
          //             SpacingHeight.heightlistspacing10,
          //             Row(
          //               children: [
          //                 Text(
          //                   "Description",
          //                   style: UIDataTextStyles.dialogeboxtitleStyle,
          //                 ),
          //                 Spacer(),
          //                 Container(
          //                   width: 150.0,
          //                   // child: Text(
          //                   //   "${cancelpolicy['description']}",
          //                   //   style: UIDataTextStyles.dialogeboxtitle1Style,
          //                   // ),
          //                 ),
          //               ],
          //             ),
          //             SpacingHeight.heightlistspacing10,
          //             Container(
          //               height: 50,
          //               width: 250,
          //               color: UIDataColors.commonColor,
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Container(
          //                     width: 66.66,
          //                     height: 50,
          //                     child: Center(
          //                       child: Text(
          //                         "From Date",
          //                         style: UIDataTextStyles.hotelpolicyStyle,
          //                       ),
          //                     ),
          //                   ),
          //                   Container(
          //                     width: 66.66,
          //                     height: 50,
          //                     child: Center(
          //                       child: Text(
          //                         "To Date",
          //                         style: UIDataTextStyles.hotelpolicyStyle,
          //                       ),
          //                     ),
          //                   ),
          //                   Container(
          //                     width: 66.66,
          //                     height: 50,
          //                     child: Center(
          //                       child: Text(
          //                         "Cancellation Charges",
          //                         style: UIDataTextStyles.hotelpolicyStyle,
          //                         textAlign: TextAlign.center,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             // Container(
          //             //   child: ListView.builder(
          //             //     itemCount: _.policy.length,
          //             //     primary: true,
          //             //     shrinkWrap: true,
          //             //     itemBuilder: (ctx, i) {
          //             //       return Container(
          //             //         height: 50,
          //             //         width: 200,
          //             //         child: Row(
          //             //           mainAxisAlignment:
          //             //           MainAxisAlignment.spaceBetween,
          //             //           children: [
          //             //             Container(
          //             //               width: 66.66,
          //             //               height: 50,
          //             //               child: Center(
          //             //                 child: Text(
          //             //                   "${_.policy[i]['fromDateTime']}",
          //             //                   style: UIDataTextStyles
          //             //                       .hotelpolicyrowStyle,
          //             //                 ),
          //             //               ),
          //             //             ),
          //             //             Container(
          //             //               width: 66.66,
          //             //               height: 50,
          //             //               child: Center(
          //             //                 child: Text(
          //             //                   "${_.policy[i]['toDateTime']}",
          //             //                   style: UIDataTextStyles
          //             //                       .hotelpolicyrowStyle,
          //             //                 ),
          //             //               ),
          //             //             ),
          //             //             _.policy[i]['charge']['chargeType']
          //             //                 .toString()
          //             //                 .toLowerCase() ==
          //             //                 "percentage"
          //             //                 ? Container(
          //             //               width: 66.66,
          //             //               height: 50,
          //             //               child: Center(
          //             //                 child: Text(
          //             //                   "${_.policy[i]['charge']['chargeValue']}%",
          //             //                   style: UIDataTextStyles
          //             //                       .hotelpolicyrowStyle,
          //             //                   textAlign: TextAlign.center,
          //             //                 ),
          //             //               ),
          //             //             )
          //             //                 : Container(
          //             //               width: 66.66,
          //             //               height: 50,
          //             //               child: Center(
          //             //                 child: Text(
          //             //                   "SAR ${_.policy[i]['charge']['chargeAmount']}",
          //             //                   style: UIDataTextStyles
          //             //                       .hotelpolicyrowStyle,
          //             //                   textAlign: TextAlign.center,
          //             //                 ),
          //             //               ),
          //             //             ),
          //             //           ],
          //             //         ),
          //             //       );
          //             //     },
          //             //   ),
          //             // ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      showAppBar: true,
      appTitle: "SIGN UP",
      appbarcolor: UIDataColors.whiteColor,
      elevation: 0.0,
      backarrow: UIDataColors.blackColor,
      backgroundcolor: UIDataColors.whiteColor,
    );
  }
}
