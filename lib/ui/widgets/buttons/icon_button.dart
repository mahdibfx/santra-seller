import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReusableIconButton extends StatelessWidget {
  final String? icon;
  final onPressed;
  Color? iconClr;
  final Text? btntxt;
  ReusableIconButton(
      {required this.icon, required this.onPressed, this.iconClr, this.btntxt});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        // Replace with a Row for horizontal icon + text
        children: <Widget>[
          SvgPicture.asset(
            icon!,
            color: iconClr,
            height: 22,
            //height: 20,
          ),
          btntxt ?? SizedBox(),
        ],
      ),
    );
  }
}
