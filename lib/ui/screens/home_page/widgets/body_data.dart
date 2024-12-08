
  import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/constants/app_constants.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/ui/screens/home_page/widgets/filter_orders_bottomsheet.dart';
import 'package:santra_seller/ui/screens/home_page/widgets/skeletonized_home.dart';
import 'package:santra_seller/ui/screens/order_detail/all_order_screen.dart';
import 'package:santra_seller/ui/screens/order_detail/manual_order_screen.dart';
import 'package:santra_seller/ui/screens/order_detail/pending_order_screen.dart';
import 'package:santra_seller/ui/screens/order_detail/santra_order_screen.dart';
import 'package:santra_seller/ui/screens/settings/conntract.dart';
import 'package:santra_seller/ui/widgets/cards/home_card.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import 'package:skeletonizer/skeletonizer.dart';

  _showDialog(BuildContext context, HomeProvider _) {
    VoidCallback continueCallBack = () {
      Navigator.of(context).pop();
      _.contract().then((value) {});

      // code on continue comes here
    };
    BlurryDialog alert = BlurryDialog(_, continueCallBack);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  void contractNotify(HomeProvider _,context,notify) {
    if (!_.isLoading && _.homeData != null) if (AppConstants.homeModel !=
            null &&
        AppConstants.homeModel.data.first.showContract == "yes")
      Future.delayed(const Duration(milliseconds: 500), () {
        if (notify) {
          _showDialog(context, _);
          notify = false;
        }
      });
  }

Widget bodyData(context,notify) {
    return GetBuilder<AppTranslations>(builder: (tr) {
      return Consumer<HomeProvider>(
        builder: (context, _, child) {
          contractNotify(_,context,notify);
          return _.isLoading || _.homeData == null
              ?Skeletonizer(child: skeletonizedHomeBody(context)).marginOnly(left: 20, right: 20)
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      child: _HomeBody(tr, _, context).marginOnly(left: 20, right: 20),
                    ),
                  ),
                );
        },
      );
    });
  }

Column _HomeBody(AppTranslations tr, HomeProvider _, BuildContext context) {
  return Column(
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
                                          Text(
                                              tr.translateData(
                                                  'home_orders_monthly'),
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
                                            onTap: () {
                                              filterOrderBottomSheet(
                                                  context, _);
                                            },
                                            child: Text(
                                                tr.translateData(
                                                    'home_sales_monthly'),
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
                                        onTap: () {
                                          filterOrderBottomSheet(context, _);
                                        },
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
                              santraNewCount:
                                  _.newOrderSantraCount.toString(),
                              isSantraCard: true,
                              onTap: () {
                                Get.to(() => const SantraOrderScreen());
                              },
                              heading: tr.translateData('home_santra_orders'),
                              count: _.homeData == null
                                  ? ''
                                  : _.homeData!.santraOrders![0].orderCount
                                      .toString(),
                              imageAsset: UIDataImage.santraOrderSVG,
                            ),
                            SpacingWidth.widthlistspacing20,
                            HomeCardWidget(
                              onTap: () {
                                Get.to(() => const ManualOrderScreen());
                              },
                              heading: tr.translateData('home_manual_orders'),
                              count: _.homeData!.manualOrders![0].orderCount
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
                                Get.to(() => const PendingOrderScreen());
                              },
                              heading:
                                  tr.translateData('home_pending_orders'),
                              count: _.homeData!.pendingOrders![0].orderCount
                                  .toString(),
                              imageAsset: UIDataImage.pendingOrderSVG,
                            ),
                            SpacingWidth.widthlistspacing20,
                            HomeCardWidget(
                              onTap: () {
                                Get.to(() => const AllOrderScreen());
                              },
                              heading: tr.translateData('home_all_orders'),
                              count: _.homeData!.allOrders![0].orderCount.toString(),
                              imageAsset: UIDataImage.allOrderSVG,
                            ),
                          ],
                        ),
                      ],
                    );
}
