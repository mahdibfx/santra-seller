// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter_svg/svg.dart';

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

  SantraOrderScreen ({super.key});

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
                        itemCount: _.homeData!.santraOrders[0].santraOrders.length,
                        itemBuilder: (context, index) {
                          var santraList = _.homeData!.santraOrders[0].santraOrders[index];
                          return 
                          // santraList.orderStatus == 'devliered' ? ManualOrderCard(
                          //     orderStatus: santraList.orderStatus.toString(),
                          //   totalPrice: santraList.totalOrderAmount.toString(),
                          //   orderTime: santraList.orderDateStamp.toString(),
                          //   deliveryTime: santraList.advanceTime.toString(),
                          //   customerName: santraList.customerName.toString(),
                          //   paymentMethod: santraList.paymentMethod.toString(),
                          //   orderNumber:santraList.orderNumber.toString(),
                          //   orderItemList: santraList.orderItems,
                          //   colorCode: santraList.colorCode.toString(),
                          // ) : 
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
