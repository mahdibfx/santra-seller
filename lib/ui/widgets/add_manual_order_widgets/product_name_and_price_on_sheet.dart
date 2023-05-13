import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/price_on_selection.dart';

import '../../../models/seller_all_products_model.dart';
import '../../../provider/all_orders_manual.dart';
import '../../../utils/uidata/textStyles.dart';

class ProductNameAndPriceOnSheet extends StatelessWidget {
  // String? productName;
  // String? productPrice;
  Product? product;
  ProductNameAndPriceOnSheet(
      {Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddManualOrderProvider>(
      builder: (context, _, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    // width: 250,
                    child: Text(Get.locale!.languageCode == 'en' ?
                      product!.productName ?? "" :product!.productNameArabic ??"",
                      style:
                          UIDataTextStyles.h2.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "${product!.productPrice ?? ""} AED",
                    style: UIDataTextStyles.h1Heavy,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                  height: 50,
                  // width: 100,
                  child: PriceOnSelection(
                      onMinus: () {
                        _.decreaseDefaultQuanity(product!);
                      }, onPlus: () {
                        _.increaseDefaultQuanity(product!);
                      }, quantity: product!.productQuantity.toString())),
            )
          ],
        );
      }
    );
  }
}
