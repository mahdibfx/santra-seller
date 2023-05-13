// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/ui/screens/order_detail/all_order_screen.dart';
import 'package:santra_seller/ui/screens/order_detail/manual_order_screen.dart';
import 'package:santra_seller/ui/screens/order_detail/pending_order_screen.dart';
import 'package:santra_seller/ui/screens/order_detail/santra_order_screen.dart';
import 'package:santra_seller/ui/widgets/dropdown/common_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../provider/splash_provider.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/cards/home_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';
import '../add_manual_order/add_manual_order.dart';

final tr = Get.put(AppTranslations());
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Widget bodyData(context) {
    return GetBuilder<AppTranslations>(
      builder: (tr){
        return Consumer<HomeProvider>(
          builder: (context, _, child) {
            return _.isLoading || _.homeData == null
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
                                              Text(tr.translateData('home_orders_monthly'),
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
                                                        .toStringAsFixed(0),
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
                                              GestureDetector(
                                                onTap: () {filterOrderBottomSheet(context,_);},
                                                child: Text(tr.translateData('home_sales_monthly'),
                                                    style: UIDataTextStyles.h2
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500)),
                                              ),
                                              const Spacer(),
                                              Text(
                                                _.homeData == null
                                                    ? '0'
                                                    : _.homeData!.profitMonthly
                                                        .toStringAsFixed(0),
                                                textAlign: TextAlign.start,
                                                style: UIDataTextStyles.counth1
                                                    .copyWith(
                                                  color: Colors.white,
                                                ),
                                              ).paddingOnly(bottom: 0, left: 0),
                                            ],
                                          ),
                                          GestureDetector(
                                             onTap: () {filterOrderBottomSheet(context,_);},
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                    UIDATAIcons.filterIcon,
                                                    color: Colors.white,
                                                  ),
                                                // filterOrderBottomSheet(context, _)
                                              ],
                                            ),
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
                                  santraNewCount: _.newOrderSantraCount.toString(),
                                  isSantraCard: true,
                                  onTap: () {
                                    Get.to(() => SantraOrderScreen());
                                  },
                                  heading: tr.translateData('home_santra_orders'),
                                  count: _.homeData == null
                                      ? ''
                                      : _.homeData!.santraOrders[0].orderCount
                                          .toString(),
                                  imageAsset: UIDataImage.santraOrderSVG,
                                ),
                                SpacingWidth.widthlistspacing20,
                                HomeCardWidget(
                                  onTap: () {
                                    Get.to(() => ManualOrderScreen());
                                  },
                                  heading: tr.translateData('home_manual_orders'),
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
                                    Get.to(() => PendingOrderScreen());
                                  },
                                  heading: tr.translateData('home_pending_orders'),
                                  count: _.homeData!.pendingOrders[0].orderCount
                                      .toString(),
                                  imageAsset: UIDataImage.pendingOrderSVG,
                                ),
                                SpacingWidth.widthlistspacing20,
                                HomeCardWidget(
                                  onTap: () {
                                    Get.to(() => AllOrderScreen());
                                  },
                                  heading: tr.translateData('home_all_orders'),
                                  count: _.filteredAllOrders.length.toString(),
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
    );
  }

  void  filterOrderBottomSheet(context, HomeProvider _) {
    
    //  GestureDetector(
    //   onTap: () {
        showModalBottomSheet(

            // backgroundColor:
            //     Colors.transparent,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (BuildContext context) {
              return Consumer<HomeProvider>(
                builder: (context, value, child) {
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
                               Text(
                                tr.translateData("monthly_total_earning"),
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
                                child: Container(
                                  width: 10,
                                  child: MyDropdown(
                                    label: tr.translateData("year"),
                                    options: value.years,
                                    selectedOption: value.selectedYear,
                                    prefixIcon: UIDATAIcons.calendarIcon,
                                    onChanged: (newVal) {
                                      value.selectedYear = newVal;
                                    },
                                  ),
                                ),
                              ),
                              SpacingWidth.widthlistspacing15,
                              Expanded(
                                child: MyDropdown(
                                    label: "Month",
                                    options: value.months,
                                    selectedOption: value.selectedMonth,
                                    prefixIcon: UIDATAIcons.calendarIcon,
                                    // doSomething: () {
                                    //   print("seleed ${_.selectedMonth.value}");
                                    //   // _.filterOrder(_.selectedYear.value,
                                    //   //     _.selectedMonth.value);
                                    // }
                                    onChanged: (newValue) {
                                      value.selectedMonth = newValue;

                                      value.filterOrder();
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ).paddingOnly(left: 15, right: 15, top: 20),
                      SpacingHeight.heightlistspacing25,
                      Container(
                          color: const Color(0xFFEEEEEE),
                          child: value.isFilterOrderLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          tr.translateData("orders_monthly"),
                                          style: UIDataTextStyles.title
                                              .copyWith(
                                                  fontWeight:
                                                      FontWeight.bold),
                                        ),
                                        Text(value.orderMonthly.toString(),
                                            style: const TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: UIDataColors
                                                    .primaryColor)),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          tr.translateData("sales_monthly"),
                                          style: UIDataTextStyles.title
                                              .copyWith(
                                                  fontWeight:
                                                      FontWeight.bold),
                                        ),
                                        Text(value.profitMonthly.toString(),
                                            style: const TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: UIDataColors
                                                    .primaryColor)),
                                        SpacingHeight.heightlistspacing20
                                      ],
                                    )
                                  ],
                                ).paddingSymmetric(
                                  vertical: 20, horizontal: 20)),
                    ],
                  );
                },
              );
            });
      // },
      // child: Column(children: [
      //   SvgPicture.asset(
      //     UIDATAIcons.filterIcon,
      //     color: Colors.white,
      //   ),
      // ]),
    // );
  }

  hitAllApis() async {
    await Future.microtask(() => context.read<HomeProvider>().onInit());
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
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
      isHome: true,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
