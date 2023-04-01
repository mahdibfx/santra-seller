import 'package:flutter_svg/svg.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/wallet_controller.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/uidata/textStyles.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/uidata.dart';
import '../../widgets/add_manual_order_widgets/cart_card.dart';
import '../../widgets/add_manual_order_widgets/cart_payment_des.dart';
import '../../widgets/add_manual_order_widgets/pd_card_add_manual_order.dart';
import '../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../widgets/scaffold/common_scaffold.dart';

class CartScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  CartScreen({super.key});

  Widget bodyData() {
    return GetBuilder<CartController>(
      builder: (_) {
        return _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Icon(UIDATAIcons.cartIcon, size: 40, color: UIDataColors.primaryColor),
                        SvgPicture.asset(
                          UIDATAIcons.cartHallowIcon,
                          color: UIDataColors.primaryColor,
                        ),
                        Text(
                          ' Cart',
                          style: UIDataTextStyles.title,
                        ),
                      ],
                    ),
                    SpacingHeight.heightlistspacing20,
                    // SpacingHeight.heightlistspacing10,
                    ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _.cartItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CartCardOrder(
                              allProducts: _.cartItems,
                              index: index,
                              onDecrese: () =>
                                  _.removeFromCart(_.cartItems[index]),
                              onIncrese: () => _.addToCart(_.cartItems[index]),
                              quantity: _.cartItems[index].quantity.toString(),
                            ),
                          );
                        }),

                    CartPayemntDescriptionCard(
                      subtotal: '${_.totalPrice.toStringAsFixed(2)}',
                      total: '${_.grandTotal.toStringAsFixed(2)}',
                      deliveryCharges: _.deliveryCharges.toString(),
                    ),



                  Padding(
                   padding: const EdgeInsets.only(top: 20.0),
                   child: PrimaryButtonWithIcon(
                        btntxt: "Submit",
                        backEndColor: _.finalSubmitData != null ? UIDataColors.primaryColor : UIDataColors.whiteColor,
                        buttontxtColor: _.finalSubmitData != null ? UIDataColors.whiteColor : UIDataColors.primaryColor,
                        iconImageColor: _.finalSubmitData != null ? UIDataColors.whiteColor : UIDataColors.primaryColor,
                        iconImage: UIDATAIcons.sendIcon,
                        onPressed: () {
                          if (_.finalSubmitData != null) {
                          _.orderSubmit();
                        }
                      
                        },
                      ),
                 )



                  ],
                ).marginAll(10)),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.whiteColor,
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
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
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