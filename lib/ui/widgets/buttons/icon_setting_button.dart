import 'package:flutter/material.dart';
import 'package:santra_seller/utils/uidata.dart';

class ReusableIconSetting extends StatelessWidget {
  final Icon? icon;
  final void Function()? onPressed;
  final Text? btntxt;
  const ReusableIconSetting({super.key, required this.icon, required this.onPressed , required this.btntxt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Row( // Replace with a Row for horizontal icon + text
            children: <Widget>[
              icon!,
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



