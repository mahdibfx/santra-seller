import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/edit_customer_details.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../../models/customers/view_all_customers.dart';
import '../../../provider/more_settings_provider/my_customer_provider.dart';
import '../../../utils/uidata.dart';
import '../../screens/more_setting/my_customer/view_customer_details.dart';
import '../buttons/border_button.dart';

class MyCustomerCard extends StatelessWidget {
  final String name;
  final String number;
  final bool forView;
  final Customer customer;
  final int customerIndex;

  const MyCustomerCard({
    super.key,
    required this.name,
    required this.number,
    required this.forView,
    required this.customer,
    required this.customerIndex,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      height: 110,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            UIDATAIcons.userIcon,
                            height: 20,
                            color: UIDataColors.primaryColor,
                          ),
                          SpacingWidth.widthlistspacing,
                          SizedBox(
                            child: Text(
                              name,
                              style: UIDataTextStyles.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: UIDataColors.primaryColor,
                      ).marginAll(5),
                      Row(
                        children: [
                          SvgPicture.asset(
                            UIDATAIcons.callIcon,
                            height: 20,
                            color: UIDataColors.primaryColor,
                          ),
                          SpacingWidth.widthlistspacing,
                          Expanded(
                            child: Text(
                              number,
                              style: UIDataTextStyles.title,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: InkWell(
                        onTap: () {
                          forView
                              ? Get.to(() =>
                                  ViewCustomerDetails(customerDetail: customer))
                              : Get.to(() =>
                                  EditCustomerDetails(index: customerIndex));
                        },
                        child: SvgPicture.asset(
                          forView
                              ? UIDATAIcons.viewIcon
                              : UIDATAIcons.editCustomer,
                          color: UIDataColors.primaryColor,
                          height: 18,
                        ),
                      ),
                    ),
                    SpacingHeight.heightlistspacing10,
                    forView
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: InkWell(
                              onTap: () {
                                showpopup(
                                    'Do you really want to delete this customer?',
                                    customer.id.toString(),
                                    context);
                              },
                              child: SvgPicture.asset(
                                UIDATAIcons.deleteIcon,
                                color: UIDataColors.primaryColor,
                                height: 18,
                                //height: 20,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          )
        ],
      ).paddingSymmetric(
          horizontal: size.width * 0.045, vertical: size.height * 0.02),
    );
  }
}

void showpopup(String statement, String customerID, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<MyCustomerProvider>(builder: (context, _, child) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Text(statement),
          actions: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: BorderButton(
                      // height: 35,
                      // width: 140,
                      btntxt: 'Cancel',
                      borderColor: Colors.red,
                      buttontxtColor: Colors.red,
                      backEndColor: Colors.white,
                      // backEndColor: Colors.blue,
                      onPressed: () {
                        Get.back();
                      },
                      //  () {
                      //   _.acceptOrdermethod(widget.orderNumber);
                      // },
                    ),
                  ),
                  SpacingWidth.widthlistspacing15,
                  Expanded(
                    child: BorderButton(
                      // height: 35,
                      // width: 140,
                      btntxt: 'Ok',
                      borderColor: Colors.blue,
                      buttontxtColor: Colors.white,
                      // backEndColor: Colors.blue,
                      onPressed: () {
                        Get.back();
                        _.deleteCustomers(customerID);
                      },
                      //  () {
                      //   _.acceptOrdermethod(widget.orderNumber);
                      // },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      });
    },
  );
}

void confirmationPopup(String statement, context, var onYes) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<MyCustomerProvider>(builder: (context, _, child) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Text(statement),
          actions: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: BorderButton(
                      // height: 35,
                      // width: 140,
                      btntxt: 'Cancel',
                      borderColor: Colors.red,
                      buttontxtColor: Colors.red,
                      backEndColor: Colors.white,
                      // backEndColor: Colors.blue,
                      onPressed: () {
                        Get.back();
                      },
                      //  () {
                      //   _.acceptOrdermethod(widget.orderNumber);
                      // },
                    ),
                  ),
                  SpacingWidth.widthlistspacing15,
                  Expanded(
                    child: BorderButton(
                      // height: 35,
                      // width: 140,
                      btntxt: 'Ok',
                      borderColor: Colors.blue,
                      buttontxtColor: Colors.white,
                      // backEndColor: Colors.blue,
                      onPressed: () {
                        Get.back();
                        onYes();
                      },
                      //  () {
                      //   _.acceptOrdermethod(widget.orderNumber);
                      // },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      });
    },
  );
}
