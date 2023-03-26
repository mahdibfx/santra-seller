import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/price_on_selection.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../models/seller_all_products_model.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class CartCardOrder extends StatelessWidget {
  List<CategoryProduct>? allProducts;
  int? index;
  var onTap;
  CartCardOrder(
      {Key? key, required this.onTap, this.allProducts, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
     decoration: BoxDecoration(
      color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.1,
            blurRadius: 4,
            offset: Offset(0, 0), // changes position of shadow
        ),
    ],
),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                height: 80,
                width: 80,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://api.santra.ae/${allProducts?[index!].productImages}",
                      fit: BoxFit.cover,
                      memCacheHeight: 300,
                      memCacheWidth: 400,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(),
                      ),
                    ))),
            Expanded(
              child: SizedBox(
               
                  child: Container(
              
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allProducts?[index!].productName ??
                              "",
                          style: UIDataTextStyles.textMedium,
                        ),
                        Text(
                          allProducts?[index!].productType ??
                              "",
                          style: UIDataTextStyles.title,
                        ),
                        Text(
                          "AED ${allProducts?[index!].productPrice ?? ""}",
                          style: UIDataTextStyles.textMedium,
                        ),
                      ],
                    ).marginOnly(top: 5, bottom: 5, left: 8, right: 8),
                  )),
            ),

            Container(
                  padding: const EdgeInsets.all(5),
                  height: 50,
                  width: 130,
                  child:    PriceOnSelection(
                                                            onMinus: () {
                                                          print("Minus");
                                                        }, onPlus: () {
                                                          print("Plus");
                                                        }),),
            
          ],
        ).paddingOnly(left: 5, right: 5, top: 5, bottom: 5));
  }
}
