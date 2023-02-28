import 'package:flutter/material.dart';

class ReusableIconButton extends StatelessWidget {
  final Icon? icon;
  final onPressed;
  final Text? btntxt;
  const ReusableIconButton({required this.icon, required this.onPressed , this.btntxt});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Column( // Replace with a Row for horizontal icon + text
        children: <Widget>[
          icon!,
          btntxt??SizedBox(),
        ],
      ),
    );
  }
}



