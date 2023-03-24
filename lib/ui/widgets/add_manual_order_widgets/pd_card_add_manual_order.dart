import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:santra_seller/controllers/add_manual_order_controller.dart/add_manual_order_controller.dart';

import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class PDCardAddManualOrder extends StatelessWidget {
  AddManualOrderController? manualOrderController;
  int? index;
  var onTap;
  PDCardAddManualOrder(
      {Key? key, required this.onTap, this.manualOrderController, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
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
                          "https://api.santra.ae/${manualOrderController?.allProducts?[index!].productImages}",
                      fit: BoxFit.cover,
                      memCacheHeight: 300,
                      memCacheWidth: 400,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(),
                      ),
                    ))),
            SizedBox(
                height: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manualOrderController?.allProducts?[index!].productName ??
                          "",
                      style: UIDataTextStyles.h2,
                    ),
                    Text(
                      "AED ${manualOrderController?.allProducts?[index!].productPrice ?? ""}",
                      style: UIDataTextStyles.title,
                    ),
                  ],
                ).marginOnly(top: 5, bottom: 5, left: 8, right: 8)),
            const Spacer(),
            GestureDetector(
              onTap: onTap,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  height: 60,
                  width: 60,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: UIDataColors.primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: Colors.transparent),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: UIDataColors.primaryColor,
                    ),
                  )),
            ),
          ],
        ).paddingOnly(left: 5, right: 5, top: 5, bottom: 5));
  }
}
