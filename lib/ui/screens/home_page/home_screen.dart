// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:santra_seller/ui/widgets/dropdown/common_dropdown.dart';

import '../../../controllers/home_controller/home_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/cards/home_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  HomeScreen({super.key});

  Widget bodyData(context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return 
        _.isLoading
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
                          Expanded(
                            child: Container(
                              height: 95,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color.fromARGB(255, 4, 67, 112),
                                    Color.fromARGB(255, 70, 172, 240),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            UIDATAIcons.walletIcon,
                                            fit: BoxFit.fitWidth,
                                          ),
                                           SpacingWidth.widthlistspacing15,
                                          Text('Orders Monthly',
                                              style: UIDataTextStyles.h2
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                        ],
                                      ),
                                      SpacingHeight.heightlistspacing15,
                                      Text(
                                       _.homeData==  null ? '0' : _.homeData!.ordersMonthly.toString(),
                                        style: UIDataTextStyles.counth1
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ).marginOnly(top: 15, right: 10),
                                  const VerticalDivider(
                                    width: 2,
                                    color: UIDataColors.whiteColor,
                                  ).marginOnly(top: 20, bottom: 20),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('Profit Monthly',
                                              style: UIDataTextStyles.h2
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                  SpacingWidth.widthlistspacing15,

                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(

                                                  // backgroundColor:
                                                  //     Colors.transparent,
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    25.0)),
                                                  ),
                                                  builder:
                                                      (BuildContext context) {
                                                    return StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState) {
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      UIDATAIcons
                                                                          .dollarCircle,
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    "Monthly Total Earnings",
                                                                    style: UIDataTextStyles
                                                                        .title,
                                                                  ),
                                                                  const Spacer(),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Get.back();
                                                                    },
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      UIDATAIcons
                                                                          .close,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Divider(
                                                                height: 40,
                                                                thickness: 0.3,
                                                                color: UIDataColors
                                                                    .primaryColor,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        MyDropdown(
                                                                      options: _
                                                                          .years,
                                                                      selectedOption:
                                                                          _.selectedYear,
                                                                      prefixIcon:
                                                                          UIDATAIcons
                                                                              .calendarIcon,
                                                                    ),
                                                                  ),
                                                                  SpacingWidth
                                                                      .widthlistspacing15,
                                                                  Expanded(
                                                                    child: MyDropdown(
                                                                        options: _.months,
                                                                        selectedOption: _.selectedMonth,
                                                                        prefixIcon: UIDATAIcons.calendarIcon,
                                                                        doSomething: () {
                                                                          print(
                                                                              "seleed ${_.selectedMonth}");
                                                                          _.filterOrder();
                                                                        }),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ).paddingOnly(
                                                              left: 15,
                                                              right: 15,
                                                              top: 20),
                                                          SpacingHeight
                                                              .heightlistspacing25,
                                                          _.isFilterOrderLoading
                                                              ? const Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                )
                                                              : Container(
                                                                  color: const Color(
                                                                      0xFFEEEEEE),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Text(
                                                                            "Orders Monthly",
                                                                            style:
                                                                                UIDataTextStyles.title.copyWith(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text(
                                                                              _.orderMonthly ?? "0",
                                                                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: UIDataColors.primaryColor)),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          Text(
                                                                            "Profit Monthly",
                                                                            style:
                                                                                UIDataTextStyles.title.copyWith(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text(
                                                                              _.profitMonthly ?? "00",
                                                                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: UIDataColors.primaryColor)),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ).paddingSymmetric(
                                                                      vertical:
                                                                          20,
                                                                      horizontal:
                                                                          20)),
                                                          SpacingHeight
                                                              .heightlistspacing20
                                                        ],
                                                      );
                                                    });
                                                  });
                                            },
                                            child: SvgPicture.asset(
                                                UIDATAIcons.filterIcon),
                                          )
                                        ],
                                      ),
                                      SpacingHeight.heightlistspacing15,
                                      Text(
                                      _.homeData == null ? '0':  _.homeData!.profitMonthly.toString(),
                                        style: UIDataTextStyles.counth1
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ).marginOnly(top: 15, left: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SpacingHeight.heightlistspacing20,
                      Row(
                        children: [
                          HomeCardWidget(
                            onTap: () {
                              Get.toNamed(Routes.santraorders);
                            },
                            heading: 'Santra Orders',
                            count: _.homeData!.santraOrders[0].orderCount
                                .toString(),
                            imageAsset: UIDataImage.santraOrderSVG,
                          ),
                          SpacingWidth.widthlistspacing20,
                          HomeCardWidget(
                            onTap: () {
                              Get.toNamed(Routes.manualOrderScreen);
                            },
                            heading: 'Manual Orders',
                            count: _.homeData!.manualOrders[0].orderCount
                                .toString(),
                            imageAsset: UIDataImage.manualOrderSVG,
                          ),
                        ],
                      ),
                      SpacingHeight.heightlistspacing20,
                      Row(
                        children: [
                          HomeCardWidget(
                            onTap: () {
                              Get.toNamed(Routes.pendingOrderScreen);
                            },
                            heading: 'Pending Orders',
                            count: _.homeData!.pendingOrders[0].orderCount
                                .toString(),
                            imageAsset: UIDataImage.pendingOrderSVG,
                          ),
                          SpacingWidth.widthlistspacing20,
                          HomeCardWidget(
                            onTap: () {
                              Get.toNamed(Routes.allOrderScreen);
                            },
                            heading: 'All Orders',
                            count: _.allOrders.length.toString(),
                            imageAsset: UIDataImage.allOrderSVG,
                          ),
                        ],
                      ),
                    ],
                  ).marginOnly(left: 20, right: 20),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
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
