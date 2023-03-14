import 'package:santra_seller/controllers/more_screen_controller.dart/wallet_controller.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/uidata/textStyles.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/uidata.dart';
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
                    SpacingHeight.heightlistspacing20,
                    Text(
                      'Cart Screen',
                      style: UIDataTextStyles.h1,
                    ),
                    SpacingHeight.heightlistspacing20,
                    Container(
                      height: 60,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('heee'),
                                Text('heee'),
                                Text('heee'),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Text('+'),
                                      Text('2'),
                                      Text('-'),
                                    ],
                                  ),
                                ),
                                SpacingWidth.widthlistspacing15,
                                Container(
                                  height: 20,
                                  width: 20,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          ),
                        ],
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
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'Cart Screen',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addCustomer);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
