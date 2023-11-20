// ignore_for_file: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';
import 'package:santra_seller/provider/all_orders_manual.dart';
import 'package:santra_seller/provider/firebase_events/firebase_events.dart';
import 'package:santra_seller/provider/splash_provider.dart';
import 'package:santra_seller/ui/screens/cart/cart_screen.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';

import '../../../provider/cart_provider.dart';
import '../../widgets/add_manual_order_widgets/rounded_close_button.dart';
import '../../widgets/add_manual_order_widgets/pd_card_add_manual_order.dart';
import '../../widgets/add_manual_order_widgets/product_name_and_price_on_sheet.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';
import '../../widgets/snackbar/common_snackbar.dart';

class AddManulOrder extends StatefulWidget {
  const AddManulOrder({super.key});

  @override
  State<AddManulOrder> createState() => _AddManulOrderState();
}

class _AddManulOrderState extends State<AddManulOrder> {
  bool showAdd = true;
  // CartController cartController = Get.put((CartController()));

  Widget bodyData(context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AppTranslations>(builder: (tr) {
      return Consumer<AddManualOrderProvider>(
        builder: (context, manualOrderController, child) {
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
                              icon: UIDATAIcons.addIcon,
                              btntxt: tr.translateData("add_order_title")),
                          CommonTextField(
                            isTextHidden: false,
                            prefixIcon: UIDATAIcons.searchIcon,
                            fillcolor: Colors.white,
                            labelText: tr.translateData("add_order_search"),
                            onChanged: (value) {
                              print(value);
                              manualOrderController.filterList(value);
                            },
                          ),
                          SpacingHeight.heightlistspacing10,
                          manualOrderController.hasError
                              ? Center(
                                  child: Text(tr.translateData("no_products")))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                              setState(() {
                                                showAdd = false;
                                              });
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return ProductSheetContent(
                                                      index: index,
                                                    );
                                                  }).then((value) {
                                                setState(() {
                                                  showAdd = true;
                                                });
                                              });
                                            },
                                          );
                                        }),
                                    const SizedBox(
                                      height: 100,
                                    ),
                                  ],
                                ),
                        ],
                      ).paddingOnly(left: 15, right: 15)),
                    ),
                    Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                      return cartProvider.isShowCartButton
                          ? Positioned(
                              bottom: 30,
                              child: Center(
                                child: BorderButton(
                                  onPressed: () {
                                    Get.to(() => const CartScreen());
                                    // Get.toNamed(Routes.cartroute);
                                  },
                                  btntxt:
                                      tr.translateData("add_order_view_cart"),
                                  iconImage: UIDATAIcons.cartHallowIcon,
                                  buttontxtColor: UIDataColors.primaryColor,
                                  width: size.width - 30,
                                  backEndColor: Colors.white,
                                  borderColor: UIDataColors.primaryColor,
                                  iconColor: UIDataColors.primaryColor,
                                ),
                              ),
                            )
                          : const SizedBox();
                    })
                  ],
                );
        },
      );
    });
  }

  hitAllApis() async {
    await Future.microtask(
        () => context.read<AddManualOrderProvider>().onInit());
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddManualOrderProvider>(
        builder: (context, manualOrderController, child) {
      return Consumer<SplashProvider>(builder: (context, splashPro, child) {
        return CommonScaffold(
          bodyData: bodyData(context),
          backgroundcolor: UIDataColors.whiteColor,
          backGroundImage: UIDataImage.backgroundImage,
          isBackArrowShow: false,
          showDrawer: false,
          showFAB: showAdd,
          centerDocked: true,
          showAppBar: true,
          appBarAction: [
            IconButton(
              icon: const Icon(Icons.sports_basketball),
              onPressed: () {
                Get.to(() => const CartScreen());
                // Get.toNamed(Routes.cartroute);
              },
            )
          ],
          isHome: manualOrderController.isLoading,
          isMore: manualOrderController.isLoading,
          showBottomNav: showAdd,
          appbarcolor: UIDataColors.whiteColor,
          appbarSvg: true,
          backarrow: UIDataColors.primaryColor,
          qrCallback: () {
            splashPro.homeAndMoreScreenOff();
            // Get.offAll(() =>  const AddManulOrder());
          },
          floatingIcon: Icons.add,
          elevation: 0.0,
        );
      });
    });
  }
}

class ProductSheetContent extends StatefulWidget {
  final int index;
  const ProductSheetContent({super.key, required this.index});

  @override
  State<ProductSheetContent> createState() => _ProductSheetContentState();
}

class _ProductSheetContentState extends State<ProductSheetContent> {
  FirebaseAnalyticsController firebaseEvents =
      Get.put(FirebaseAnalyticsController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AppTranslations>(builder: (tr) {
      return Consumer<AddManualOrderProvider>(
          builder: (context, manualOrderController, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: StatefulBuilder(builder: (context, setStatec) {
              return Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      productImageOnSheet(
                          size, manualOrderController, widget.index),
                      Column(
                        children: [
                          ProductNameAndPriceOnSheet(
                            product: manualOrderController
                                .filteredProducts[widget.index],
                          ),
                          SpacingHeight.heightlistspacing20,
                          manualOrderController.filteredProducts[widget.index]
                                  .modifiers!.isNotEmpty
                              ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: manualOrderController
                                      .filteredProducts[widget.index]
                                      .modifiers!
                                      .length,
                                  itemBuilder: (context, index2) {
                                    return
                                        //manualOrderController.filteredProducts[index].modifiers![index2].selectionType.toString().toLowerCase() == "checkbox"
                                        // ?
                                        Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Get.locale!.languageCode == 'en'
                                              ? Text(
                                                  "${manualOrderController.filteredProducts[widget.index].modifiers![index2].name.toString()} :",
                                                  style: UIDataTextStyles.title
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: UIDataColors
                                                              .primaryColor),
                                                )
                                              : Text(
                                                  "${manualOrderController.filteredProducts[widget.index].modifiers![index2].nameArabic.toString()} :",
                                                  style: UIDataTextStyles.title
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: UIDataColors
                                                              .primaryColor),
                                                ),
                                          SpacingHeight.heightlistspacing5,
                                          ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: manualOrderController
                                                  .filteredProducts[
                                                      widget.index]
                                                  .modifiers![index2]
                                                  .subModifiers!
                                                  .length,
                                              itemBuilder: (context, sebIndex) {
                                                var newData =
                                                    manualOrderController
                                                        .filteredProducts[
                                                            widget.index]
                                                        .modifiers![index2]
                                                        .subModifiers!;
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Get.locale!.languageCode ==
                                                                'en'
                                                            ? Text(
                                                                newData[sebIndex]
                                                                    .nameModifier
                                                                    .toString(),
                                                                style: UIDataTextStyles
                                                                    .title
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600))
                                                            : Text(
                                                                newData[sebIndex]
                                                                    .nameModifierArabic
                                                                    .toString(),
                                                                style: UIDataTextStyles
                                                                    .title
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w600)),
                                                        Text(
                                                          " (+AED ${newData[sebIndex].priceModifier})",
                                                          style: UIDataTextStyles
                                                              .title
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        const Spacer(),
                                                        SizedBox(
                                                          width: 30,
                                                          child:
                                                              Transform.scale(
                                                            scale: 1.15,
                                                            child: Checkbox(
                                                              side:
                                                                  const BorderSide(
                                                                width: 0.8,
                                                              ),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              materialTapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                              checkColor:
                                                                  UIDataColors
                                                                      .primaryColor,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith<
                                                                      Color>((Set<
                                                                          MaterialState>
                                                                      states) {
                                                                return UIDataColors
                                                                    .primaryColor;
                                                              }),
                                                              value: newData[sebIndex]
                                                                          .byDefault
                                                                          .toString() ==
                                                                      "1"
                                                                  ? true
                                                                  : false,
                                                              onChanged:
                                                                  (value) {
                                                                var maxVals = manualOrderController
                                                                    .filteredProducts[
                                                                        widget
                                                                            .index]
                                                                    .modifiers![
                                                                        index2]
                                                                    .limitModifiers
                                                                    .toString()
                                                                    .split(",")
                                                                    .last;
                                                                var modsModel = manualOrderController
                                                                    .filteredProducts[
                                                                        widget
                                                                            .index]
                                                                    .modifiers![index2];
                                                                var byDefList =
                                                                    [];
                                                                for (var e
                                                                    in newData) {
                                                                  if (e.byDefault
                                                                          .toString() ==
                                                                      "1") {
                                                                    byDefList.add(
                                                                        "bedfltt");
                                                                  }
                                                                }

                                                                if (maxVals ==
                                                                    '1') {
                                                                  for (var mod
                                                                      in modsModel
                                                                          .subModifiers!) {
                                                                    if (mod.byDefault ==
                                                                        '1') {
                                                                      setStatec(
                                                                          () {
                                                                        mod.byDefault =
                                                                            "0";
                                                                      });
                                                                    }
                                                                  }
                                                                  setStatec(() {
                                                                    newData[sebIndex]
                                                                            .byDefault =
                                                                        "1";
                                                                  });
                                                                } else if (byDefList
                                                                            .length >=
                                                                        int.parse(
                                                                            maxVals) &&
                                                                    newData[sebIndex]
                                                                            .byDefault
                                                                            .toString() ==
                                                                        "0") {
                                                                  CommonSnackbar.getSnackbar(
                                                                      "Error",
                                                                      "Your selection limit is $maxVals",
                                                                      UIDataColors
                                                                          .redColor);
                                                                } else {
                                                                  if (value!) {
                                                                    setStatec(
                                                                        () {
                                                                      newData[sebIndex]
                                                                              .byDefault =
                                                                          "1";
                                                                    });
                                                                    print(newData[
                                                                            sebIndex]
                                                                        .byDefault
                                                                        .toString());
                                                                  } else {
                                                                    setStatec(
                                                                        () {
                                                                      newData[sebIndex]
                                                                              .byDefault =
                                                                          "0";
                                                                    });
                                                                    print(newData[
                                                                            sebIndex]
                                                                        .byDefault
                                                                        .toString());
                                                                  }
                                                                }
                                                                // @todo for updation
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      height: 5,
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ],
                                      ),
                                    );
                                    // : SizedBox();
                                  },
                                )
                              : const SizedBox(),
                          PrimaryButtonWithIcon(
                            onPressed: () async {
                              for (var e in manualOrderController
                                  .filteredProducts[widget.index].modifiers!) {
                                var minLimits = e.limitModifiers
                                    .toString()
                                    .split(",")
                                    .first;
                                var listnew = [];
                                for (var s in e.subModifiers!) {
                                  if (s.byDefault.toString() == '1') {
                                    listnew.add('byDefault');
                                  }
                                }
                                if (listnew.length < int.parse(minLimits)) {
                                  return CommonSnackbar.getSnackbar(
                                      "Error",
                                      "Your minimum limit is $minLimits",
                                      UIDataColors.redColor);
                                }
                              }
                              manualOrderController.clearAddonPro();

                              for (var f in manualOrderController
                                  .filteredProducts[widget.index].modifiers!) {
                                for (var c in f.subModifiers!) {
                                  if (c.byDefault == "1") {
                                    manualOrderController.addOnProducts.add(c);
                                  }
                                }
                              }

                              Get.back();
                              var itemValue = manualOrderController
                                  .filteredProducts[widget.index];
                              await firebaseEvents.firebaseAddToCartEvent(
                                  itemValue.productName ?? "",
                                  double.parse(
                                    manualOrderController
                                        .productPriceWithQuantityAndMods(
                                            manualOrderController
                                                    .filteredProducts[
                                                widget.index]),
                                  ),
                                  itemValue.productQuantity.toString());
                              var data = CartItem(
                                  quantity: itemValue.productQuantity,
                                  imageString:
                                      itemValue.productImages.toString(),
                                  name: itemValue.productName.toString(),
                                  price: double.parse(
                                      itemValue.productPrice.toString()),
                                  code: itemValue.productCode.toString(),
                                  subModifiers:
                                      manualOrderController.addOnProducts);

                              Get.back();
                              final cartProvider = context.read<CartProvider>();
                              cartProvider.addToCart(data);
                              manualOrderController.addIntoCart();
                              manualOrderController.resetDefaultQuanity(
                                  manualOrderController
                                      .filteredProducts[widget.index]);
                              // Get.back();
                            },
                            subBtntxt: 'AED',
                            btntxt: tr.translateData("add_to_cart_button"),
                            moreBtntxt: manualOrderController
                                .productPriceWithQuantityAndMods(
                                    manualOrderController
                                        .filteredProducts[widget.index]),
                            iconImage: UIDATAIcons.cartIcon,
                          ),
                          SpacingHeight.heightlistspacing35
                        ],
                      ).paddingOnly(left: 12, right: 12, top: 18, bottom: 0),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      });
    });
  }

  Stack productImageOnSheet(
      Size size, AddManualOrderProvider manualOrderController, int index) {
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
                    "https://api.santra.ae/${manualOrderController.filteredProducts[index].productImages}",
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
              setState(() {
                // showAdd = true;
              });
              Get.back();
            },
          ),
        ),
      ],
    );
  }
}
