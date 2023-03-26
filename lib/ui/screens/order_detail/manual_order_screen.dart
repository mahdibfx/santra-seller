// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:santra_seller/ui/widgets/cards/manual_order_detail_card.dart';

import '../../../controllers/home_controller/home_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/cards/home_card.dart';
import '../../widgets/cards/order_detail_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class ManualOrderScreen extends StatelessWidget {
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  ManualOrderScreen ({super.key});

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
                          Text('Santra Orders'),
                        ],
                      ),
                      SpacingHeight.heightlistspacing10,
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _.homeData!.manualOrders[0].manualOrders.length,
                        itemBuilder: (context, index) {
                          return ManualOrderCard(
                            orderStatus: _.homeData!.manualOrders[0].manualOrders[index].orderStatus.toString(),
                            totalPrice: _.homeData!.manualOrders[0].manualOrders[index].totalOrderAmount.toString(),
                            // orderRemarks: _.homeData!.manualOrders[0].manualOrders[index].orderRemarks.toString(),
                            orderTime: _.homeData!.manualOrders[0].manualOrders[index].orderDateStamp.toString(),
                            deliveryTime: _.homeData!.manualOrders[0].manualOrders[index].advanceTime.toString(),
                            customerName: _.homeData!.manualOrders[0].manualOrders[index].customerName.toString(),
                            paymentMethod: _.homeData!.manualOrders[0].manualOrders[index].paymentMethod.toString(),
                            orderNumber:_.homeData!.manualOrders[0].manualOrders[index].orderNumber.toString(),
                            orderItemList: _.homeData!.manualOrders[0].manualOrders[index].orderItems,
                          );
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
