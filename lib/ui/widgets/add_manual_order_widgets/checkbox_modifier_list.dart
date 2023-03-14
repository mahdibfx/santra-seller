import 'package:flutter/material.dart';

import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class CheckBoxModifier extends StatelessWidget {
  String? modName;
  String? price;
  bool? isChecked;
  CheckBoxModifier({Key? key, this.modName, this.price, this.isChecked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 30,
          child: Row(
            children: [
              Text(
                modName!,
                style: UIDataTextStyles.heading15Medium,
              ),
              const Spacer(),
              Text(
                "(AED $price )",
                style: UIDataTextStyles.heading15Medium,
              ),
              SpacingWidth.widthlistspacing,
              Theme(
                data: ThemeData(unselectedWidgetColor: UIDataColors.grayColor),
                child: SizedBox(
                  width: 15,
                  child: Checkbox(
                    activeColor: UIDataColors.blackColor,
                    checkColor: UIDataColors.blackColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color:
                            UIDataColors.greenColor, //your desire colour here
                        width: 1.5,
                      ),
                    ),
                    onChanged: (bool? value) {},
                    value: isChecked,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          height: 3,
          color: UIDataColors.blackColor,
        ),
      ],
    );
  }
}
