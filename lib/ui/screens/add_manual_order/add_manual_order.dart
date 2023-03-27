// ignore_for_file: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:santra_seller/controllers/add_manual_order_controller.dart/add_manual_order_controller.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/raised_gradient_button.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../../utils/routes/app_routes.dart';
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
      builder: (manualOrderController) {
        return SafeArea(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingWithIcon(icon: UIDATAIcons.addIcon, btntxt: "Add Order"),
              CommonTextField(
                isTextHidden: false,
                prefixIcon: UIDATAIcons.searchIcon,
                fillcolor: Colors.white,
                labelText: "Search For a Product",
              ),
              SpacingHeight.heightlistspacing10,
              manualOrderController.isLoading
                  ? const SizedBox(
                      child: Center(
                      child: CircularProgressIndicator(),
                    ))
                  : manualOrderController.hasError
                      ? const Center(child: Text("No Products To Show"))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Category Name",
                              style: UIDataTextStyles.h1,
                            ).paddingOnly(left: 10),
                            SpacingHeight.heightlistspacing10,
                            ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    manualOrderController.allProducts?.length,
                                itemBuilder: (context, index) {
                                  return PDCardAddManualOrder(
                                    manualOrderController:
                                        manualOrderController,
                                    index: index,
                                    onTap: () {
                                      showBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              // height: size.height -
                                              //     size.height * 0.27,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        SizedBox(
                                                          height: size.height *
                                                              0.33,
                                                          width:
                                                              double.infinity,
                                                          child: ClipRRect(
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          16),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          16)),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://api.santra.ae/${manualOrderController.allProducts?[index].productImages}",
                                                                fit: BoxFit
                                                                    .cover,
                                                                memCacheHeight:
                                                                    300,
                                                                memCacheWidth:
                                                                    400,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              12.0),
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                              )),
                                                        ),
                                                        Positioned(
                                                          left: 12,
                                                          top: 12,
                                                          child:
                                                              RoundedCloseButton(
                                                            onTap: () {
                                                              Get.back();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        ProductNameAndPriceOnSheet(
                                                          productName:
                                                              manualOrderController
                                                                  .allProducts?[
                                                                      index]
                                                                  .productName,
                                                          productPrice:
                                                              manualOrderController
                                                                  .allProducts?[
                                                                      index]
                                                                  .productPrice,
                                                        ),
                                                        SpacingHeight
                                                            .heightlistspacing10,
                                                        PriceOnSelection(
                                                            onMinus: () {
                                                          print("Minus");
                                                        }, onPlus: () {
                                                          print("Plus");
                                                        }),
                                                        // SpacingHeight
                                                        //     .heightlistspacing10,
                                                        if (manualOrderController
                                                            .allProducts![index]
                                                            .modifiers!
                                                            .isNotEmpty)
                                                          ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            padding:
                                                                EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            itemCount: 3,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return CheckBoxModifier(
                                                                modName:
                                                                    "Small",
                                                                price: "230",
                                                                isChecked:
                                                                    false,
                                                              );
                                                            },
                                                          ),
                                                        SpacingHeight
                                                            .heightlistspacing10,
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                        ),
                                                        PrimaryButtonWithIcon(
                                                          onPressed: () {
                                                            manualOrderController
                                                                .addIntoCart(
                                                                    manualOrderController
                                                                            .allProducts![
                                                                        index]);
                                                            Get.offAllNamed(
                                                                Routes
                                                                    .cartroute);
                                                          },
                                                          btntxt: "Add To Cart",
                                                          iconImage: UIDATAIcons
                                                              .cartIcon,
                                                        )
                                                      ],
                                                    ).paddingOnly(
                                                        left: 12,
                                                        right: 12,
                                                        top: 18),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  );
                                }),
                          ],
                        ),
            ],
          ).paddingOnly(left: 15, right: 15)),
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
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'Add Order',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        // Get.offAllNamed(Routes.add);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
