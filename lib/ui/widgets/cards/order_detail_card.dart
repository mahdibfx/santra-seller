import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/snackbar/common_snackbar.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';
import '../../../models/home_model.dart';
import '../../../provider/home_provider.dart';
import '../../../utils/uidata/textStyles.dart';
import '../buttons/border_button.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final String orderTime;
  final String customerName;
  final String deliveryTime;
  final String paymentMethod;
  final String orderRemarks;
  final String orderNumber;
  final String totalPrice;
  final String orderStatus;
  final String paymentLink;
  List<OrderItem> orderItemList;

  CustomCard({
    required this.title,
    required this.orderRemarks,
    required this.orderTime,
    required this.deliveryTime,
    required this.customerName,
    required this.paymentMethod,
    required this.orderNumber,
    required this.orderItemList,
    required this.totalPrice,
    required this.orderStatus,
    required this.paymentLink,
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactorAnimation;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
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
    return GetBuilder<AppTranslations>(
      builder: (tr) {
        return Consumer<HomeProvider>(builder: (context, _, child) {
          return GestureDetector(
            onTap: _toggleCard,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
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
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              UIDATAIcons.ordeBascketFull,
                              color: UIDataColors.primaryColor,
                            ),
                            SpacingWidth.widthlistspacing,
                            Text(
                              '${tr.translateData('order_number')} ${widget.orderNumber}',
                              style: UIDataTextStyles.h2.copyWith(fontSize: 12),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: UIDataColors.primaryColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  _isOpen
                                      ? UIDATAIcons.cardOpen
                                      : UIDATAIcons.cardClose,
                                ),
                              ),
                            ),
                          ],
                        ).marginOnly(left: 10, right: 10, top: 10, bottom: 10),
                        Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        UIDATAIcons.orderTime,
                                        color: UIDataColors.primaryColor,
                                      ),
                                      SpacingWidth.widthlistspacing,
                                      Text(dateFormat(widget.orderTime)),
                                    ],
                                  )),
                                  const Spacer(),
                                  Container(
                                      child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        UIDATAIcons.deliveryIcon,
                                        color: UIDataColors.primaryColor,
                                      ),
                                      SpacingWidth.widthlistspacing,
                                      Text('${widget.deliveryTime}'),
                                    ],
                                  )),
                                ],
                              ).marginOnly(left: 10, right: 10, top: 10, bottom: 5),
                              Row(
                                children: [
                                  Container(
                                      child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        height: 16,
                                        UIDATAIcons.userIcon,
                                        color: UIDataColors.primaryColor,
                                      ),
                                      SpacingWidth.widthlistspacing,
                                      Text('${widget.customerName}'),
                                    ],
                                  )),
                                  const Spacer(),
                                  Container(
                                      child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        UIDATAIcons.paymentMethod,
                                        color: UIDataColors.primaryColor,
                                      ),
                                      SpacingWidth.widthlistspacing,
                                      Text('${widget.paymentMethod}'),
                                    ],
                                  )),
                                ],
                              ).marginOnly(left: 10, right: 10, top: 5, bottom: 10),
                            ],
                          ),
                        ),
                        _isOpen
                            ? const SizedBox()
                            : Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _.getColor(widget.orderStatus),
                                  borderRadius: const BorderRadius.only(
                                      // topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      // topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0)),
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
                    height: widget.orderItemList.isEmpty ? 
                    (_heightFactorAnimation.value *
                            (Get.locale!.languageCode == 'en' ? 173 + _calculateContainerHeight(): 179 + _calculateContainerHeight())) :
                    widget.orderRemarks.toString().isEmpty
                        ? (_heightFactorAnimation.value *
                            (Get.locale!.languageCode == 'en' ? 130 + _calculateContainerHeight():136 + _calculateContainerHeight()))
                        : (_heightFactorAnimation.value *
                            (Get.locale!.languageCode == 'en' ? 173 + _calculateContainerHeight(): 179  + _calculateContainerHeight())),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                    ),
                    child: Column(
                      children: [
                        SpacingHeight.heightlistspacing10,
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
                                  productName:
                                  Get.locale!.languageCode == 'en' ?    widget.orderItemList[index].productName : widget.orderItemList[index].productNameArabic,
                                  productPrice:
                                      widget.orderItemList[index].productTotal,
                                );
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(tr.translateData("total_price"),
                                style:
                                    UIDataTextStyles.textMediumColoredBlue.copyWith(
                                  color: UIDataColors.blackColor,
                                )),
                            SpacingWidth.widthlistspacing,
                            Text('${widget.totalPrice} AED',
                                style:
                                    UIDataTextStyles.textMediumColoredBlue.copyWith(
                                  color: UIDataColors.primaryColor,
                                )),
                          ],
                        ).marginOnly(right:10, left: 10),
                        widget.orderRemarks.isEmpty ? SizedBox() :
                        Container(
                          color: Colors.grey.shade200,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                UIDATAIcons.orderRemarks,
                                color: UIDataColors.primaryColor,
                              ),
                              Expanded(
                                child: Text(
                                  widget.orderRemarks,
                                  maxLines: 2,
                                ).marginOnly(left:10, top: 4, bottom: 4),
                              ),
                            ],
                          ).marginOnly(left: 10, right: 10),
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: _.getColor(widget.orderStatus),
                          ),
                          child: Center(
                            child: Text(
                              _.getStatus(widget.orderStatus),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SpacingHeight.heightlistspacing10,
                        // const Spacer(),
                        widget.orderStatus == 'payment_pending'
                            ? Row(
                                children: [
                                  Expanded(
                                    child: BorderButton(
                                      height: 40,
                                          width: 140,
                                      btntxt: tr.translateData("button_cancel"),
                                      borderColor: Colors.red,
                                      buttontxtColor: Colors.red,
                                      backEndColor: Colors.white,
                                      onPressed: () {
                                        showpopup(
                                            tr.translateData('cancel_order_message'),
                                            () {
                                          Get.back();
                                          _.cancelOrdermethod(widget.orderNumber);
                                        });
                                      },
                                    ),
                                  ),
                                  SpacingWidth.widthlistspacing,
                                  widget.paymentLink == 'no_link'
                                      ? Container()
                                      : Expanded(
                                          child: BorderButton(
                                            height: 40,
                                          width: 140,
                                            btntxt: tr.translateData('button_copy_payment_link'),
                                            // borderColor: Colors.blue,
                                            buttontxtColor: Colors.white,
                                            // backEndColor: Colors.blue,
                                            onPressed: () async {
                                              await Clipboard.setData(ClipboardData(
                                                      text: widget.paymentLink))
                                                  .then((value) {
                                                CommonSnackbar.getSnackbar(
                                                    "Copied",
                                                    "Payment link has been copied in to clipbaord",
                                                    UIDataColors.primaryColor);
                                              });
          
                                              // copied successfully
                                            },
                                          ),
                                        ),
                                ],
                              ).marginOnly(left:15, right: 15, bottom: 10)
                            : widget.orderStatus == 'assigned_3pl'
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: BorderButton(
                                          height: 40,
                                          width: 140,
                                          btntxt: tr.translateData("button_cancel"),
                                          borderColor: Colors.red,
                                          buttontxtColor: Colors.red,
                                          backEndColor: Colors.white,
                                          onPressed: () {
                                            showpopup(
                                                tr.translateData('cancel_message'),
                                                () {
                                              Get.back();
                                              _.cancelOrdermethod(widget.orderNumber);
                                            });
                                          },
                                        ),
                                      ),
                                      SpacingWidth.widthlistspacing15,
                                      // Expanded(
                                      //   child: Consumer<CartProvider>(
                                      //       builder: (context, cartProvider, child) {
                                      //     return BorderButton(
                                      //       height: 40,
                                      //       width: 140,
                                      //       btntxt: 'Repeat Order',
                                      //       borderColor: Colors.blue,
                                      //       buttontxtColor: Colors.white,
                                      //       // backEndColor: Colors.blue,
                                      //       onPressed: () {
                                      //         for (var e in widget.orderItemList) {
                                      //           var data = CartItem(
                                      //               quantity:
                                      //                   int.parse(e.productQuantity),
                                      //               imageString:
                                      //                   e.productImage.toString(),
                                      //               name: e.productName.toString(),
                                      //               price: double.parse(e.productTotal
                                      //                   .toString()), //@todo confirm what is total price backend
                                      //               code: '', //@todo add code backend
                                      //               subModifiers: []); //@todo add modifiers from backend
                                      //           cartProvider.addToCart(data);
                                      //         }
                                      //       },
                                      //     );
                                      //   }),
                                      // ),
                                    ],
                                  ).marginOnly(left:15, right: 15, bottom: 10)
                                : Row(
                                    children: [
                                      Expanded(
                                        child: BorderButton(
                                          height: 40,
                                          width: 140,
                                          btntxt: tr.translateData('button_reject'),
                                          borderColor: Colors.red,
                                          buttontxtColor: Colors.red,
                                          backEndColor: Colors.white,
                                          onPressed: () {
                                            showpopup(
                                                tr.translateData('reject_message'),
                                                () {
                                              Get.back();
                                              _.rejectOrderMethod(widget.orderNumber);
                                            });
                                          },
                                        ),
                                      ),
                                      SpacingWidth.widthlistspacing15,
                                      Expanded(
                                        child: BorderButton(
                                          height: 40,
                                          width: 140,
                                          btntxt: tr.translateData('button_accept'),
                                          // borderColor: Colors.blue,
                                          buttontxtColor: Colors.white,
                                          // backEndColor: Colors.blue,
                                          onPressed: () {
                                            showpopup(
                                                tr.translateData('accept_message'),
                                                () {
                                              Get.back();
                                              _.acceptOrdermethod(widget.orderNumber);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ).marginOnly(left:15, right: 15, bottom: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ).marginOnly(bottom: 20),
          );
        });
      }
    );
  }

  String dateFormat(String date) {
    var inputFormat = DateTime.parse(date);
    var outputFormat = DateFormat('hh:mm a yyyy/MM/dd');
    var outputDate = outputFormat.format(inputFormat);
    return outputDate;
  }

  double _calculateContainerHeight() {
    return (widget.orderItemList.length == 2 ? 140 : widget.orderItemList.length == 1 ?  70 :widget.orderItemList.isEmpty ? 0 :210)
        .toDouble(); // 70 is the height of each ListTile
  }

  void showpopup(String statement, dynamic navigationFunction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<AppTranslations>(
      builder: (tr)  {
            return AlertDialog(
              title:  Text(tr.translateData("confirmation")),
              content: Text(statement),
              actions: [
                Container(
                  padding: EdgeInsets.all(8),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: BorderButton(
                          // height: 35,
                          // width: 140,
                          btntxt: tr.translateData("button_cancel"),
                          borderColor: Colors.red,
                          buttontxtColor: Colors.red,
                          backEndColor: Colors.white,
                          // backEndColor: Colors.blue,
                          onPressed: () {
                            Get.back();
                          },
                          //  () {
                          //   _.acceptOrdermethod(widget.orderNumber);
                          // },
                        ),
                      ),
                      SpacingWidth.widthlistspacing15,
                      Expanded(
                        child: BorderButton(
                          // height: 35,
                          // width: 140,
                          btntxt: tr.translateData("okay"),
                          // borderColor: Colors.blue,
                          buttontxtColor: Colors.white,
                          // backEndColor: Colors.blue,
                          onPressed: navigationFunction,
                          //  () {
                          //   _.acceptOrdermethod(widget.orderNumber);
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class OrderItemWidget extends StatelessWidget {
  final String imageString;
  final String productName;
  final String productQuantity;
  final String productPrice;

  const OrderItemWidget({
    super.key,
    required this.imageString,
    required this.productQuantity,
    required this.productName,
    required this.productPrice,
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
              SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                        // padding: const EdgeInsets.all(5),
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: "https://api.santra.ae/$imageString",
                              fit: BoxFit.fill,
                              // memCacheHeight: 500,
                              // memCacheWidth: 400,
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(),
                              ),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: UIDataTextStyles.h2.copyWith(fontSize: 12),
                        ),
                        Text('x$productQuantity'),
                      ],
                    ).marginOnly(top: 5),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    '$productPrice AED',
                    style: UIDataTextStyles.heading15Medium.copyWith(
                        color: UIDataColors.primaryColor, fontSize: 12),
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
