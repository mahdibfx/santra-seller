import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import '../../../provider/home_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/cards/manual_order_detail_card.dart';
import '../../widgets/cards/order_detail_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';
import '../../widgets/textfields/common_textfield.dart';

class SantraOrderScreen extends StatefulWidget {
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  const SantraOrderScreen({super.key});

  @override
  State<SantraOrderScreen> createState() => _SantraOrderScreenState();
}

class _SantraOrderScreenState extends State<SantraOrderScreen> {
  final localization = AppTranslations();
  Widget bodyData() {
    return GetBuilder<AppTranslations>(
      builder: (tr) {
        return Consumer<HomeProvider>(
          builder: (context, _, child) {
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
                                  btntxt: tr.translateData("santra_orders_title")),
                              SpacingHeight.heightlistspacing10,
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      // width: 100,
                                      child: CommonTextField(
                                        prefixIcon: UIDATAIcons.searchIcon,
                                        isTextHidden: false,
                                        hintText: tr.translateData('orders_search'),
                                        fillcolor: UIDataColors.whiteColor,
                                        keyboardType: TextInputType.text,
                                        controller: _.filterController,
                                        onChanged: (value) {
                                          _.filterSantraOrders();
                                        },
                                      ),
                                    ),
                                  ),
                                  SpacingWidth.widthlistspacing,
                                  GestureDetector(
                                    onTap: () {
                                      newShhet(context);
                                    },
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: const BoxDecoration(
                                        color: UIDataColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          UIDATAIcons.filterIcon,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SpacingHeight.heightlistspacing20,
                              _.filteredSantraOrders.isEmpty
                                  ? Center(
                                      child: Column(
                                        children: [
                                           SvgPicture.asset(
                                           UIDataImage.waitingOrderImage,
                                           ),
                                           SpacingHeight.heightlistspacing15,
                                          Text('Your Store is online'),
                                          Text('Please check back later for new orders.'),

                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _.filteredSantraOrders.length,
                                      itemBuilder: (context, index) {
                                        var santraList =
                                            _.filteredSantraOrders[index];
                                        return santraList.orderStatus ==
                                                    'new_order' ||
                                                santraList.orderStatus ==
                                                    'assigned_3pl' ||
                                                santraList.orderStatus ==
                                                    'payment_pending'
                                            ? CustomCard(
                                                title: 'Card',
                                                orderStatus: santraList.orderStatus
                                                    .toString(),
                                                totalPrice: santraList
                                                    .totalOrderAmount
                                                    .toString(),
                                                orderRemarks: santraList
                                                    .orderRemarks
                                                    .toString(),
                                                orderTime: santraList.orderDateStamp
                                                    .toString(),
                                                deliveryTime: santraList.advanceTime
                                                    .toString(),
                                                customerName: santraList
                                                    .customerName
                                                    .toString(),
                                                paymentMethod: Get.locale!.languageCode == 'en' ? _.getEnglishPaymentMethod(santraList
                                                    .paymentMethod
                                                    .toString()) : _.getArabicPaymentMethod(santraList
                                                    .paymentMethod
                                                    .toString()),
                                                orderNumber: santraList.orderNumber
                                                    .toString(),
                                                paymentLink: santraList.paymentLink
                                                    .toString(),
                                                orderItemList:
                                                    santraList.orderItems,
                                              )
                                            : ManualOrderCard(
                                                orderStatus: santraList.orderStatus
                                                    .toString(),
                                                totalPrice: santraList
                                                    .totalOrderAmount
                                                    .toString(),
                                                orderTime: santraList.orderDateStamp
                                                    .toString(),
                                                deliveryTime: santraList.advanceTime
                                                    .toString(),
                                                customerName: santraList
                                                    .customerName
                                                    .toString(),
                                                paymentMethod: Get.locale!.languageCode == 'en' ? _.getEnglishPaymentMethod(santraList
                                                    .paymentMethod
                                                    .toString()) : _.getArabicPaymentMethod(santraList
                                                    .paymentMethod
                                                    .toString()),
                                                orderNumber: santraList.orderNumber
                                                    .toString(),
                                                orderItemList:
                                                    santraList.orderItems,
                                                colorCode:
                                                    santraList.colorCode.toString(),
                                              );
                                      }),
                              SpacingHeight.heightlistspacing50
                            ],
                          ).paddingSymmetric(horizontal: 15),
                        ),
                      ),
                      _.isAcceptOrderLoading ||
                              _.isCancelOrderLoading ||
                              _.isRejectOrderLoading ||
                              _.isOrderReadyLoading
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
    );
  }

  Future<dynamic> newShhet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return GetBuilder<AppTranslations>(
      builder: (tr) {
              return Consumer<HomeProvider>(builder: (context, _, child) {
                return Container(
                  height: 650,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _.resetOrderGroupValue();
                              Get.back();
                            },
                            child: SizedBox(
                                child: Row(
                              children: [
                                Text(tr.translateData('reset')),
                                SpacingWidth.widthlistspacing5,
                                SvgPicture.asset(
                                  UIDATAIcons.resetIcon,
                                  color: Colors.black,
                                ),
                              ],
                            ).marginAll(5)),
                          ),
                          Text(tr.translateData('filter'),
                              style: UIDataTextStyles.h2.copyWith(
                                color: UIDataColors.primaryColor,
                              )),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: SizedBox(
                                child: Row(
                              children: [
                                Text(tr.translateData('signup_back')),
                                SpacingWidth.widthlistspacing5,
                                Consumer<SplashProvider>(builder: (context, splashPro, child) {
                                     return SvgPicture.asset(
                                      splashPro.language == 'en_us'?
                                      UIDATAIcons.forwardArrow : UIDATAIcons.back,
                                      color: Colors.black,
                                );
                                   }
                                 ),
                              ],
                            ).marginAll(5)),
                          ),
                        ],
                      ),
                      RadioListTile(
                        title: Text(_.getStatus('new_order')),
                        value: 'new_order',
                        groupValue: _.selectedOrderOption,
                        onChanged: (value) {
                          if (mounted) {
                            _.changeOrderGroupValue(value);
                          }
                        },
                      ),
                      const Divider(thickness: 2),
                      RadioListTile(
                        title: Text(_.getStatus('payment_pending')),
                        value: 'payment_pending',
                        groupValue: _.selectedOrderOption,
                        onChanged: (value) {
                          if (mounted) {
                            _.changeOrderGroupValue(value);
                          }
                        },
                      ),
                      const Divider(thickness: 2),
                      RadioListTile(
                        title: Text(_.getStatus('assigned_3pl')),
                        value: 'assigned_3pl',
                        groupValue: _.selectedOrderOption,
                        onChanged: (value) {
                          if (mounted) {
                            _.changeOrderGroupValue(value);
                          }
                        },
                      ),
                      const Divider(thickness: 2),
                      RadioListTile(
                        title: Text(_.getStatus('canceled')),
                        value: 'canceled',
                        groupValue: _.selectedOrderOption,
                        onChanged: (value) {
                          if (mounted) {
                            _.changeOrderGroupValue(value);
                          }
                        },
                      ),
                      const Divider(thickness: 2),
                      RadioListTile(
                        title: Text(_.getStatus('rejected')),
                        value: 'rejected',
                        groupValue: _.selectedOrderOption,
                        onChanged: (value) {
                          if (mounted) {
                            _.changeOrderGroupValue(value);
                          }
                        },
                      ),
                      const Divider(thickness: 2),
                      RadioListTile(
                        title: Text(_.getStatus('accepted')),
                        value: 'accepted',
                        groupValue: _.selectedOrderOption,
                        onChanged: (value) {
                          if (mounted) {
                            _.changeOrderGroupValue(value);
                          }
                        },
                      ),
                      const Divider(thickness: 2),
                      RadioListTile(
                        title: Text(_.getStatus('order_ready')),
                        value: 'order_ready',
                        groupValue: _.selectedOrderOption,
                        onChanged: (value) {
                          if (mounted) {
                            _.changeOrderGroupValue(value);
                          }
                        },
                      ),
                      SpacingHeight.heightlistspacing10,
                      RaisedGradientButton(
                        gradient: const LinearGradient(
                          colors: <Color>[
                            UIDataColors.primaryColor,
                            UIDataColors.primaryColor,
                          ],
                        ),
                        btntxt: '${tr.translateData('filter_showing_button')} ${_.filteredSantraOrders.length} ${tr.translateData('filter_result_button')}',
                        buttontxtColor: UIDataColors.whiteColor,
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ).marginAll(10),
                );
              });
            }
          );
        });
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
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
