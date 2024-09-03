import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/barcode/barcode_action_buttons.dart';
import 'package:santra_seller/ui/widgets/barcode/order_barcode_widget.dart';
import 'package:santra_seller/ui/widgets/cards/orders/order_calculations_widget.dart';
import 'package:santra_seller/ui/widgets/cards/orders/order_detail_card.dart';
import 'package:santra_seller/ui/widgets/cards/orders/order_linked_barcodes.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';

import '../../../../models/home_model.dart';
import '../../../../provider/home_provider.dart';
import '../../../../utils/uidata/textStyles.dart';
import '../../dialogs/full_screen_image.dart';
import 'top_order_more_details.dart';
class ManualOrderCard extends StatefulWidget {
  final String orderStatus;
  final String orderTime;
  final String customerName;
  final String deliveryTime;
  final String paymentMethod;
  final String colorCode;
  final String orderType;
  final String orderNumber;
  final String totalPrice;
  final String? cashCharge;
  final String? discount;
  final String? deliveryCharge;
  final String customerPhone;
  final String orderRemarks;
  final String? attachedPdf;
  final String? requestImage;
  final String? area;
  List<OrderItem> orderItemList;

  ManualOrderCard({
    super.key,
    required this.customerPhone,
    required this.orderType,
    required this.orderStatus,
    required this.orderTime,
    required this.deliveryTime,
    this.cashCharge,
    this.deliveryCharge,
    this.discount,
    required this.customerName,
    required this.paymentMethod,
    required this.orderNumber,
    required this.orderItemList,
    required this.totalPrice,
    required this.orderRemarks,
    this.attachedPdf,
    required this.requestImage,
    required this.area,
    required this.colorCode,
  });

  @override
  _ManualOrderCardState createState() => _ManualOrderCardState();
}

class _ManualOrderCardState extends State<ManualOrderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactorAnimation;

  bool _isOpen = false;
  String color = '';

  @override
  void initState() {
    super.initState();
    color = '0xff${widget.colorCode}';
    _controller = AnimationController(
        vsync: this, duration: const Duration(microseconds: 10));
    _heightFactorAnimation =
        Tween<double>(begin: 0, end: 1).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
  }

  void _toggleCard() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppTranslations>(builder: (tr) {
      return Consumer<HomeProvider>(builder: (context, _, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(-1, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0)),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _toggleCard,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            UIDATAIcons.ordeBascketFull,
                            color: UIDataColors.primaryColor,
                          ),
                          SpacingWidth.widthlistspacing,
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Text(
                              ' ${widget.orderType.toLowerCase() == "express" ? tr.translateData("express") : widget.orderType.toLowerCase() == "pickup" ? tr.translateData("pickup") : widget.orderType.toLowerCase() == "delivery" ? tr.translateData("delivery") : widget.orderType.toLowerCase() == "vip" ? tr.translateData("vip") : ""} ${tr.translateData('order_number')} ${widget.orderNumber} - ${widget.area}',
                              style: UIDataTextStyles.h2.copyWith(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: SvgPicture.asset(
                              _isOpen
                                  ? UIDATAIcons.cardOpen
                                  : UIDATAIcons.cardClose,
                            ),
                          ),
                        ],
                      ).marginOnly(left: 10, right: 10, top: 10, bottom: 10),
                    ),
                    topOrderMoreDetails(tr,widget),
               
                    // !_isOpen
                    //     ? const SizedBox()
                    //     :

                    if (!_isOpen)
                      Container(
                        alignment: Alignment.center,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _.getColor(widget.orderStatus),
                          borderRadius: const BorderRadius.only(
                              // topRight: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              // topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0)),
                        ),
                        child: Center(
                          child: Text(
                            _.getStatus(widget.orderStatus),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

           if(_isOpen)   const OrderLinkedBarCodes(),
              Container(
                // height: widget.orderItemList.isEmpty
                //     ? (_heightFactorAnimation.value *
                //         (Get.locale!.languageCode == 'en'
                //             ? 173 + _calculateContainerHeight()
                //             : 179 + _calculateContainerHeight()))
                //     : widget.orderStatus.toLowerCase() == 'accepted'
                //         ? (_heightFactorAnimation.value *
                //             (Get.locale!.languageCode == 'en'
                //                 ? 190 + _calculateContainerHeight()
                //                 : 196 + _calculateContainerHeight()))
                //         : widget.orderRemarks.toString().isEmpty &&
                //                 widget.requestImage != ""
                //             ? (_heightFactorAnimation.value *
                //                 (Get.locale!.languageCode == 'en'
                //                     ? 230 + _calculateContainerHeight()
                //                     : 236 + _calculateContainerHeight()))
                //             : widget.orderRemarks.toString().isNotEmpty &&
                //                     widget.requestImage != ""
                //                 ? (_heightFactorAnimation.value *
                //                     (Get.locale!.languageCode == 'en'
                //                         ? 190 + _calculateContainerHeight()
                //                         : 196 + _calculateContainerHeight()))
                //                 : (_heightFactorAnimation.value *
                //                     (Get.locale!.languageCode == 'en'
                //                         //120
                //                         ? 173 + _calculateContainerHeight()
                //                         : 179 + _calculateContainerHeight())),
                //179

                //@todo repeat order button hide when unhide it change the height to 155
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isOpen) SpacingHeight.heightlistspacing15,
                    if (_isOpen)
                      SizedBox(
                        height: _calculateContainerHeight(),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.orderItemList.length,
                            itemBuilder: (context, index) {
                              return OrderItemWidget(
                                imageString:
                                    widget.orderItemList[index].productImage,
                                productQuantity:
                                    widget.orderItemList[index].productQuantity,
                                productName: Get.locale!.languageCode == 'en'
                                    ? widget.orderItemList[index].productName
                                    : widget
                                        .orderItemList[index].productNameArabic,
                                productPrice:
                                    widget.orderItemList[index].productTotal,
                              );
                            }),
                      ),
                    if (_isOpen)
                      Column(
                        children: [
                          if (widget.deliveryCharge != "0")
                            OrderCalculations(
                              tr: tr,
                              title: "cart_order_delivery_charge",
                              amount: widget.deliveryCharge,
                            ),
                          if (widget.cashCharge != "0")
                            OrderCalculations(
                              tr: tr,
                              title: "cash_charges",
                              amount: widget.cashCharge,
                            ),
                          if (widget.discount != "0")
                            OrderCalculations(
                              tr: tr,
                              title: "discount",
                              amount: widget.discount,
                            ),
                          OrderCalculations(
                            tr: tr,
                            title: "total_price",
                            amount: widget.totalPrice,
                          ),
                        ],
                      ),
                    if (_isOpen)
                      Column(
                        children: [
                          // SpacingHeight.heightlistspacing10,
                          if ((widget.orderRemarks.isNotEmpty ||
                              widget.requestImage != null))
                            Container(
                              width: double.infinity,
                              color: const Color(0xffF5F5F5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.orderRemarks.isNotEmpty)
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: SvgPicture.asset(
                                            UIDATAIcons.orderRemarks,
                                            color: UIDataColors.primaryColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              widget.orderRemarks,
                                              maxLines: 2,
                                            ).marginOnly(
                                                left: 10, top: 4, bottom: 4),
                                          ),
                                        ),
                                      ],
                                    ).marginOnly(left: 10, right: 10),
                                  Row(
                                    children: [
                                      if (widget.requestImage != "")
                                        GestureDetector(
                                          onTap: () => Get.to(() =>
                                              FullScreenImage(
                                                  image: widget.requestImage ??
                                                      "")),
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      widget.requestImage ?? "",
                                                  fit: BoxFit.cover,
                                                  memCacheHeight: 400,
                                                  memCacheWidth: 400,
                                                  placeholder: (context, url) =>
                                                      const Padding(
                                                    padding:
                                                        EdgeInsets.all(12.0),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ).paddingAll(10),
                                        ),
                                      if (widget.attachedPdf != "")
                                        GestureDetector(
                                          onTap: () => _.launchAttachedPdf(
                                              widget.attachedPdf!),
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  UIDATAIcons.pdfIcon,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    if (_isOpen)
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: _.getColor(widget.orderStatus),
                          borderRadius:
                              widget.orderStatus.toLowerCase() == 'accepted'
                                  ? const BorderRadius.all(Radius.zero)
                                  : const BorderRadius.only(
                                      // topRight: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                      // topLeft: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0)),
                        ),
                        child: Center(
                          child: Text(
                            _.getStatus(widget.orderStatus),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

//TODO:AFTER TESTING DONT FORGET TO UNCCOMMENT THIS
                    // widget.orderStatus.toLowerCase() == 'accepted'
                    //     ? Consumer<CartProvider>(
                    //         builder: (context, cartProvider, child) {
                    //         return RaisedGradientButton(
                    //           gradient: const LinearGradient(
                    //             colors: <Color>[
                    //               UIDataColors.primaryColor,
                    //               UIDataColors.primaryColor,
                    //             ],
                    //           ),
                    //           btntxt: tr.translateData("ready_order"),
                    //           iconImage: SvgPicture.asset(
                    //             UIDATAIcons.sendIcon,
                    //             height: 25,
                    //             width: 25,
                    //             fit: BoxFit.fitWidth,
                    //           ),
                    //           buttontxtColor: UIDataColors.whiteColor,
                    //           onPressed: () {
                    //             confirmationPopup(
                    //                 tr.translateData("sure_message"), context,
                    //                 () {
                    //               _.readyOrderMethod(widget.orderNumber);
                    //             });
                    //           },
                    //         ).marginAll(10);
                    //       })
                    //     : const SizedBox(),

                    /// this for in preparation status order
                    ActionButtonsBarcode(),
                  ],
                ),
              ),
            ],
          ),
        ).paddingOnly(bottom: 20);
      });
    });
  }

  



  double _calculateContainerHeight() {
    return (widget.orderItemList.length == 2
            ? 140
            : widget.orderItemList.length == 1
                ? 70
                : widget.orderItemList.isEmpty
                    ? 0
                    : 210)
        .toDouble(); // 70 is the height of each ListTile
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

