import 'package:santra_seller/controllers/more_screen_controller.dart/about_us_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/my_customer/my_customer_controller.dart';

import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/uidata.dart';
import '../../../../utils/uidata/textStyles.dart';
import '../../../widgets/buttons/icon_button.dart';
import '../../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../../widgets/cards/my_customer_card.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import '../../../widgets/textfields/common_textfield.dart';

class MyCustomerScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  MyCustomerScreen({super.key});

  Widget bodyData() {
    return GetBuilder<MyCustomerController>(
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
                          'My Customers',
                          style: UIDataTextStyles.homecontainertxt,
                        ),
                      ],
                    ),
                    SpacingHeight.heightlistspacing20,
                    CommonTextField(
                      // controller: _.email,
                      hintText: 'Search by customer name'.tr,
                      isTextHidden: false,
                      fillcolor: UIDataColors.white,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your email";
                        } else if (val == null) {
                          return "please enter valid email address";
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
                      btntxt: "Add New Customer".tr,
                      buttontxtColor: UIDataColors.white,
                      onPressed: () {
                        Get.toNamed(Routes.addNewcustomer);
                      },
                    ),
                    SpacingHeight.heightlistspacing20,
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return MyCustomerCard(
                            name: 'Abdul Basit Ansari',
                            number: '971321654987',
                            onTap: () {
                              Get.toNamed(Routes.editcustomer);
                            },
                          ).marginOnly(bottom: 10);
                        }),
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
