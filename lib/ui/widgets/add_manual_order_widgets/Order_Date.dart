
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

  OrderDate({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
      
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Choose Delivery Date:", style: UIDataTextStyles.textMedium),
              
                    SizedBox(
                          width:32,
                          height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                      
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5),
                            primary: UIDataColors.lightGrayColor
                          ),
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
                            // New date selected
                            // setState(() {
                            //   _selectedValue = date;
                            // });
                          },
                        ),
                      
                    ],
              ),
                ),

                 Padding(
                   padding: const EdgeInsets.only(right: 10,bottom: 20.0, left: 10),
                   child: PrimaryButtonWithIcon(
                        btntxt: "Save",
                        iconImage: UIDATAIcons.saveIcon,
                        onPressed: () {},
                      ),
                 )
              ],
            ),
          );
  }
}
