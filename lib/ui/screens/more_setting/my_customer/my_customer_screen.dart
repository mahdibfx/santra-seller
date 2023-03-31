import 'package:santra_seller/controllers/more_screen_controller.dart/about_us_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/my_customer/my_customer_controller.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/edit_customer_details.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';

import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/uidata.dart';
import '../../../widgets/cards/my_customer_card.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import '../../../widgets/textfields/common_textfield.dart';

class MyCustomerScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  MyCustomerScreen({super.key});

  Widget bodyData() {
    return GetBuilder<MyCustomerController>(
      builder: (_) {
        return _.isViewCustomerLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingWithIcon(
                        icon: UIDATAIcons.customersIcon,
                        btntxt: "Customer List".tr),
                    CommonTextField(
                      isTextHidden: false,
                      prefixIcon: UIDATAIcons.searchIcon,
                      fillcolor: Colors.white,
                      labelText: 'Search by customer name'.tr,
                    ),
                    SpacingHeight.heightlistspacing10,
                    PrimaryButtonWithIcon(
                      iconImage: UIDATAIcons.userIcon,
                      btntxt: "Add New Customer".tr,
                      onPressed: () {
                        Get.toNamed(Routes.addNewcustomer);
                      },
                    ),
                    SpacingHeight.heightlistspacing20,
                    _.hasViewCustomerError || _.allCustomers!.isEmpty
                        ? const Text("No Customers Found")
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _.allCustomers?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MyCustomerCard(
                                name: _.allCustomers?[index].customerName ??
                                    "No Name",
                                number: _.allCustomers?[index].customerMobile ??
                                    "No Contact Number",
                                onTap: () {
                                  Get.to(() => EditCustomerDetails(
                                        index: index,
                                      ));
                                },
                              ).marginOnly(bottom: 17);
                            }),
                  ],
                ).paddingSymmetric(horizontal: 20)),
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
      appTitle: 'My Customer',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
