import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:santra_seller/provider/all_orders_manual.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class PDCardAddManualOrder extends StatelessWidget {
  AddManualOrderProvider? manualOrderController;
  int? index;
  var onTap;
  PDCardAddManualOrder(
      {Key? key, required this.onTap, this.manualOrderController, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    height: 64,
                    width: 64,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl:
                              "${manualOrderController?.filteredProducts[index!].productImages}",
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
                          Get.locale!.languageCode == 'en'
                              ? manualOrderController
                                      ?.filteredProducts[index!].productName ??
                                  ""
                              : manualOrderController?.filteredProducts[index!]
                                      .productNameArabic ??
                                  "",
                          style: UIDataTextStyles.h2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SpacingHeight.heightlistspacing5,
                        Text(
                          "AED ${manualOrderController?.filteredProducts[index!].productPrice ?? ""}",
                          style: UIDataTextStyles.title13Normal,
                        ),
                      ],
                    ).marginOnly(top: 5, bottom: 5, left: 8, right: 8)),
                const Spacer(),
                manualOrderController?.filteredProducts[index!].productStatus ==
                        'approved'
                    ? GestureDetector(
                        onTap: onTap,
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            height: 48,
                            width: 48,
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: UIDataColors.primaryColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(13)),
                                    color: Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    UIDATAIcons.addIcon,
                                  ),
                                ))),
                      )
                    : const SizedBox(),
              ],
            ).paddingOnly(left: 8, right: 8, top: 8, bottom: 8)),
        const SizedBox(
          height: 18,
        )
      ],
    );
  }
}
