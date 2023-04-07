import 'package:flutter/material.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/price_on_selection.dart';

import '../../../utils/uidata/textStyles.dart';

class ProductNameAndPriceOnSheet extends StatelessWidget {
  String? productName;
  String? productPrice;
  ProductNameAndPriceOnSheet(
      {Key? key, required this.productName, required this.productPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  productName ?? "",
                  style:
                      UIDataTextStyles.h2.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "${productPrice ?? ""} AED",
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
                  onMinus: () {}, onPlus: () {}, quantity: "1")),
        )
      ],
    );
  }
}
