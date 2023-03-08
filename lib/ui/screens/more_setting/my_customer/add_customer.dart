import 'package:santra_seller/controllers/more_screen_controller.dart/about_us_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/my_customer/add_customer_controller.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/my_customer/my_customer_controller.dart';

import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/uidata.dart';
import '../../../../utils/uidata/textStyles.dart';
import '../../../widgets/buttons/icon_button.dart';
import '../../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../../widgets/cards/my_customer_card.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import '../../../widgets/textfields/common_textfield.dart';

class AddCustomerScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  AddCustomerScreen({super.key});

  Widget bodyData() {
    return GetBuilder<AddNewCustomerController>(
      builder: (_) {
        return _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpacingHeight.heightlistspacing20,
                    Row(
                      children: [
                        Icon(Icons.contact_page),
                        Text(
                          'Add New Customer',
                          style: UIDataTextStyles.homecontainertxt,
                        ),
                      ],
                    ),
                    SpacingHeight.heightlistspacing20,
                    CommonTextField(
                      fieldHeading: 'Full Name',
                      // controller: _.email,
                      hintText: ''.tr,
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your Full name";
                        } else if (val == null) {
                          return "please enter valid name";
                        }
                      },
                    ),
                    CommonTextField(
                      fieldHeading: 'Phone Number',
                      // controller: _.email,
                      hintText: ''.tr,
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your Phone Number";
                        }
                      },
                    ),
                    CommonTextField(
                      fieldHeading: 'City',
                      // controller: _.email,
                      hintText: ''.tr,
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your City";
                        }
                      },
                    ),
                    CommonTextField(
                      fieldHeading: 'Building Name',
                      // controller: _.email,
                      hintText: ''.tr,
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your Phone Number";
                        }
                      },
                    ),
                    CommonTextField(
                      fieldHeading: '(Apt, villa, building Number)',
                      // controller: _.email,
                      hintText: ''.tr,
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your Phone Number";
                        }
                      },
                    ),
                    CommonTextField(
                      fieldHeading: 'Location Link',
                      // controller: _.email,
                      hintText: ''.tr,
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your Phone Number";
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing20,
                    RaisedGradientButton(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xff006EB8),
                          Color(0xff006EB8),
                        ],
                      ),
                      btntxt: "Save".tr,
                      buttontxtColor: UIDataColors.white,
                      onPressed: () {},
                    ),
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
      appTitle: 'My Customer',
      backarrow: UIDataColors.black,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
