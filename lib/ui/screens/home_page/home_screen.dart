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
        return _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        SpacingHeight.heightlistspacing10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xff1E1E50),
                                        Color(0xff0098B1),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(children: [
                                        SvgPicture.asset(
                                          UIDATAIcons.walletIcon,
                                          color: Colors.white,
                                        ),
                                      ]),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Orders Monthly',
                                              style: UIDataTextStyles.h2
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                          const Spacer(),
                                          Text(
                                            _.homeData == null
                                                ? '0'
                                                : _.homeData!.ordersMonthly
                                                    .toString(),
                                            style: UIDataTextStyles.counth1
                                                .copyWith(
                                              color: Colors.white,
                                            ),
                                          ).paddingOnly(bottom: 0)
                                        ],
                                      ),
                                      Center(
                                        child: Container(
                                          height: 65,
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Profit Monthly',
                                              style: UIDataTextStyles.h2
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                          const Spacer(),
                                          Text(
                                            _.homeData == null
                                                ? '0'
                                                : _.homeData!.profitMonthly
                                                    .toString(),
                                            textAlign: TextAlign.start,
                                            style: UIDataTextStyles.counth1
                                                .copyWith(
                                              color: Colors.white,
                                            ),
                                          ).paddingOnly(bottom: 0, left: 0),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          filterOrderBottomSheet(context, _)
                                        ],
                                      ),
                                    ],
                                  ).paddingAll(15)),
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
                ),
              );
      },
    );
  }

  GestureDetector filterOrderBottomSheet(context, HomeController _) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(

            // backgroundColor:
            //     Colors.transparent,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                UIDATAIcons.dollarCircle,
                              ),
                            ),
                            const Text(
                              "Monthly Total Earnings",
                              style: UIDataTextStyles.title,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(
                                UIDATAIcons.close,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 40,
                          thickness: 0.3,
                          color: UIDataColors.primaryColor,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => MyDropdown(
                                  label: "Year",
                                  options: _.years,
                                  selectedOption: _.selectedYear.value,
                                  prefixIcon: UIDATAIcons.calendarIcon,
                                  onChanged: (newVal) {
                                    _.selectedYear.value = newVal;
                                  },
                                ),
                              ),
                            ),
                            SpacingWidth.widthlistspacing15,
                            Expanded(
                              child: Obx(() => MyDropdown(
                                  label: "Month",
                                  options: _.months,
                                  selectedOption: _.selectedMonth.value,
                                  prefixIcon: UIDATAIcons.calendarIcon,
                                  // doSomething: () {
                                  //   print("seleed ${_.selectedMonth.value}");
                                  //   // _.filterOrder(_.selectedYear.value,
                                  //   //     _.selectedMonth.value);
                                  // }
                                  onChanged: (newValue) {
                                    _.selectedMonth.value = newValue;

                                    _.filterOrder();
                                  })),
                            ),
                          ],
                        ),
                      ],
                    ).paddingOnly(left: 15, right: 15, top: 20),
                    SpacingHeight.heightlistspacing25,
                    Obx(
                      () => Container(
                          color: const Color(0xFFEEEEEE),
                          child: _.isFilterOrderLoading.isTrue
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Orders Monthly",
                                          style: UIDataTextStyles.title
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Obx(() => Text(
                                            _.orderMonthly.value.toString(),
                                            style: const TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: UIDataColors
                                                    .primaryColor))),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Profit Monthly",
                                          style: UIDataTextStyles.title
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Obx(
                                          () => Text(
                                              _.profitMonthly.value.toString(),
                                              style: const TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                  color: UIDataColors
                                                      .primaryColor)),
                                        ),
                                        SpacingHeight.heightlistspacing20
                                      ],
                                    )
                                  ],
                                ).paddingSymmetric(
                                  vertical: 20, horizontal: 20)),
                    ),
                  ],
                );
              });
            });
      },
      child: Column(children: [
        SvgPicture.asset(
          UIDATAIcons.filterIcon,
          color: Colors.white,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
      isBackArrowShow: false,
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
