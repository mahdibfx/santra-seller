import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import '../../../provider/product_setting_provider.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class ProductEditCard extends StatefulWidget {
  ProductSettingsProvider productSettingsController;
  int? index;
  final String title;

  bool? currentStatus;
  ProductEditCard(
      {super.key,
      required this.productSettingsController,
      required this.index,
      required this.title,
      this.currentStatus});

  @override
  State<ProductEditCard> createState() => _ProductEditCardState();
}

class _ProductEditCardState extends State<ProductEditCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
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
                              "https://api.santra.ae/${widget.productSettingsController.allProducts?[widget.index!].productImages}",
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
                          widget.productSettingsController
                                  .allProducts?[widget.index!].productName ??
                              "",
                          style: UIDataTextStyles.h2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SpacingHeight.heightlistspacing5,
                        Text(
                          "AED ${widget.productSettingsController.allProducts?[widget.index!].productPrice ?? ""}",
                          style: UIDataTextStyles.title13Normal,
                        ),
                      ],
                    ).marginOnly(left: 8)),
              ],
            ),
            const Divider(
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Out Of Stock",
                  style: UIDataTextStyles.caption,
                ),
                SpacingWidth.widthlistspacing,
                FlutterSwitch(
                  activeColor: UIDataColors.primaryColor,
                  width: size.width * 0.11,
                  toggleColor: UIDataColors.whiteColor,
                  padding: 2,
                  height: size.height * 0.03,
                  value: widget.productSettingsController
                              .allProducts?[widget.index!].productStatus ==
                          "approved"
                      ? true
                      : false,
                  onToggle: (val) {
                    setState(() {
                      widget.currentStatus = val;
                      widget.productSettingsController
                          .toggleStatus(widget.index);
                      widget.productSettingsController
                          .changeProductAvailability(
                              widget.productSettingsController
                                  .allProducts?[widget.index!].productCode,
                              widget.currentStatus == true
                                  ? "enable"
                                  : "out_of_stock");
                    });
                  },
                ),
                SpacingWidth.widthlistspacing,
                const Text(
                  "Available",
                  style: UIDataTextStyles.caption,
                ),
              ],
            ),
          ],
        ).paddingAll(10));
  }
}
