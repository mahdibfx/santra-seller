import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/cards/my_customer_card.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/ext.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/home_model.dart';
import '../../../provider/cart_provider.dart';
import '../../../provider/home_provider.dart';
import '../../../utils/uidata/textStyles.dart' hide tr;
import '../buttons/material_buttons/raised_gradient_button.dart';
import '../dialogs/full_screen_image.dart';

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
                    Container(
                      color: Colors.grey.shade200,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    UIDATAIcons.orderTime,
                                    color: UIDataColors.primaryColor,
                                  ),
                                  SpacingWidth.widthlistspacing,
                                  Text(dateFormat(widget.orderTime)),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    UIDATAIcons.deliveryIcon,
                                    color: UIDataColors.primaryColor,
                                  ),
                                  SpacingWidth.widthlistspacing,
                                  widget.deliveryTime.toString().isEmpty
                                      ? const Text('---')
                                      : Text(widget.deliveryTime),
                                ],
                              ),
                            ],
                          ).marginOnly(left: 10, right: 10, top: 10, bottom: 5),
                          Row(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    height: 16,
                                    UIDATAIcons.userIcon,
                                    color: UIDataColors.primaryColor,
                                  ),
                                  SpacingWidth.widthlistspacing,
                                  Text(widget.customerName),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    UIDATAIcons.paymentMethod,
                                    color: UIDataColors.primaryColor,
                                  ),
                                  SpacingWidth.widthlistspacing,
                                  Text(widget.paymentMethod),
                                ],
                              ),
                            ],
                          ).marginOnly(left: 10, right: 10, top: 5, bottom: 5),
                          !widget.orderType.contains("Delivery")
                              ? Row(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          height: 16,
                                          UIDATAIcons.callIcon,
                                          color: UIDataColors.primaryColor,
                                        ),
                                        SpacingWidth.widthlistspacing,
                                        Text(widget.customerPhone),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          height: 16,
                                          UIDATAIcons.orderBascketBorder,
                                          color: UIDataColors.primaryColor,
                                        ),
                                        SpacingWidth.widthlistspacing,
                                        Text(widget.orderType.toLowerCase() ==
                                                "express"
                                            ? tr.translateData("express")
                                            : widget.orderType.toLowerCase() ==
                                                    "pickup"
                                                ? tr.translateData("pickup")
                                                : widget.orderType
                                                            .toLowerCase() ==
                                                        "delivery"
                                                    ? tr.translateData(
                                                        "delivery")
                                                    : widget.orderType
                                                                .toLowerCase() ==
                                                            "vip"
                                                        ? tr.translateData(
                                                            "vip")
                                                        : ""),
                                      ],
                                    ),
                                  ],
                                ).marginOnly(
                                  left: 10, right: 10, top: 5, bottom: 10)
                              : Container().marginOnly(bottom: 5),
                        ],
                      ),
                    ),
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
                        // height: _calculateContainerHeight(),
//                              child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: 5,
// physics: const NeverScrollableScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               return OrderItemWidget(
//                                 imageString:
//                                     widget.orderItemList[0].productImage,
//                                 productQuantity:
//                                     widget.orderItemList[0].productQuantity,
//                                 productName: Get.locale!.languageCode == 'en'
//                                     ? widget.orderItemList[0].productName
//                                     : widget
//                                         .orderItemList[0].productNameArabic,
//                                 productPrice:
//                                     widget.orderItemList[0].productTotal,
//                               );
//                             }),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.orderItemList.length,
                            itemBuilder: (context, index) {
                              return OrderItemWidget(
                                itemRemarks:
                                    widget.orderItemList[index].itemRemarks,
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
                                images: widget.orderItemList[index].itemImages,
                                pdf: widget.orderItemList[index].itemPdf,
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
                                          child: Wrap(
                                            children: [
                                              Text(widget.orderRemarks,
                                                      maxLines: 3)
                                                  .marginOnly(
                                                      left: 10,
                                                      top: 4,
                                                      bottom: 4),
                                            ],
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
                    widget.orderStatus.toLowerCase() == 'accepted'
                        ? Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                            return RaisedGradientButton(
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  UIDataColors.primaryColor,
                                  UIDataColors.primaryColor,
                                ],
                              ),
                              btntxt: tr.translateData("ready_order"),
                              iconImage: SvgPicture.asset(
                                UIDATAIcons.sendIcon,
                                height: 25,
                                width: 25,
                                fit: BoxFit.fitWidth,
                              ),
                              buttontxtColor: UIDataColors.whiteColor,
                              onPressed: () {
                                confirmationPopup(
                                    tr.translateData("sure_message"), context,
                                    () {
                                  _.readyOrderMethod(widget.orderNumber);
                                });
                              },
                            ).marginAll(10);
                          })
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ).paddingOnly(bottom: 20);
      });
    });
  }

  String dateFormat(String date) {
    var inputFormat = DateTime.parse(date);
    var outputFormat = DateFormat('hh:mm a yyyy/MM/dd');
    var outputDate = outputFormat.format(inputFormat);
    return outputDate;
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

class OrderCalculations extends StatelessWidget {
  final AppTranslations tr;
  final String? title;
  final String? amount;
  const OrderCalculations({
    super.key,
    required this.tr,
    this.amount,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(tr.translateData(title ?? ""),
            style: UIDataTextStyles.textMediumColoredBlue.copyWith(
              color: UIDataColors.blackColor,
            )),
        SpacingWidth.widthlistspacing,
        Text('$amount AED',
            style: UIDataTextStyles.textMediumColoredBlue.copyWith(
              color: UIDataColors.primaryColor,
            )),
      ],
    ).paddingOnly(
      right: Get.locale?.languageCode == "ar" ? 0 : 10,
      bottom: 8,
      left: Get.locale?.languageCode == "ar" ? 10 : 0,
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final String imageString;
  final String productName;
  final String productQuantity;
  final String productPrice;
  final String itemRemarks;
  final List<String> images;
  final String pdf;
  const OrderItemWidget({
    super.key,
    required this.imageString,
    required this.productQuantity,
    required this.productName,
    required this.productPrice,
    required this.itemRemarks,
    required this.images,
    required this.pdf,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: Row(
                    children: [
                      SizedBox(
                          // padding: const EdgeInsets.all(5),
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: imageString,
                                fit: BoxFit.cover,
                                memCacheHeight: 300,
                                memCacheWidth: 400,
                                placeholder: (context, url) => const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: CircularProgressIndicator(),
                                ),
                              ))),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: context.width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName ,
                              overflow: TextOverflow.ellipsis,
                              style: UIDataTextStyles.h2.copyWith(fontSize: 12),
                            ),
                            if (images
                                    .where((e) => e.isNotEmpty)
                                    .toList()
                                    .isNotEmpty ||
                                pdf.isNotEmpty ||
                                itemRemarks != "no_remarks")
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      builder: (c) => Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                16.vSpace(),
                                                if (itemRemarks != "no_remarks")
                                                   Text(
                                                   tr.translateData("special_request"),
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                if (itemRemarks != "no_remarks")
                                                  16.vSpace(),
                                                if (itemRemarks != "no_remarks")
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(.06),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8)),
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .all(14),
                                                    child: Text(itemRemarks),
                                                  ),
                                                16.vSpace(),
                                                if (images
                                                        .where(
                                                            (e) => e.isNotEmpty)
                                                        .toList()
                                                        .isNotEmpty ||
                                                    pdf.isNotEmpty)
                                                   Text(
                                              tr.translateData("attachements"),
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                if (images
                                                        .where(
                                                            (e) => e.isNotEmpty)
                                                        .toList()
                                                        .isNotEmpty ||
                                                    pdf.isNotEmpty)
                                                  16.vSpace(),
                                                if (images
                                                        .where(
                                                            (e) => e.isNotEmpty)
                                                        .toList()
                                                        .isNotEmpty ||
                                                    pdf.isNotEmpty)
                                                  SizedBox(
                                                    height: 60,
                                                    child: ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: [
                                                        ...List.generate(
                                                            images.where((e)=>e.isNotEmpty).length,
                                                            (index) =>
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    showDialog(
                                                                        barrierColor:
                                                                            Colors
                                                                                .transparent,
                                                                        context:
                                                                            context,
                                                                        builder: (c) =>
                                                                            Stack(
                                                                              children: [
                                                                                Positioned.fill(
                                                                                    child: BackdropFilter(
                                                                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                                                                  child: Container(
                                                                                    color: Colors.transparent.withOpacity(0.5),
                                                                                  ),
                                                                                )),
                                                                                Positioned(
                                                                                    left: 20,
                                                                                    right: 20,
                                                                                    top: MediaQuery.of(context).size.height *.2,
                                                                                                                                                                    
                                                                                    bottom: MediaQuery.of(context).size.height *.2,
                
                                                                                    child: Stack(
                                                                                      children: [
                                                                                        Container(
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(images[index]))),
                                                                                        ),
                                                                                         PositionedDirectional(end: 8,top: 8, child: GestureDetector(onTap: () {
                                                                                          Get.back();
                                                                                        }, child: const CircleAvatar(radius: 14, backgroundColor: Colors.white,child: Icon(Icons.close,size: 16,),)))
                                                                                      ],
                                                                                    ))
                                                                              ],
                                                                            ));
                                                                  },
                                                                  child: Hero(
                                                                    tag: images[
                                                                        index],
                                                                    child:
                                                                        Container(
                                                                      margin: const EdgeInsetsDirectional
                                                                          .only(
                                                                          end: 4),
                                                                      width: 60,
                                                                      height: 60,
                                                                      decoration: BoxDecoration(
                                                                           borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                          image: DecorationImage(
                                                                              image:
                                                                                  CachedNetworkImageProvider(images[index]),
                                                                              fit: BoxFit.cover)),
                                                                    ),
                                                                  ),
                                                                )),
                                               if(pdf.isNotEmpty)         GestureDetector(
                                                          onTap: () async {
                   
                    await launchUrl(
                      pdf.toUri(),
                      mode: LaunchMode.externalApplication,
                    );
                                                          },
                                                          child: Container(
                                                            width: 60,
                                                            decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: const Icon(
                                                              Icons
                                                                  .picture_as_pdf_outlined,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                16.vSpace(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.stretch,
                                                  children: [
                                                    FilledButton(
                                                        style: FilledButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            backgroundColor:
                                                                Colors.teal),
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child:
                                                             Text(tr.translateData("done"))),
                                                             16.vSpace()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ));
                                },
                                child: Row(
                                  children: [
                                    Text('x$productQuantity'),
                                    4.hSpace(),
                                     Text(
                                      tr.translateData("see_special_request"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: UIDataColors.primaryColor),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ).marginOnly(top: 5),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    '$productPrice AED',
                    style: UIDataTextStyles.textMediumColoredBlue.copyWith(
                      color: UIDataColors.primaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const Divider(),
      ],
    ).paddingSymmetric(horizontal: 10);
  }
}
