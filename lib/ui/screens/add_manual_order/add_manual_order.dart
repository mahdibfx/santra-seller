// ignore_for_file: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart';
import 'package:santra_seller/controllers/add_manual_order_controller.dart/add_manual_order_controller.dart';
import 'package:santra_seller/controllers/cart_controller/cart_controller.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
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
import '../../widgets/snackbar/common_snackbar.dart';

class AddManulOrder extends StatefulWidget {
  AddManulOrder({super.key});

  @override
  State<AddManulOrder> createState() => _AddManulOrderState();
}

class _AddManulOrderState extends State<AddManulOrder> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  CartController cartController = Get.put((CartController()));

  Widget bodyData(context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AddManualOrderController>(
      builder: (manualOrderController) {
        return manualOrderController.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : Stack(
                alignment: Alignment.topCenter,
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingWithIcon(
                            icon: UIDATAIcons.addIcon, btntxt: "Add Order"),
                        CommonTextField(
                          isTextHidden: false,
                          prefixIcon: UIDATAIcons.searchIcon,
                          fillcolor: Colors.white,
                          labelText: "Search For a Product",
                          onChanged: (value) {
                            print(value);
                            manualOrderController.filterList(value);
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
                        manualOrderController.hasError
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
                                      itemCount: manualOrderController
                                          .filteredProducts.length,
                                      itemBuilder: (context, index) {
                                        return PDCardAddManualOrder(
                                          manualOrderController:
                                              manualOrderController,
                                          index: index,
                                          onTap: () {
                                            showBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setStatec) {
                                                    return Container(
                                                      // height: size.height -
                                                      //     size.height * 0.27,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      width: double.infinity,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            productImageOnSheet(
                                                                size,
                                                                manualOrderController,
                                                                index),
                                                            Column(
                                                              children: [
                                                                ProductNameAndPriceOnSheet(
                                                                  productName: manualOrderController
                                                                      .allProducts?[
                                                                          index]
                                                                      .productName,
                                                                  productPrice: manualOrderController
                                                                      .allProducts?[
                                                                          index]
                                                                      .productPrice,
                                                                ),
                                                                SpacingHeight
                                                                    .heightlistspacing10,
                                                                // PriceOnSelection(
                                                                //     onMinus: () {
                                                                //   print("Minus");
                                                                // }, onPlus: () {
                                                                //   print("Plus");
                                                                // }),
                                                                // SpacingHeight
                                                                //     .heightlistspacing10,
                                                                // if (manualOrderController
                                                                //     .allProducts![
                                                                //         index]
                                                                //     .modifiers!
                                                                //     .isNotEmpty)
                                                                //   Text(
                                                                //     manualOrderController
                                                                //         .allProducts![
                                                                //             index]
                                                                //         .modifiers!
                                                                //         .length
                                                                //         .toString(),
                                                                //     textScaleFactor:
                                                                //         5,
                                                                //   ),
                                                                manualOrderController
                                                                        .allProducts![
                                                                            index]
                                                                        .modifiers!
                                                                        .isNotEmpty
                                                                    ? ListView
                                                                        .builder(
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: manualOrderController
                                                                            .allProducts![index]
                                                                            .modifiers!
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index2) {
                                                                          return
                                                                              //manualOrderController.allProducts![index].modifiers![index2].selectionType.toString().toLowerCase() == "checkbox"
                                                                              // ?
                                                                              ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: manualOrderController.allProducts![index].modifiers![index2].subModifiers!.length,
                                                                                  itemBuilder: (context, sebIndex) {
                                                                                    var newData = manualOrderController.allProducts![index].modifiers![index2].subModifiers!;
                                                                                    return Padding(
                                                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          manualOrderController.allProducts![index].modifiers![index2].selectionType.toString().toLowerCase() != "checkbox"
                                                                                              ? GestureDetector(
                                                                                                  onTap: () {
                                                                                                    for (var e in newData) {
                                                                                                      if (e.byDefault.toString() == '1') {
                                                                                                        setStatec(() {
                                                                                                          e.byDefault = '0';
                                                                                                        });
                                                                                                      }
                                                                                                    }
                                                                                                    setStatec(() {
                                                                                                      if (newData[sebIndex].byDefault.toString() == '1') {
                                                                                                        newData[sebIndex].byDefault = '0';
                                                                                                      } else {
                                                                                                        newData[sebIndex].byDefault = '1';
                                                                                                      }
                                                                                                    });
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    width: 28,
                                                                                                    height: 28,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: newData[sebIndex].byDefault.toString() == "1" ? Colors.black : Colors.white, // border color
                                                                                                      shape: BoxShape.circle,
                                                                                                    ),
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(2), // border width
                                                                                                      child: Container(
                                                                                                        // or ClipRRect if you need to clip the content
                                                                                                        decoration: BoxDecoration(
                                                                                                          shape: BoxShape.circle,
                                                                                                          color: Colors.amber, // inner circle color
                                                                                                          border: Border.all(
                                                                                                              width: 2, //                   <--- border width here5
                                                                                                              color: Colors.white),
                                                                                                        ),
                                                                                                        child: Container(), // inner content
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                )
                                                                                              : Checkbox(
                                                                                                  value: newData[sebIndex].byDefault.toString() == "1" ? true : false,
                                                                                                  onChanged: (value) {
                                                                                                    var minVals = manualOrderController.allProducts![index].modifiers![index2].limitModifiers.toString().split(",").first;
                                                                                                    var maxVals = manualOrderController.allProducts![index].modifiers![index2].limitModifiers.toString().split(",").last;
                                                                                                    var byDefList = [];
                                                                                                    for (var e in newData) {
                                                                                                      if (e.byDefault.toString() == "1") {
                                                                                                        byDefList.add("bedfltt");
                                                                                                      }
                                                                                                    }

                                                                                                    if (byDefList.length >= int.parse(maxVals) && newData[sebIndex].byDefault.toString() == "0") {
                                                                                                      CommonSnackbar.getSnackbar("Error", "Your selection limit is $maxVals", UIDataColors.redColor);
                                                                                                    } else {
                                                                                                      if (value!) {
                                                                                                        setStatec(() {
                                                                                                          newData[sebIndex].byDefault = "1";
                                                                                                        });
                                                                                                        print(newData[sebIndex].byDefault.toString());
                                                                                                      } else {
                                                                                                        setStatec(() {
                                                                                                          newData[sebIndex].byDefault = "0";
                                                                                                        });
                                                                                                        print(newData[sebIndex].byDefault.toString());
                                                                                                      }
                                                                                                    }

                                                                                                    manualOrderController.update();
                                                                                                    // manualOrderController.changeStatus(newData[sebIndex].byDefault.toString(),value!);
                                                                                                  },
                                                                                                ),
                                                                                          Text(newData[sebIndex].nameModifier.toString()),
                                                                                          Text("${newData[sebIndex].priceModifier}AED"),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  });
                                                                          // : SizedBox();
                                                                        },
                                                                      )
                                                                    : SizedBox(),

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
                                                                  onPressed:
                                                                      () {
                                                                    for (var e in manualOrderController
                                                                        .allProducts![
                                                                            index]
                                                                        .modifiers!) {
                                                                      var minLimits = e
                                                                          .limitModifiers
                                                                          .toString()
                                                                          .split(
                                                                              ",")
                                                                          .first;
                                                                      var listnew =
                                                                          [];
                                                                      for (var s
                                                                          in e.subModifiers!) {
                                                                        if (s.byDefault.toString() ==
                                                                            '1') {
                                                                          listnew
                                                                              .add('byDefault');
                                                                        }
                                                                      }
                                                                      if (listnew
                                                                              .length <
                                                                          int.parse(
                                                                              minLimits)) {
                                                                        return CommonSnackbar.getSnackbar(
                                                                            "Error",
                                                                            "Your minimum limit is $minLimits",
                                                                            UIDataColors.redColor);
                                                                      }
                                                                    }

                                                                  
                                                                    var itemValue =
                                                                        manualOrderController
                                                                            .allProducts![index];

                                                                    var data = CartItem(
                                                                        imageString: itemValue
                                                                            .productImages
                                                                            .toString(),
                                                                        name: itemValue
                                                                            .productName
                                                                            .toString(),
                                                                        price: double.parse(itemValue
                                                                            .productPrice
                                                                            .toString()),
                                                                        code: itemValue
                                                                            .productCode
                                                                            .toString(),
                                                                            subModifiers: []);
                                                                    manualOrderController
                                                                        .addIntoCart(
                                                                            data);
                                                                              Get.back();

                                                                    // Get.offAllNamed(
                                                                    //     Routes
                                                                    //         .cartroute);
                                                                  },
                                                                  btntxt:
                                                                      "Add To Cart",
                                                                  iconImage:
                                                                      UIDATAIcons
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
                                                });
                                          },
                                        );
                                      }),
                                  const SizedBox(
                                    height: 80,
                                  )
                                ],
                              ),
                      ],
                    ).paddingOnly(left: 15, right: 15)),
                  ),
                  cartController.isShowCartButton ||
                          manualOrderController.isShowViewButton
                      ? Positioned(
                          bottom: 30,
                          child: Center(
                            child: BorderButton(
                              onPressed: () {
                                Get.toNamed(Routes.cartroute);
                              },
                              btntxt: "View Cart",
                              iconImage: UIDATAIcons.cartHallowIcon,
                              buttontxtColor: UIDataColors.primaryColor,
                              width: size.width - 30,
                              backEndColor: Colors.white,
                              borderColor: UIDataColors.primaryColor,
                              iconColor: UIDataColors.primaryColor,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              );
      },
    );
  }

  Stack productImageOnSheet(
      Size size, AddManualOrderController manualOrderController, int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: size.height * 0.33,
          width: double.infinity,
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl:
                    "https://api.santra.ae/${manualOrderController.allProducts?[index].productImages}",
                fit: BoxFit.cover,
                memCacheHeight: 300,
                memCacheWidth: 400,
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(),
                ),
              )),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
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
      appBarAction: [
        IconButton(
          icon: const Icon(Icons.sports_basketball),
          onPressed: () {
            Get.toNamed(Routes.cartroute);
          },
        )
      ],
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appbarSvg: true,
      backarrow: UIDataColors.primaryColor,
      qrCallback: () {
        // Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
