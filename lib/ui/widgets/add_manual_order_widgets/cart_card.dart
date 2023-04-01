import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/controllers/cart_controller/cart_controller.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/price_on_selection.dart';
import 'package:santra_seller/utils/uidata.dart';
import '../../../models/seller_all_products_model.dart';
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
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.1,
            blurRadius: 4,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: SizedBox(
        height: 65,
        child: Row(
          children: [
            Container(
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
                child: Container(
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          allProducts?[index!].name ?? "",
                          style: UIDataTextStyles.textMedium
                              .copyWith(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "Large",
                        // allProducts?[index!].name ?? "",
                        style: UIDataTextStyles.title.copyWith(fontSize: 12),
                      ),
                      Text(
                        "AED ${allProducts?[index!].price ?? ""}",
                        style: UIDataTextStyles.textMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 130,
              child: PriceOnSelection(
                onMinus: onDecrese,
                onPlus: onIncrese,
                quantity: quantity,
              ),
            ),
          ],
        ),
      ).marginAll(15),
    );
  }
}
