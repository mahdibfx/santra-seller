import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color? bgColor;
  final Color? textColor;
  final String? title;
  final double? fontSize;
  var onTap;
  RoundedButton(
      {super.key,
      required this.bgColor,
      required this.onTap,
      required this.textColor,
      this.fontSize,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title ?? "",
            style: TextStyle(
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
