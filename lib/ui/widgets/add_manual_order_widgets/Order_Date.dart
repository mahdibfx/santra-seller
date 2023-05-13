import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../buttons/material_buttons/primaryButtonWithIcon.dart';
import 'DatePicker/date_picker.dart';

class OrderDate extends StatelessWidget {
  final Function(DateTime) dateSelected;
  DateTime? dateSelectedValue;
  OrderDate({Key? key, required this.dateSelected, this.dateSelectedValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text("Choose Delivery Date:",
                  style: UIDataTextStyles.textMedium),
              SizedBox(
                width: 32,
                height: 32,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(5),
                      primary: UIDataColors.lightGrayColor),
                  onPressed: (() => Get.back()),
                  child: SvgPicture.asset(
                    width: 20,
                    height: 20,
                    color: UIDataColors.blackColor,
                    UIDATAIcons.close,
                  ),
                ).paddingOnly(top: 5),
              ),
            ],
          ).paddingOnly(top: 10, left: 10, right: 10),
          // Padding(
          //   padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Icon(
          //         Icons.arrow_back_ios,
          //         color: UIDataColors.primaryColor,
          //       ),
          //       const Icon(
          //         Icons.arrow_forward_ios,
          //         color: UIDataColors.primaryColor,
          //       )
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DatePicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: UIDataColors.primaryColor,
                  selectedTextColor: Colors.white,
                  monthTextStyle: UIDataTextStyles.monthStyle,
                  dayTextStyle: UIDataTextStyles.dayStyle,
                  dateTextStyle: UIDataTextStyles.dateStyle,
                  onDateChange: (date) {
                    dateSelectedValue = date;
                    print(dateSelectedValue);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 20.0, left: 10),
            child: PrimaryButtonWithIcon(
              btntxt: "Save",
              iconImage: UIDATAIcons.saveIcon,
              onPressed: () {
                if (dateSelectedValue != null) {
                  Get.back();
                  dateSelected(dateSelectedValue!);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
