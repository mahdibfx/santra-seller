// ignore_for_file: depend_on_referenced_packages
import 'package:santra_seller/controllers/add_manual_order_controller.dart/add_manual_order_controller.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../widgets/add_manual_order_widgets/any_special_request.dart';
import '../../widgets/add_manual_order_widgets/checkbox_modifier_list.dart';
import '../../widgets/add_manual_order_widgets/rounded_close_button.dart';
import '../../widgets/add_manual_order_widgets/pd_card_add_manual_order.dart';
import '../../widgets/add_manual_order_widgets/price_on_selection.dart';
import '../../widgets/add_manual_order_widgets/product_name_and_price_on_sheet.dart';
import '../../widgets/buttons/add_to_basket_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class AddManulOrder extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  AddManulOrder({super.key});

  Widget bodyData(context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AddManualOrderController>(
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
                      children: const [
                        Icon(
                          Icons.add,
                          size: 40,
                        ),
                        Text(
                          'Add Manual Order',
                          style: UIDataTextStyles.title,
                        ),
                      ],
                    ),
                    CommonTextField(
                      isTextHidden: false,
                      fillcolor: Colors.white,
                      labelText: "Search",
                    ),
                    SpacingHeight.heightlistspacing10,
                    const Text(
                      "Category Name",
                      style: UIDataTextStyles.h1,
                    ),
                    SpacingHeight.heightlistspacing10,
                    ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return PDCardAddManualOrder(
                            onTap: () {
                              showBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: size.height - size.height * 0.3,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                SizedBox(
                                                  height: size.height * 0.3,
                                                  width: double.infinity,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.asset(
                                                      UIDataImage.dummyImage,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
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
                                            Column(
                                              children: [
                                                const ProductNameAndPriceOnSheet(),
                                                SpacingHeight
                                                    .heightlistspacing5,
                                                PriceOnSelection(onMinus: () {
                                                  print("Minus");
                                                }, onPlus: () {
                                                  print("Plus");
                                                }),
                                                ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: 3,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return CheckBoxModifier(
                                                      modName: "Small",
                                                      price: "230",
                                                      isChecked: false,
                                                    );
                                                  },
                                                ),
                                                SpacingHeight
                                                    .heightlistspacing10,
                                                AnySpecialRequests(
                                                    ontap: () {}),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                ),
                                                const AddToBasketButton(),
                                              ],
                                            ).paddingOnly(
                                                left: 12, right: 12, top: 18),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          );
                        }),
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
      bodyData: bodyData(context),
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
