import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:santra_seller/utils/uidata.dart';

class ReusableIconSetting extends StatelessWidget {
  String icon;
  final void Function()? onPressed;
  final Text? btntxt;
  Color? iconColor;
  ReusableIconSetting(
      {super.key,
      required this.icon,
      required this.onPressed,
      required this.btntxt,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Row(
            // Replace with a Row for horizontal icon + text
            children: <Widget>[
              SvgPicture.asset(
                icon,
                color: iconColor,
              ),
              SpacingWidth.widthlistspacing,
              btntxt!,
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
