import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:santra_seller/controllers/add_manual_order_controller.dart/add_manual_order_controller.dart';

import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class ProductEditCard extends StatelessWidget {
  AddManualOrderController manualOrderController;
  int? index;
  final String title;
  final bool? outOfStock;
  final void Function(bool)? onChanged;
  ProductEditCard(
      {super.key,
      required this.manualOrderController,
      required this.index,
      required this.title,
      this.outOfStock,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  height: 64,
                  width: 64,
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
                  // height: size ,
                  width: size.width * 0.55,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        manualOrderController
                                .allProducts?[index!].productName ??
                            "",
                        style: UIDataTextStyles.h2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SpacingHeight.heightlistspacing5,
                      Text(
                        "AED ${manualOrderController.allProducts?[index!].productPrice ?? ""}",
                        style: UIDataTextStyles.title13Normal,
                      ),
                    ],
                  ).marginOnly(top: 5, bottom: 5, left: 8, right: 8)),
            ],
          ),
          ListTile(
            title: Text(title),
            trailing: FlutterSwitch(
              activeColor: UIDataColors.primaryColor,
              width: size.width * 0.13,
              toggleColor: UIDataColors.whiteColor,
              padding: 0,
              height: size.height * 0.03,
              value: true,
              // notificationValue
              //     .pushMessagesFromCustomers,
              onToggle: (val) {
                // notificationValue
                //     .pushMessagesFromCustomers = val;
                // notificationValue.customerMessages();
              },
            ),

            //Switch(value: outOfStock!, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
