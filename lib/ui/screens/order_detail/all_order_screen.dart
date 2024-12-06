// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/models/home_model.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
import '../home_page/home_screen.dart';

var tr = Get.put(AppTranslations());

class AllOrderScreen extends StatefulWidget {
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  final localization = AppTranslations();
  final scrollController = ScrollController();
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<HomeProvider>(context, listen: false)
            .getOrders(0, "", null);

        Provider.of<HomeProvider>(context, listen: false)
            .lazyLoadGetOrders("", null,scrollController);
      },
    );
  }
@override
dispose(){
    log("dispose called");

            scrollController.dispose();
  super.dispose();

}
  Widget bodyData() {

    final order = Order.fromJson( {
                    "order_number": "25762",
                    "order_status": "accepted",
                    "customer_name": "ali blogger",
                    "total_order_amount": "31",
                    "order_date_stamp": "2024-12-06 11:02:20",
                    "payment_method": "cash",
                    "advance_time": "2024-12-06",
                    "order_remarks": "",
                    "request_image": "",
                    "order_type": "Delivery",
                    "customer_phone": "971565954081",
                    "payment_link": "no_link",
                    "color_code": "0098B1",
                    "order_items": [
                        {
                            "product_name": "Tiramisu",
                            "product_name_ar": "Tiramisu",
                            "product_total": "1",
                            "product_image": "https://imagedelivery.net/uduDJsWvsRGySrUMV4LHcA/pimage_5367365472/public",
                            "product_quantity": "1"
                        },
                        {
                            "product_name": "Flavor : Pistachio",
                            "product_name_ar": "Flavor : Pistachio",
                            "product_total": "0",
                            "product_image": "https://api.santra.qa/by_default.jpg",
                            "product_quantity": "1"
                        }
                    ],
                    "area_customer": " villa 62 Al Ain - Al Ain",
                    "request_pdf": "",
                    "cash_charges": "0",
                    "delivery_charges": "30",
                    "order_discount": "0",
                    "bar_code": "no"
                });
    return WillPopScope(
      onWillPop: () {
           Provider.of<HomeProvider>(context, listen: false)
            .scrollController.dispose();
            log("Dispose called");
        Get.offAll(const HomeScreen());
        return Future.value(false);
      },
      child: Consumer<HomeProvider>(
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
                        controller:scrollController,
                        child: Column(
                          children: [
                            HeadingWithIcon(
                                icon: UIDATAIcons.orderBascketBorder,
                                btntxt: tr.translateData("all_orders_title")),
                            SpacingHeight.heightlistspacing10,
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    // width: 100,
                                    child: CommonTextField(
                                      prefixIcon: UIDATAIcons.searchIcon,
                                      isTextHidden: false,
                                      hintText:
                                          tr.translateData('order_number'),
                                      fillcolor: UIDataColors.whiteColor,
                                      keyboardType: TextInputType.text,
                                      controller: _.filterController,
                                      onChanged: (value) {
                                       if(value.isEmpty){
                                        _.clearOrders();

                                         Provider.of<HomeProvider>(context, listen: false)
            .getOrders(0, "", null);
                                       }
                                      },
                                    ),
                                  ),
                                ),
                                SpacingWidth.widthlistspacing,
                                GestureDetector(
                                  onTap: () {
                                        _.clearOrders();

                                   if(_.filterController.text.isEmpty){
                                                            Provider.of<HomeProvider>(context, listen: false)
            .getOrders(0, "", null);
                                   }else{
                                        _.getOrders(0, "",_.filterController.text );

                                   }
                                  
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
                                        UIDATAIcons.searchIcon,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SpacingHeight.heightlistspacing20,
                            
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _.typedOrders.length,
                                itemBuilder: (context, index) {
                                  var santraList = _.typedOrders[index];
                                  return santraList.orderStatus ==
                                              'new_order' ||
                                          santraList.orderStatus ==
                                              'assigned_3pl' ||
                                          santraList.orderStatus ==
                                              'payment_pending'
                                      ? CustomCard(
                                          customerPhone:
                                              santraList.customerPhone,
                                          orderType: santraList.orderType,
                                          title: 'Card',
                                          orderStatus:
                                              santraList.orderStatus.toString(),
                                          totalPrice: santraList
                                              .totalOrderAmount
                                              .toString(),
                                          orderRemarks: santraList.orderRemarks
                                              .toString(),
                                          orderTime: santraList.orderDateStamp
                                              .toString(),
                                          area: santraList.areaCustomer,
                                          deliveryTime:
                                              santraList.advanceTime.toString(),
                                          customerName: santraList.customerName
                                              .toString(),
                                          paymentMethod:
                                              Get.locale!.languageCode == 'en'
                                                  ? _.getEnglishPaymentMethod(
                                                      santraList.paymentMethod
                                                          .toString())
                                                  : _.getArabicPaymentMethod(
                                                      santraList.paymentMethod
                                                          .toString()),
                                          orderNumber:
                                              santraList.orderNumber.toString(),
                                          paymentLink:
                                              santraList.paymentLink.toString(),
                                          orderItemList: santraList.orderItems,
                                          requestImage: santraList.requestImage,
                                          attachedPdf: santraList.pdfLink,
                                          cashCharge: santraList.cashCharges,
                                          deliveryCharge:
                                              santraList.deliveryCharges,
                                          discount: santraList.orderDiscount,
                                        )
                                      : ManualOrderCard(
                                          area: santraList.areaCustomer,
                                          customerPhone:
                                              santraList.customerPhone,
                                          orderType: santraList.orderType,
                                          orderStatus:
                                              santraList.orderStatus.toString(),
                                          totalPrice: santraList
                                              .totalOrderAmount
                                              .toString(),
                                          orderTime: santraList.orderDateStamp
                                              .toString(),
                                          deliveryTime:
                                              santraList.advanceTime.toString(),
                                          customerName: santraList.customerName
                                              .toString(),
                                          paymentMethod:
                                              Get.locale!.languageCode == 'en'
                                                  ? _.getEnglishPaymentMethod(
                                                      santraList.paymentMethod
                                                          .toString())
                                                  : _.getArabicPaymentMethod(
                                                      santraList.paymentMethod
                                                          .toString()),
                                          orderNumber:
                                              santraList.orderNumber.toString(),
                                          orderItemList: santraList.orderItems,
                                          orderRemarks: santraList.orderRemarks,
                                          colorCode:
                                              santraList.colorCode.toString(),
                                          requestImage: santraList.requestImage,
                                          attachedPdf: santraList.pdfLink,
                                          cashCharge: santraList.cashCharges,
                                          deliveryCharge:
                                              santraList.deliveryCharges,
                                          discount: santraList.orderDiscount,
                                        );
                                }),
                            SpacingHeight.heightlistspacing50,
                            if (_.typedOrdersLoading) 
                              Skeletonizer(
                                ignoreContainers: false,
                                enabled: true,
                                  child: ListView.builder(
                                itemCount: 1,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => CustomCard(
                                          customerPhone:
                                              order.customerPhone,
                                          orderType: order.orderType,
                                          title: 'Card',
                                          orderStatus:
                                              order.orderStatus.toString(),
                                          totalPrice: order
                                              .totalOrderAmount
                                              .toString(),
                                          orderRemarks: order.orderRemarks
                                              .toString(),
                                          orderTime: order.orderDateStamp
                                              .toString(),
                                          area: order.areaCustomer,
                                          deliveryTime:
                                              order.advanceTime.toString(),
                                          customerName: order.customerName
                                              .toString(),
                                          paymentMethod:
                                              Get.locale!.languageCode == 'en'
                                                  ? _.getEnglishPaymentMethod(
                                                      order.paymentMethod
                                                          .toString())
                                                  : _.getArabicPaymentMethod(
                                                      order.paymentMethod
                                                          .toString()),
                                          orderNumber:
                                              order.orderNumber.toString(),
                                          paymentLink:
                                              order.paymentLink.toString(),
                                          orderItemList: order.orderItems,
                                          requestImage: order.requestImage,
                                          attachedPdf: order.pdfLink,
                                          cashCharge: order.cashCharges,
                                          deliveryCharge:
                                              order.deliveryCharges,
                                          discount: order.orderDiscount,
                                        )
                              )),
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
                            _.isRejectOrderLoading ||
                            _.isOrderReadyLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container()
                  ],
                );
        },
      ),
    );
  }

  Future<dynamic> newShhet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return GetBuilder<AppTranslations>(builder: (tr) {
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
                              Consumer<SplashProvider>(
                                  builder: (context, splashPro, child) {
                                return SvgPicture.asset(
                                  tr.selectedLanguage == 'en_us'
                                      ? UIDATAIcons.forwardArrow
                                      : UIDATAIcons.back,
                                  color: Colors.black,
                                );
                              }),
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
                      btntxt:
                          '${tr.translateData('filter_showing_button')} ${_.filteredAllOrders.length} ${tr.translateData('filter_result_button')}',
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
      
      isBackHomeScreen: true,
      showAppBar: true,
      
      // scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appbarSvg: true,
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
