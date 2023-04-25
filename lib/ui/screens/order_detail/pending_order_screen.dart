import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import '../../../provider/home_provider.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';
import '../../widgets/cards/manual_order_detail_card.dart';
import '../../widgets/cards/order_detail_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';
import '../../widgets/textfields/common_textfield.dart';

class PendingOrderScreen extends StatefulWidget {
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  PendingOrderScreen({super.key});

  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
  Widget bodyData() {
    return Consumer<HomeProvider>(
      builder: (context, _, child) {
        return _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Column(
                        children: [
                          HeadingWithIcon(
                              icon: UIDATAIcons.orderBascketBorder,
                              btntxt: "Pending Orders"),
                          SpacingHeight.heightlistspacing10,
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  // width: 100,
                                  child: CommonTextField(
                                    prefixIcon: UIDATAIcons.searchIcon,
                                    isTextHidden: false,
                                    hintText: 'Enter the order number',
                                    fillcolor: UIDataColors.whiteColor,
                                    keyboardType: TextInputType.text,
                                    controller: _.filterController,
                                    onChanged: (value) {
                                      _.filterPendingOrders();
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
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _.filteredPendingOrders.length,
                              itemBuilder: (context, index) {
                                var santraList = _.filteredPendingOrders[index];
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
                          SpacingHeight.heightlistspacing50
                        ],
                      ).paddingSymmetric(horizontal: 15),
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
                              _.isRejectOrderLoading ||
                              _.isOrderReadyLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container()
                    ],
                  ),
                ),
              );
      },
    );
  }

  Future<dynamic> newShhet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
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
                            Text('reset'),
                            SpacingWidth.widthlistspacing5,
                            SvgPicture.asset(
                              UIDATAIcons.resetIcon,
                              color: Colors.black,
                            ),
                          ],
                        ).marginAll(5)),
                      ),
                      Text('Filter',
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
                            Text('Back'),
                            SpacingWidth.widthlistspacing5,
                            SvgPicture.asset(
                              UIDATAIcons.forwardArrow,
                              color: Colors.black,
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
                    btntxt: 'Showing ${_.filteredPendingOrders.length} results',
                    buttontxtColor: UIDataColors.whiteColor,
                    onPressed: () {
                       Get.back();
                    },
                  ),
                ],
              ).marginAll(10),
            );
          });
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
      // scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appbarSvg: true,
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAll(() =>  const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
