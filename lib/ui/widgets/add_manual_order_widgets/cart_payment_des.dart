import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/ui/widgets/snackbar/common_snackbar.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../buttons/material_buttons/primaryButtonWithIcon.dart';
import 'custom_detail_bottomSheet.dart';

class CartPayemntDescriptionCard extends StatelessWidget {
  final String subtotal;
  final String deliveryCharges;
  final String total;
  final String? discount;
  final String? tax;

  CartPayemntDescriptionCard(
      {Key? key,
      required this.subtotal,
      required this.total,
      required this.deliveryCharges,
      this.discount,
      required this.tax})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppTranslations>(builder: (tr) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ]),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr.translateData("cart_order_details_text"),
                    style: UIDataTextStyles.textMedium)
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
                        Text(tr.translateData("cart_order_subtotal")),
                        const Spacer(),
                        Text("$subtotal AED"),
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
                        Text(tr.translateData("cart_order_delivery_charge")),
                        const Spacer(),
                        Text("$deliveryCharges AED"),
                      ],
                    ),
                  ),
                  if (tax != "0.0")
                    Divider(
                      height: 1,
                      color: Colors.green.withOpacity(0.2),
                    ).paddingOnly(top: 5),
                  if (tax != "0.0")
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(tr.translateData("vat")),
                          const Spacer(),
                          Text("$tax AED"),
                        ],
                      ),
                    ),
                  Divider(
                    height: 1,
                    color: Colors.green.withOpacity(0.2),
                  ).paddingOnly(top: 5),
                  if (discount != "0.0")
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(tr.translateData("discount")),
                          const Spacer(),
                          Text("-$discount AED"),
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
                        Text(tr.translateData("cart_order_total"),
                            style: UIDataTextStyles.textMediumColoredBlue),
                        const Spacer(),
                        Text("$total AED",
                            style: UIDataTextStyles.textMediumColoredBlue),
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Expanded(
                  //       child: PrimaryButtonWithIcon(
                  //         onPressed: () {
                  //           showModalBottomSheet(
                  //               context: context,
                  //               shape: const RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.only(
                  //                   // <-- SEE HERE
                  //                   topLeft: Radius.circular(15.0),
                  //                 ),
                  //               ),
                  //               builder: (context) {
                  //                 return OrderDate(
                  //                     dateSelected: (date) =>
                  //                         dateSelected(date));
                  //               });
                  //         },
                  //         btntxt: "Delivery Time",
                  //       ),
                  //     ),
                  //     Container(width: 20),
                  //     Expanded(
                  //       child: PrimaryButtonWithIcon(
                  //         onPressed: () {
                  //           Get.toNamed(Routes.addManualOrder,
                  //               arguments: 'cartScreen_to_add_manual');
                  //         },
                  //         btntxt: "Add Order",
                  //         buttontxtColor: UIDataColors.primaryColor,
                  //         backEndColor: Colors.white,
                  //       ),
                  //     )
                  //   ],
                  // ).paddingOnly(top: 20),
                  PrimaryButtonWithIcon(
                    onPressed: () {
                      if (Provider.of<CartProvider>(context, listen: false)
                              .deliveryDate ==
                          null) {
                        CommonSnackbar.getSnackbar(
                            tr.translateData("no_date"),
                            tr.translateData("delivery_date"),
                            UIDataColors.redColor);
                      } else {
                        // Provider.of<CartProvider>(context, listen: false)
                        //       .
                        showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                // <-- SEE HERE
                                topLeft: Radius.circular(15.0),
                              ),
                            ),
                            builder: (context) {
                              return CustomDetailBottomSheet();
                            });
                      }
                    },
                    btntxt: tr.translateData("add_customer_title"),
                  ).paddingOnly(
                    top: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
