import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../buttons/material_buttons/primaryButtonWithIcon.dart';

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
                  children: [
                    Text("Choose Delivery Date:", style: UIDataTextStyles.textMedium),
              
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
    shape: CircleBorder(),
    padding: EdgeInsets.all(10),

  ),
                   
                      onPressed: null,
                        child: Icon(Icons.cabin),
                    ),
                  ],
                ).paddingOnly(top: 00, left: 10, right: 10),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DatePicker(
                        DateTime.now(),
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Colors.black,
                        selectedTextColor: Colors.white,
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
