import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/view_customer_details.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/vouchers_section.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/ui/widgets/buttons/rounded_button.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../utils/uidata.dart';
import '../../widgets/add_manual_order_widgets/cart_card.dart';
import '../../widgets/add_manual_order_widgets/cart_payment_des.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../add_manual_order/add_manual_order.dart';

class CartScreen extends StatefulWidget {
  final bool isOrderReady;

  const CartScreen({
    super.key,
    this.isOrderReady = false,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  hitAllApis() async {
    await Future.microtask(() {
      if (context.read<CartProvider>().cartItems.isNotEmpty) {
        context.read<CartProvider>().cartScreenData();
      }
    });
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
  }

  Widget bodyData(context) {
    var sizedBoxHeight = const SizedBox(height: 10);
    return GetBuilder<AppTranslations>(builder: (tr) {
      return Consumer<CartProvider>(
        builder: (context, _, child) {
          return _.isLoading
              ? const SizedBox(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : ModalProgressHUD(
                  inAsyncCall:
                      _.isCartLoading || _.isDiscountLoading ? true : false,
                  progressIndicator: const CircularProgressIndicator(),
                  child: SafeArea(
                    child: SingleChildScrollView(
                        child: _.cartItems.isEmpty
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: Center(
                                    child:
                                        Text(tr.translateData("empty_cart"))))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HeadingWithIcon(
                                      icon: UIDATAIcons.cartHallowIcon,
                                      btntxt: tr.translateData("cart_title")),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.black.withOpacity(0.08),
                                        //     spreadRadius: 1,
                                        //     blurRadius: 10,
                                        //     offset: const Offset(0,
                                        //         0), // changes position of shadow
                                        //   ),
                                        // ],
                                      ),
                                      height: _.cartItems.length > 2
                                          ? (2 * 145) + 60
                                          : _.cartItems.length * 145,
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _.cartItems.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: CartCardOrder(
                                                allProducts: _.cartItems,
                                                index: index,
                                                onDecrese: () =>
                                                    _.decreaseQuantity(
                                                        _.cartItems[index]),
                                                onIncrese: () =>
                                                    _.increaseProductQuantity(
                                                        _.cartItems[index]),
                                                quantity: _
                                                    .cartItems[index].quantity
                                                    .toString(),
                                              ),
                                            );
                                          })),
                                  // SpacingHeight.heightlistspacing10,
                                  _.isCartLoading
                                      ? Center(
                                          child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(tr.translateData(
                                              "voucher_loading")),
                                        ))
                                      : VouchersSection(),
                                  SpacingHeight.heightlistspacing20,
                                  HeadingWithIcon(
                                      icon: UIDATAIcons.deliveryIcon,
                                      btntxt: tr.translateData(
                                          "choose_delivery_method")),
                                  SpacingHeight.heightlistspacing10,
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        color: Colors.white),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: RoundedButton(
                                          onTap: () {
                                            _.setDeliveryMethod("delivery");
                                          },
                                          fontSize: 14,
                                          title: tr.translateData("delivery"),
                                          bgColor:
                                              _.deliveryMethod == "delivery"
                                                  ? UIDataColors.primaryColor
                                                  : Colors.white,
                                          textColor:
                                              _.deliveryMethod == "delivery"
                                                  ? UIDataColors.whiteColor
                                                  : Colors.black,
                                        )),
                                        if (_.showExpress == "yes")
                                          Expanded(
                                              child: RoundedButton(
                                            onTap: () {
                                              _.setDeliveryMethod("express");
                                            },
                                            fontSize: 14,
                                            title: "Express",
                                            bgColor:
                                                _.deliveryMethod == "express"
                                                    ? UIDataColors.primaryColor
                                                    : Colors.white,
                                            textColor:
                                                _.deliveryMethod == "express"
                                                    ? UIDataColors.whiteColor
                                                    : Colors.black,
                                          )),
                                        if (_.showPickup == "yes")
                                          Expanded(
                                              child: RoundedButton(
                                            onTap: () {
                                              _.setDeliveryMethod("pickup");
                                            },
                                            fontSize: 14,
                                            title: tr.translateData("pickup"),
                                            bgColor:
                                                _.deliveryMethod == "pickup"
                                                    ? UIDataColors.primaryColor
                                                    : Colors.white,
                                            textColor:
                                                _.deliveryMethod == "pickup"
                                                    ? UIDataColors.whiteColor
                                                    : Colors.black,
                                          )),
                                        if (_.showVip == "yes")
                                          Expanded(
                                              child: RoundedButton(
                                            onTap: () {
                                              _.setDeliveryMethod("vip");
                                              // showModalBottomSheet(
                                              //     backgroundColor: Colors.white,
                                              //     isScrollControlled: true,
                                              //     context: context,
                                              //     builder: (context) {
                                              //       return StatefulBuilder(
                                              //           builder: (context,
                                              //               stateSetter) {
                                              //         return ;
                                              //       });
                                              //     });
                                            },
                                            fontSize: 14,
                                            title: "VIP",
                                            bgColor: _.deliveryMethod == "vip"
                                                ? UIDataColors.primaryColor
                                                : Colors.white,
                                            textColor: _.deliveryMethod == "vip"
                                                ? UIDataColors.whiteColor
                                                : Colors.black,
                                          )),
                                      ],
                                    ),
                                  ),
                                  if (_.deliveryMethod != "vip")
                                    SpacingHeight.heightlistspacing20,

                                  (_.deliveryMethod == "delivery" ||
                                          _.deliveryMethod == "pickup")
                                      ? DatePickerOnCart(
                                          tr: tr,
                                          cart: _,
                                        ).paddingOnly(bottom: 20)
                                      : _.deliveryMethod == "vip"
                                          ? VIPDeliveryWithTimeSlotsAndCalendar(
                                              sizedBoxHeight: sizedBoxHeight,
                                              cart: _)
                                          : const SizedBox(),
                                  CartPayemntDescriptionCard(
                                    subtotal: _.totalPrice.toStringAsFixed(2),
                                    total: _.grandTotal.toStringAsFixed(2),
                                    deliveryCharges: _.deliveryFee.toString(),
                                    discount: _.dis.toString(),
                                    tax: _.vatTax.toString(),
                                  ),
                                  SpacingHeight.heightlistspacing50
                                ],
                              ).paddingSymmetric(horizontal: 15)),
                  ),
                );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      showBottomNav: true,
      showActions: false,
      appbarcolor: UIDataColors.whiteColor,
      appbarSvg: true,
      backarrow: UIDataColors.whiteColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
    );
  }
}

class DatePickerOnCart extends StatelessWidget {
  final CartProvider cart;
  final AppTranslations tr;
  const DatePickerOnCart({super.key, required this.cart, required this.tr});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ]),
      child: Column(
        children: [
          HeadingWithIcon(
            icon: UIDATAIcons.calendarIcon,
            btntxt: tr.translateData("cart_delivery_date"),
            iconColor: UIDataColors.primaryColor,
          ).paddingSymmetric(horizontal: 20),
          CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                  firstDate: DateTime.now(),
                  currentDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 180)),
                  weekdayLabelTextStyle:
                      const TextStyle(color: Colors.black, fontSize: 12),
                  selectedDayHighlightColor: UIDataColors.primaryColor),
              value: cart.dates,
              onValueChanged: (dates) {
                cart.dates = dates;
                cart.setDeliveryDate();
              }),
        ],
      ),
    );
  }
}

class VIPDeliveryWithTimeSlotsAndCalendar extends StatefulWidget {
  final CartProvider cart;
  const VIPDeliveryWithTimeSlotsAndCalendar(
      {super.key, required this.sizedBoxHeight, required this.cart});

  final SizedBox sizedBoxHeight;

  @override
  State<VIPDeliveryWithTimeSlotsAndCalendar> createState() =>
      _VIPDeliveryWithTimeSlotsAndCalendarState();
}

class _VIPDeliveryWithTimeSlotsAndCalendarState
    extends State<VIPDeliveryWithTimeSlotsAndCalendar> {
  @override
  Widget build(BuildContext context) {
    var _ = Get.put(AppTranslations());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            HeadingWithIcon(
              icon: UIDATAIcons.locationPin,
              btntxt: _.translateData("vip_delivery"),
              iconColor: UIDataColors.primaryColor,
            ),
            // const Spacer(),
            // ButtonIcon(
            //     icon: UIDATAIcons.close,
            //     onPressed: () {
            //       Get.back();
            //     })
          ],
        ),
        // Image.asset(UIDataImage.vip),
        // sizedBoxHeight,
        Wrap(
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${_.translateData('book_vip')} ",
                      style: UIDataTextStyles.h3
                          .copyWith(color: UIDataColors.blackColor)),
                  TextSpan(
                      text: _.translateData("vip_description"),
                      style: UIDataTextStyles.subTitle.copyWith(
                          color: UIDataColors.blackColor.withOpacity(0.8))),
                ],
              ),
            ),
          ],
        ),
        widget.sizedBoxHeight,
        Text(_.translateData("choose_delivery_date"),
            style: UIDataTextStyles.title
                .copyWith(color: UIDataColors.primaryColor)),
        widget.sizedBoxHeight,
        TableCalendar(
          daysOfWeekStyle: const DaysOfWeekStyle(),
          calendarStyle: const CalendarStyle(
              isTodayHighlighted: false,
              selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle, color: UIDataColors.primaryColor)),
          selectedDayPredicate: (day) {
            return isSameDay(widget.cart.selectedVipDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            widget.cart.onVipDaySelected(selectedDay, focusedDay);
          },
          onPageChanged: (focusedDay) {
            widget.cart.focusedVipDay = focusedDay;
          },
          // startingDayOfWeek: StartingDayOfWeek.friday,

          firstDay: widget.cart.vipStart!,
          lastDay: widget.cart.vipEnd!,
          focusedDay:
          widget.cart.selectedVipDay == null
                ? widget.cart.vipStart!
                : widget.cart.selectedVipDay!,
          //  widget.cart.vipStart!,
          calendarFormat: CalendarFormat.week,
          headerVisible: false,
        ),
        Text(_.translateData("choose_delivery_time"),
            style: UIDataTextStyles.title
                .copyWith(color: UIDataColors.primaryColor)),
        widget.sizedBoxHeight,
        HourSelectorForVipDelivery(
          cartProvider: widget.cart,
          // stateSetter: stateSetter,
        ),
        // BorderButton(
        //   btntxt: "Save",
        //   onPressed: () {
        //     Get.back();
        //   },
        // ),

        widget.sizedBoxHeight
      ],
    );
  }
}
