import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/vouchers_section.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import '../../../../utils/uidata.dart';
import '../../widgets/add_manual_order_widgets/cart_card.dart';
import '../../widgets/add_manual_order_widgets/cart_payment_des.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../add_manual_order/add_manual_order.dart';

class CartScreen extends StatefulWidget {
  final bool isOrderReady;
  const CartScreen({super.key, this.isOrderReady = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // CartController cartController = Get.put(CartController());
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
    return Consumer<AppTranslations>(
          builder: (context, tr, child){
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
                                  height: MediaQuery.of(context).size.height - 200,
                                  child: Center(child: Text(tr.translateData("empty_cart"))))
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
                                        height: _.cartItems.length > 3
                                            ? 3 * 105
                                            : _.cartItems.length * 105,
                                        child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            physics: const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _.cartItems.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: CartCardOrder(
                                                  allProducts: _.cartItems,
                                                  index: index,
                                                  onDecrese: () => _.removeFromCart(
                                                      _.cartItems[index]),
                                                  onIncrese: () => _.addToCart(
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
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(tr.translateData("voucher_loading")),
                                          ))
                                        : VouchersSection(),
                                    SpacingHeight.heightlistspacing20,
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: const Offset(0,
                                                  0), // changes position of shadow
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
                                                  lastDate: DateTime.now().add(
                                                      const Duration(days: 180)),
                                                  weekdayLabelTextStyle:
                                                      const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                  selectedDayHighlightColor:
                                                      UIDataColors.primaryColor),
                                              value: _.dates,
                                              onValueChanged: (dates) {
                                                _.dates = dates;
                                                _.setDeliveryDate();
                                              }),
                                        ],
                                      ),
                                    ).paddingOnly(bottom: 20),
                                    CartPayemntDescriptionCard(
                                      subtotal: _.totalPrice.toStringAsFixed(1),
                                      total: _.grandTotal.toStringAsFixed(1),
                                      deliveryCharges: _.deliveryFee.toString(),
                                      discount: _.dis.toString(),
                                    ),

                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 20.0),
                                    //   child: PrimaryButtonWithIcon(
                                    //     btntxt: "Submit",
                                    //     backEndColor: _.finalSubmitData != null
                                    //         ? UIDataColors.primaryColor
                                    //         : UIDataColors.whiteColor,
                                    //     buttontxtColor: _.finalSubmitData != null
                                    //         ? UIDataColors.whiteColor
                                    //         : UIDataColors.primaryColor,
                                    //     iconImageColor: _.finalSubmitData != null
                                    //         ? UIDataColors.whiteColor
                                    //         : UIDataColors.primaryColor,
                                    //     iconImage: UIDATAIcons.sendIcon,
                                    //     onPressed: () {
                                    //       if (_.finalSubmitData != null) {
                                    //         _.orderSubmit();
                                    //       }
                                    //     },
                                    //   ),
                                    // )
                                    SpacingHeight.heightlistspacing50
                                  ],
                                ).paddingSymmetric(horizontal: 15)),
                    ),
                  );
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      //backgroundcolor: UIDataColors.whiteColor,
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
      showActions: false,
      appbarcolor: UIDataColors.whiteColor,
      appbarSvg: true,
      backarrow: UIDataColors.primaryColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      // elevation: 3.0,
    );
  }
}

// class CartScreen extends StatelessWidget {
//   final cartController = Get.put(CartController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cart'),
//       ),
//       body: Obx(
//         () => ListView.builder(
//           itemCount: cartController.cartItems.length,
//           itemBuilder: (context, index) {
//             final cartItem = cartController.cartItems[index];
//             return ListTile(
//               title: Text(cartItem.name),
//               subtitle: Text('\$${cartItem.price.toStringAsFixed(2)}'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     onPressed: () => cartController.removeFromCart(cartItem),
//                     icon: Icon(Icons.remove),
//                   ),
//                   Text(cartItem.quantity.toString()),
//                   IconButton(
//                     onPressed: () => cartController.addToCart(cartItem),
//                     icon: Icon(Icons.add),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: Obx(
//         () => BottomAppBar(
//           child: Container(
//             height: 50,
//             child: Center(
//               child: Text(
//                 'Total: \$${cartController.totalPrice.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
