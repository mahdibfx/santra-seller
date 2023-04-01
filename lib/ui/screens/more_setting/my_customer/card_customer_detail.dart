import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/Order_Date.dart';
import 'package:santra_seller/utils/uidata.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/uidata/textStyles.dart';
import '../../../widgets/add_manual_order_widgets/custom_detail_bottomSheet.dart';
import '../../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';

class CardCustomerDetail extends StatelessWidget {


  CardCustomerDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.1,
              blurRadius: 4,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Syed Asad Ali", style: UIDataTextStyles.dayStyle)
                .paddingAll(10),
            Container(
              padding: const EdgeInsets.only(top: 0.0, left: 10, right: 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Subtotal"),
                        const Spacer(),
                         Text(" AED"),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.green.withOpacity(0.2),
                  ).paddingOnly(top: 5),
                  Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Delivery Charge"),
                        const Spacer(),
                         Text(" AED"),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.green.withOpacity(0.2),
                  ).paddingOnly(top: 5),
                  Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Total",
                            style: UIDataTextStyles.textMediumColoredBlue),
                        const Spacer(),
                         Text(" AED",
                            style: UIDataTextStyles.textMediumColoredBlue),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: PrimaryButtonWithIcon(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only( // <-- SEE HERE
                                    topLeft: Radius.circular(15.0),
                                  ),
                                ),
                                builder: (context) {
                                  return OrderDate();
                                });
                          },
                          btntxt: "Delivery Time",
                        ),
                      ),
                      Container(width: 20),
                      Expanded(
                        child: PrimaryButtonWithIcon(
                          onPressed: () {
                            Get.toNamed(Routes.addManualOrder,arguments: 'cartScreen_to_add_manual');
                          },
                          btntxt: "Add Order",
                          buttontxtColor: UIDataColors.primaryColor,
                          backEndColor: Colors.white,
                        ),
                      )
                    ],
                  ).paddingOnly(top: 20),
                  PrimaryButtonWithIcon(
                    onPressed: () {
                      showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only( // <-- SEE HERE
                                    topLeft: Radius.circular(15.0),
                                  ),
                                ),
                                builder: (context) {
                                  return CustomDetailBottomSheet();
                                });
                    },
                    btntxt: "Add Customer Details",
                  ).paddingOnly(
                    top: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
