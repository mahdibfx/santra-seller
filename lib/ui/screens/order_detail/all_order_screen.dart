// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter_svg/svg.dart';

import '../../../controllers/home_controller/home_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/cards/home_card.dart';
import '../../widgets/cards/manual_order_detail_card.dart';
import '../../widgets/cards/order_detail_card.dart';
import '../../widgets/cards/pending_order_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class AllOrderScreen extends StatelessWidget {
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  AllOrderScreen ({super.key});

  Widget bodyData() {
    return GetBuilder<HomeController>(
      builder: (_) {
        return _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SpacingHeight.heightlistspacing10,
                      Row(
                        children: [
                           SvgPicture.asset(
                      UIDATAIcons.orderBascketBorder,
                      color: UIDataColors.primaryColor,
                    ),
                    SpacingWidth.widthlistspacing,
                          Text('All Orders'),
                        ],
                      ),
                      SpacingHeight.heightlistspacing10,
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _.allOrders.length,
                        itemBuilder: (context, index) {
                          var santraList =  _.allOrders[index];
                          return 
                            santraList.orderStatus == 'new_order' || santraList.orderStatus == 'assigned_3pl' ||santraList.orderStatus == 'payment_pending'?
                          CustomCard(
                            title: 'Card',
                             orderStatus: santraList.orderStatus.toString(),
                            totalPrice: santraList.totalOrderAmount.toString(),
                            orderRemarks: santraList.orderRemarks.toString(),
                            orderTime: santraList.orderDateStamp.toString(),
                            deliveryTime: santraList.advanceTime.toString(),
                            customerName: santraList.customerName.toString(),
                            paymentMethod: santraList.paymentMethod.toString(),
                            orderNumber:santraList.orderNumber.toString(),
                            orderItemList: santraList.orderItems,
                          ): ManualOrderCard(
                              orderStatus: santraList.orderStatus.toString(),
                            totalPrice: santraList.totalOrderAmount.toString(),
                            orderTime: santraList.orderDateStamp.toString(),
                            deliveryTime: santraList.advanceTime.toString(),
                            customerName: santraList.customerName.toString(),
                            paymentMethod: santraList.paymentMethod.toString(),
                            orderNumber:santraList.orderNumber.toString(),
                            orderItemList: santraList.orderItems,
                            colorCode: santraList.colorCode.toString(),
                          ) ;
                        }
                      ),
                     
                    ],
                  ).marginAll(10),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.whiteColor,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      // scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appbarSvg: true,
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
