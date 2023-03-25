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
                    itemCount:
                        _.allProducts!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CartCardOrder(
                          allProducts:
                              _.allProducts,
                          index: index,
                          onTap: () {
                          
                          },
                        ),
                      );
                    }),

                    CartPayemntDescriptionCard(),


                   
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
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: '',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addCustomer);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
