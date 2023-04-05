import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';

import '../../../../controllers/more_screen_controller.dart/contact_us/contact_us_controller.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/uidata.dart';
import '../../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/textfields/common_textfield.dart';

class ContactUsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  ContactUsScreen({super.key});
  final form = GlobalKey<FormState>();
  Widget bodyData() {
    return GetBuilder<ContactUsController>(
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              HeadingWithIcon(
                  icon: UIDATAIcons.orderRemarks,
                  btntxt: "Contact Customer Service"),
              Form(
                key: form,
                child: Column(
                  children: [
                    Column(children: [
                      CommonTextField(
                        controller: _.usernameController,
                        labelText: "Name".tr,
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please enter your name";
                          }
                        },
                      ),
                      CommonTextField(
                        controller: _.emailController,
                        labelText: 'Email'.tr,
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
                        controller: _.phonenumberController,
                        labelText: 'Phone Number'.tr,
                        isTextHidden: false,
                        hintText: "971#########",
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
                        maxlines: 5,
                        controller: _.messageController,
                        hintText: 'Message'.tr,
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please enter your query";
                          }
                        },
                      ),
                      SpacingHeight.heightlistspacing10,
                    ]),
                    SpacingHeight.heightlistspacing10,
                    _.isLoading
                        ? const SizedBox(
                            child: Center(
                            child: CircularProgressIndicator(),
                          ))
                        : PrimaryButtonWithIcon(
                            btntxt: "Send",
                            iconImage: UIDATAIcons.sendIcon,
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                _.sendMessage();
                              }
                            },
                          ),
                    SpacingHeight.heightlistspacing15,
                  ],
                ),
              ),
              const Text(
                'Get in Touch',
                style: UIDataTextStyles.h1,
              ),
              SpacingHeight.heightlistspacing5,
              const Text(
                '+971 50 188 6867',
                style: UIDataTextStyles.title,
              ),
              SpacingHeight.heightlistspacing5,
              const Text(
                'app.santra.ae',
                style: UIDataTextStyles.title,
              ),
              SpacingHeight.heightlistspacing5,
              const Text(
                'Santra D-tech-497G',
                style: UIDataTextStyles.title,
              ),
              const Text(
                'Dubai Silicon Oasis- Dubai',
                style: UIDataTextStyles.title,
              ),
              const Text(
                'United Arab Emirates',
                style: UIDataTextStyles.title,
              ),
            ],
          ).paddingSymmetric(horizontal: 15)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'Contact Us',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
