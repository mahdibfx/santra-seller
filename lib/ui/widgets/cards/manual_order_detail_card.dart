import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/cards/my_customer_card.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';

import '../../../models/home_model.dart';
import '../../../provider/cart_provider.dart';
import '../../../provider/home_provider.dart';
import '../../../utils/uidata/textStyles.dart';
import '../buttons/material_buttons/raised_gradient_button.dart';

class ManualOrderCard extends StatefulWidget {
  final String orderStatus;
  final String orderTime;
  final String customerName;
  final String deliveryTime;
  final String paymentMethod;
  final String colorCode;

  final String orderNumber;
  final String totalPrice;

  List<OrderItem> orderItemList;

  ManualOrderCard({
    required this.orderStatus,
    required this.orderTime,
    required this.deliveryTime,
    required this.customerName,
    required this.paymentMethod,
    required this.orderNumber,
    required this.orderItemList,
    required this.totalPrice,
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
    return GetBuilder<AppTranslations>(
      builder: (tr)  {
        return Consumer<HomeProvider>(builder: (context, _, child) {
          return InkWell(
            onTap: _toggleCard,
            child: Container(
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
                       
                             
                               Center(
                                child: SvgPicture.asset(
                                  _isOpen
                                      ? UIDATAIcons.cardOpen
                                      : UIDATAIcons.cardClose,
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
                                      widget.deliveryTime.toString().isEmpty
                                          ? const Text('---')
                                          : Text('${widget.deliveryTime}'),
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
                    height: widget.orderStatus.toLowerCase() == 'accepted'
                        ? (_heightFactorAnimation.value *
                            (Get.locale!.languageCode == 'en' ? 155 + _calculateContainerHeight(): 161 + _calculateContainerHeight()))
                        : (_heightFactorAnimation.value *
                            (Get.locale!.languageCode == 'en' ? 84 + _calculateContainerHeight():91 +
                                _calculateContainerHeight())), //@todo repeat order button hide when unhide it change the height to 155
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0)),
                    ),
                    child: Column(
                      children: [
                        SpacingHeight.heightlistspacing15,
                        
                          SizedBox(
                            height: _calculateContainerHeight(),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.orderItemList.length,
                                itemBuilder: (context, index) {
                                  return OrderItemWidget(
                                    imageString: widget.orderItemList[index].productImage,
                                    productQuantity:
                                        widget.orderItemList[index].productQuantity,
                                    productName: Get.locale!.languageCode == 'en' ?  widget.orderItemList[index].productName : widget.orderItemList[index].productNameArabic,
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
                        ).marginOnly(left: 10, right: 10),
                        SpacingHeight.heightlistspacing10,
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: _.getColor(widget.orderStatus),
                             borderRadius:widget.orderStatus.toLowerCase() == 'accepted' ?const BorderRadius.all(Radius.zero) :  const BorderRadius.only(
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
                                    confirmationPopup(tr.translateData("sure_message"), context, () {
                                      _.readyOrderMethod(widget.orderNumber);
                                    });
                                  },
                                ).marginAll(10);
                              })
                            : SizedBox(),
                      
                      ],
                    ),
                  ),
                ],
              ),
            ).paddingOnly(bottom: 20),
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
    return (widget.orderItemList.length == 2 ? 140 : widget.orderItemList.length == 1 ?  70 :widget.orderItemList.length > 3 ? 210 :5)
        .toDouble(); // 70 is the height of each ListTile
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
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: "https://api.santra.ae/$imageString",
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
