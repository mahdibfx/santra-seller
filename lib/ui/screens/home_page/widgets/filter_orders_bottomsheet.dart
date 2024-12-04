  import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/ui/widgets/dropdown/common_dropdown.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
final tr = Get.put(AppTranslations());

void filterOrderBottomSheet(context, HomeProvider _) {
    //  GestureDetector(
    //   onTap: () {
    showModalBottomSheet(

        // backgroundColor:
        //     Colors.transparent,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Consumer<HomeProvider>(
            builder: (context, value, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              UIDATAIcons.dollarCircle,
                            ),
                          ),
                          Text(
                            tr.translateData("monthly_total_earning"),
                            style: UIDataTextStyles.title,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(
                              UIDATAIcons.close,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 40,
                        thickness: 0.3,
                        color: UIDataColors.primaryColor,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 10,
                              child: MyDropdown(
                                label: tr.translateData("year"),
                                options: value.years,
                                selectedOption: value.selectedYear,
                                prefixIcon: UIDATAIcons.calendarIcon,
                                onChanged: (newVal) {
                                  value.selectedYear = newVal;
                                },
                              ),
                            ),
                          ),
                          SpacingWidth.widthlistspacing15,
                          Expanded(
                            child: MyDropdown(
                                label: tr.translateData("month"),
                                options: value.months,
                                selectedOption: value.selectedMonth,
                                prefixIcon: UIDATAIcons.calendarIcon,
                                // doSomething: () {
                                //   print("seleed ${_.selectedMonth.value}");
                                //   // _.filterOrder(_.selectedYear.value,
                                //   //     _.selectedMonth.value);
                                // }
                                onChanged: (newValue) {
                                  value.selectedMonth = newValue;

                                  value.filterOrder();
                                }),
                          ),
                        ],
                      ),
                    ],
                  ).paddingOnly(left: 15, right: 15, top: 20),
                  SpacingHeight.heightlistspacing25,
                  Container(
                      color: const Color(0xFFEEEEEE),
                      child: value.isFilterOrderLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      tr.translateData("orders_monthly"),
                                      style: UIDataTextStyles.title.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(value.orderMonthly.toString(),
                                        style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: UIDataColors.primaryColor)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      tr.translateData("sales_monthly"),
                                      style: UIDataTextStyles.title.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(value.profitMonthly.toString(),
                                        style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: UIDataColors.primaryColor)),
                                    SpacingHeight.heightlistspacing20
                                  ],
                                )
                              ],
                            ).paddingSymmetric(vertical: 20, horizontal: 20)),
                ],
              );
            },
          );
        });
    // },
    // child: Column(children: [
    //   SvgPicture.asset(
    //     UIDATAIcons.filterIcon,
    //     color: Colors.white,
    //   ),
    // ]),
    // );
  }