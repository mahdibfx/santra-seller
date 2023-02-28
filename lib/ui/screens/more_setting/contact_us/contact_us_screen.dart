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

  Widget bodyData() {
    return GetBuilder<ContactUsController>(
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Form(
                key: _.form,
                child: Column(
                  children: [
                    SpacingHeight.heightlistspacing20,
                    Container(
                      child: Column(children: [
                        CommonTextField(
                          fieldHeading: 'Name',
                          controller: _.username,
                          hintText: "User Name".tr,
                          isTextHidden: false,
                          fillcolor: UIDataColors.white,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "please enter your User Name";
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
                        CommonTextField(
                          fieldHeading: 'Email',
                          controller: _.email,
                          hintText: 'Email'.tr,
                          isTextHidden: false,
                          fillcolor: UIDataColors.white,
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
                          fieldHeading: 'Phone Number',
                          controller: _.phonenumber,
                          hintText: 'Phone Number'.tr,
                          isTextHidden: false,
                          fillcolor: UIDataColors.white,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "please enter your phone Number";
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
                        CommonTextField(
                          fieldHeading: 'Address',
                          controller: _.address,
                          hintText: 'Address'.tr,
                          isTextHidden: false,
                          fillcolor: UIDataColors.white,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "please enter your Address";
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
                      ]),
                    ),
                    SpacingHeight.heightlistspacing10,
                    Obx(
                      () => _.isLoading.value
                          ? SizedBox(
                              child: Center(
                              child: CircularProgressIndicator(),
                            ))
                          : RaisedGradientButton(
                              onPressed: () async {},
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Color(0xff006EB8),
                                  Color(0xff006EB8),
                                ],
                              ),
                              btntxt: "Submit".tr,
                              buttontxtColor: UIDataColors.white,
                            ),
                    ),
                    SpacingHeight.heightlistspacing15,
                  ],
                ),
              ),
              Text('Get in Touch'),
              Text('+971 50 188 6867'),
              Text('app.santra.ae'),
              Text('Santra D-tech-497G'),
              Text(' Dubai Silicon Oasis- Dubai,UAE'),
            ],
          ).marginAll(10)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.commonColor,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.white,
      appTitle: 'Contact Us',
      backarrow: UIDataColors.black,
      qrCallback: () {
        Get.offAllNamed(Routes.addCustomer);
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
