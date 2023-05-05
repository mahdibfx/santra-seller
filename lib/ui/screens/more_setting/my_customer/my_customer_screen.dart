import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/add_customer.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/view_customer_details.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';

import '../../../../provider/more_settings_provider/my_customer_provider.dart';

import '../../../../utils/uidata.dart';
import '../../../widgets/cards/my_customer_card.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import '../../../widgets/textfields/common_textfield.dart';
import '../../add_manual_order/add_manual_order.dart';

class MyCustomerScreen extends StatefulWidget {
  final bool comingFromCart;
  const MyCustomerScreen({super.key, this.comingFromCart = false});

  @override
  State<MyCustomerScreen> createState() => _MyCustomerScreenState();
}

class _MyCustomerScreenState extends State<MyCustomerScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Widget bodyData() {
    return Consumer<MyCustomerProvider>(
      builder: (context, _, child) {
        return _.isViewCustomerLoading && _.isLoaderShowDeleteCustumer
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
                        btntxt: "client_list_button".tr),
                    CommonTextField(
                      isTextHidden: false,
                      prefixIcon: UIDATAIcons.searchIcon,
                      fillcolor: Colors.white,
                      labelText: 'Search by customer name'.tr,
                      onChanged: (value) {
                        _.filterList(value);
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    PrimaryButtonWithIcon(
                      iconImage: UIDATAIcons.userIcon,
                      btntxt: "new_customer_button".tr,
                      onPressed:
                          Provider.of<HomeProvider>(context).sellerStatusNew !=
                                  "done"
                              ? () {
                                  exceptionDialog("not_approved".tr,
                                      "status_approved".tr);
                                }
                              : () {
                                  Get.to(() => const AddCustomerScreen());
                                  // Get.offNamed(Routes.addNewcustomer);
                                },
                    ),
                    SpacingHeight.heightlistspacing20,
                    _.allFilterCustomers!.isEmpty
                        ? const Center(child: Text("No Customers Found"))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _.allFilterCustomers?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  if (!widget.comingFromCart) {
                                    // Get.to(() => EditCustomerDetails(
                                    //       index: index,
                                    //     ));
                                  } else {
                                    if (_.allFilterCustomers?[index] != null) {
                                      Get.to(() => ViewCustomerDetails(
                                            customerDetail:
                                                _.allFilterCustomers![index],
                                          ));
                                    }
                                  }
                                },
                                child: MyCustomerCard(
                                  customerIndex: index,
                                  customer: _.allFilterCustomers![index],
                                  name: _.allFilterCustomers?[index]
                                          .customerName ??
                                      "no_name".tr,
                                  number: _.allFilterCustomers?[index]
                                          .customerMobile ??
                                      "no_contact".tr,
                                  forView: widget.comingFromCart,
                                ).marginOnly(bottom: 17),
                              );
                            }),
                    SpacingHeight.heightlistspacing50
                  ],
                ).paddingSymmetric(horizontal: 15)),
              );
      },
    );
  }

  hitAllApis() async {
    await Future.microtask(() => context.read<MyCustomerProvider>().onInit());
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
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
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
