import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/price_on_selection.dart';
import 'package:santra_seller/utils/uidata.dart';
import '../../../provider/cart_provider.dart';
import '../../../utils/uidata/textStyles.dart';

class CartCardOrder extends StatelessWidget {
  List<CartItem>? allProducts;
  int? index;
  final void Function()? onDecrese;
  final void Function()? onIncrese;
  String quantity;
  CartCardOrder(
      {Key? key,
      required this.onDecrese,
      required this.onIncrese,
      required this.quantity,
      this.allProducts,
      this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Row(
                children: [
                  SizedBox(
                    height: 65,
                    width: 65,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://api.santra.ae/${allProducts?[index!].imageString}",
                        fit: BoxFit.cover,
                        memCacheHeight: 300,
                        memCacheWidth: 400,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                  SpacingWidth.widthlistspacing15,
                  Expanded(
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              allProducts?[index!].name ?? "",
                              style: UIDataTextStyles.textMedium
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                          Text(
                            "AED ${allProducts?[index!].price ?? ""}",
                            style: UIDataTextStyles.textMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: PriceOnSelection(
                        onMinus: onDecrese,
                        onPlus: onIncrese,
                        quantity: quantity,
                      ),
                    ).paddingOnly(right: 12),
                  )
                ],
              ),
            ),
            if (allProducts![index!].subModifiers.isNotEmpty)
              const Divider(
                height: 30,
              ),
            SingleChildScrollView(
                padding: const EdgeInsets.all(0),
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      allProducts![index!].subModifiers.length,
                      (subInex) => Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: UIDataColors.primaryColor,
                                      width: 0.5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    allProducts![index!]
                                        .subModifiers[subInex]
                                        .nameModifier
                                        .toString(),
                                    style: UIDataTextStyles.title
                                        .copyWith(fontSize: 14),
                                  ),
                                  allProducts![index!]
                                              .subModifiers[subInex]
                                              .priceModifier !=
                                          "0"
                                      ? RichText(
                                          text: TextSpan(
                                            text: "(",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text: "AED ",
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                  )),
                                              TextSpan(
                                                  text:
                                                      "${allProducts![index!].subModifiers[subInex].priceModifier}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  )),
                                              const TextSpan(
                                                  text: ")",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  )),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ).paddingSymmetric(horizontal: 8, vertical: 2))
                          .paddingOnly(right: 10),
                    )).paddingOnly()),
          ],
        ).paddingOnly(left: 15, top: 15, bottom: 15, right: 3));
  }
}
