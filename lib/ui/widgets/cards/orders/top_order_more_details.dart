import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:santra_seller/helpers/date_formater.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';

Container topOrderMoreDetails(AppTranslations tr,dynamic widget) {
    return Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  UIDATAIcons.orderTime,
                                  color: UIDataColors.primaryColor,
                                ),
                                SpacingWidth.widthlistspacing,
                                Text(DateFormater.formatOrderDate(widget.orderTime)),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  UIDATAIcons.deliveryIcon,
                                  color: UIDataColors.primaryColor,
                                ),
                                SpacingWidth.widthlistspacing,
                                widget.deliveryTime.toString().isEmpty
                                    ? const Text('---')
                                    : Text(widget.deliveryTime),
                              ],
                            ),
                          ],
                        ).marginOnly(left: 10, right: 10, top: 10, bottom: 5),
                        Row(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  height: 16,
                                  UIDATAIcons.userIcon,
                                  color: UIDataColors.primaryColor,
                                ),
                                SpacingWidth.widthlistspacing,
                                Text(widget.customerName),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  UIDATAIcons.paymentMethod,
                                  color: UIDataColors.primaryColor,
                                ),
                                SpacingWidth.widthlistspacing,
                                Text(widget.paymentMethod),
                              ],
                            ),
                          ],
                        ).marginOnly(left: 10, right: 10, top: 5, bottom: 5),
                        !widget.orderType.contains("Delivery")
                            ? Row(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        height: 16,
                                        UIDATAIcons.callIcon,
                                        color: UIDataColors.primaryColor,
                                      ),
                                      SpacingWidth.widthlistspacing,
                                      Text(widget.customerPhone),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        height: 16,
                                        UIDATAIcons.orderBascketBorder,
                                        color: UIDataColors.primaryColor,
                                      ),
                                      SpacingWidth.widthlistspacing,
                                      Text(widget.orderType.toLowerCase() ==
                                              "express"
                                          ? tr.translateData("express")
                                          : widget.orderType.toLowerCase() ==
                                                  "pickup"
                                              ? tr.translateData("pickup")
                                              : widget.orderType
                                                          .toLowerCase() ==
                                                      "delivery"
                                                  ? tr.translateData(
                                                      "delivery")
                                                  : widget.orderType
                                                              .toLowerCase() ==
                                                          "vip"
                                                      ? tr.translateData(
                                                          "vip")
                                                      : ""),
                                    ],
                                  ),
                                ],
                              ).marginOnly(
                                left: 10, right: 10, top: 5, bottom: 10)
                            : Container().marginOnly(bottom: 5),
                      ],
                    ),
                  );

  }
   