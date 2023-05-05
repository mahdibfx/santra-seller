// ignore_for_file: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/all_orders_manual.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../widgets/add_manual_order_widgets/checkbox_modifier_list.dart';
import '../../widgets/add_manual_order_widgets/rounded_close_button.dart';
import '../../widgets/add_manual_order_widgets/pd_card_add_manual_order.dart';
import '../../widgets/buttons/add_to_basket_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class CustomerScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  CustomerScreen({super.key});

  Widget bodyData() {
    return Consumer<AddManualOrderProvider>(
      builder: (context, _, child) {
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
                      children:  [
                        Icon(
                          Icons.add,
                          size: 40,
                        ),
                        Text(
                          "manual_orders".tr,
                          style: UIDataTextStyles.h1,
                        ),
                      ],
                    ),
                    CommonTextField(
                      isTextHidden: false,
                      fillcolor: Colors.white,
                      labelText: "search".tr,
                    ),
                    SpacingHeight.heightlistspacing10,
                    // const Text(
                    //   "Category Name",
                    //   style: UIDataTextStyles.h1,
                    // ),
                    // SpacingHeight.heightlistspacing10,
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return PDCardAddManualOrder(
                            onTap: () {
                              showBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  builder: (context) {
                                    return SizedBox(
                                      height: MediaQuery.of(context)
                                              .size
                                              .height -
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              // SizedBox(
                                              //   height: 250,
                                              //   width: double.infinity,
                                              //   child: Image.asset(
                                              //     UIDataImage.dummyImage,
                                              //     fit: BoxFit.cover,
                                              //   ),
                                              // ),
                                              Positioned(
                                                left: 12,
                                                top: 12,
                                                child: RoundedCloseButton(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                //const ProductNameAndPriceOnSheet(),
                                                SpacingHeight
                                                    .heightlistspacing5,
                                                // PriceOnSelection(onMinus: () {
                                                //   print("Minus");
                                                // }, onPlus: () {
                                                //   print("Plus");
                                                // }),
                                                ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: 3,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return CheckBoxModifier(
                                                      modName: "small".tr,
                                                      price: "230",
                                                      isChecked: false,
                                                    );
                                                  },
                                                ),
                                                SpacingHeight
                                                    .heightlistspacing10,
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                ),
                                                const AddToBasketButton()
                                              ],
                                            ).paddingOnly(
                                                left: 12, right: 12, top: 18),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          );
                        })
                  ],
                ).marginOnly(left: 10, right: 10)),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      resizeToAvoid: false,
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.whiteColor,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'Add customer',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        // Get.offAllNamed(Routes.add);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
