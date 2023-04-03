// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';

import '../../../controllers/home_controller/home_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/cards/home_card.dart';
import '../../widgets/cards/manual_order_detail_card.dart';
import '../../widgets/cards/order_detail_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class SantraOrderScreen extends StatelessWidget {
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  SantraOrderScreen({super.key});

  Widget bodyData() {
    return GetBuilder<HomeController>(
      builder: (_) {
        return _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          HeadingWithIcon(
                              icon: UIDATAIcons.orderBascketBorder,
                              btntxt: "Santra Orders"),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _.homeData!.santraOrders[0]
                                  .santraOrders.length,
                              itemBuilder: (context, index) {
                                var santraList = _.homeData!.santraOrders[0]
                                    .santraOrders[index];
                                return santraList.orderStatus == 'new_order' ||
                                        santraList.orderStatus ==
                                            'assigned_3pl' ||
                                        santraList.orderStatus ==
                                            'payment_pending'
                                    ? CustomCard(
                                        title: 'Card',
                                        orderStatus:
                                            santraList.orderStatus.toString(),
                                        totalPrice: santraList.totalOrderAmount
                                            .toString(),
                                        orderRemarks:
                                            santraList.orderRemarks.toString(),
                                        orderTime: santraList.orderDateStamp
                                            .toString(),
                                        deliveryTime:
                                            santraList.advanceTime.toString(),
                                        customerName:
                                            santraList.customerName.toString(),
                                        paymentMethod:
                                            santraList.paymentMethod.toString(),
                                        orderNumber:
                                            santraList.orderNumber.toString(),
                                        paymentLink:
                                            santraList.paymentLink.toString(),
                                        orderItemList: santraList.orderItems,
                                      )
                                    : ManualOrderCard(
                                        orderStatus:
                                            santraList.orderStatus.toString(),
                                        totalPrice: santraList.totalOrderAmount
                                            .toString(),
                                        orderTime: santraList.orderDateStamp
                                            .toString(),
                                        deliveryTime:
                                            santraList.advanceTime.toString(),
                                        customerName:
                                            santraList.customerName.toString(),
                                        paymentMethod:
                                            santraList.paymentMethod.toString(),
                                        orderNumber:
                                            santraList.orderNumber.toString(),
                                        orderItemList: santraList.orderItems,
                                        colorCode:
                                            santraList.colorCode.toString(),
                                      );
                              }),
                        ],
                      ).paddingSymmetric(horizontal: 15),
                    ),
                  ),
                  _.isAcceptOrderLoading ||
                          _.isCancelOrderLoading ||
                          _.isRejectOrderLoading
                      ? Opacity(
                          opacity: 0.8,
                          child: ModalBarrier(
                              dismissible: false,
                              color: Colors.black.withOpacity(0.5)),
                        )
                      : Container(),
                  _.isAcceptOrderLoading ||
                          _.isCancelOrderLoading ||
                          _.isRejectOrderLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container()
                ],
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
      // leading: Row(
      //   children: [
      //     GestureDetector(
      //       child: Icon(
      //         Icons.arrow_back,
      //         color: Colors.black,
      //       ),
      //       onTap: () => Navigator.of(context).pop(),
      //     ),
      //     Text(
      //       'Back',
      //       style: TextStyle(color: Colors.black, fontSize: 10),
      //     )
      //   ],
      // ),
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appbarSvg: true,
      backarrow: UIDataColors.primaryColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
