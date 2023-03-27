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
        Row(
          children: [
            Text(
              modName ?? "",
              style: UIDataTextStyles.h2.copyWith(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            // Text(
            //   "(AED $price )",
            //   style: UIDataTextStyles.heading15Medium,
            // ),
            SpacingWidth.widthlistspacing,
            Theme(
              data: ThemeData(
                unselectedWidgetColor: UIDataColors.blackColor,
              ),
              child: SizedBox(
                width: 20,
                child: Transform.scale(
                  scale: 1.15,
                  child: Checkbox(
                    activeColor: UIDataColors.blackColor,
                    checkColor: UIDataColors.blackColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    side: const BorderSide(
                      width: 0.8,
                    ),
                    onChanged: (bool? value) {},
                    value: isChecked,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 0.2,
          height: 3,
          color: UIDataColors.primaryColor,
        ),
      ],
    );
  }
}
