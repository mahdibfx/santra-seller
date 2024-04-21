import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:santra_seller/utils/uidata.dart';

class ReusableIconSetting extends StatelessWidget {
  String icon;
  final void Function()? onPressed;
  final String? btntxt;
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
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    SvgPicture.asset(
                      icon,
                      color: iconColor,
                    ),
                    SpacingWidth.widthlistspacing,
                    Text(
                      btntxt!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )
                  ],
                ),
              ),
            )),
        const SizedBox(height: 20)
      ],
    );
  }
}

class HeadingWithIcon extends StatelessWidget {
  String icon;

  final String? btntxt;
  Color? iconColor;
  bool isBold;
  HeadingWithIcon(
      {super.key,
      required this.icon,
      required this.btntxt,
      this.iconColor,
      this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  icon,
                  color: iconColor,
                  height: 24,
                ),
                SpacingWidth.widthlistspacing,
                Text(
                  btntxt!,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonIcon extends StatelessWidget {
  String icon;
  final void Function()? onPressed;

  Color? iconColor;
  ButtonIcon(
      {super.key, required this.icon, required this.onPressed, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [],
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SvgPicture.asset(
                  icon,
                  color: iconColor,
                ),
              ),
            )),
      ],
    );
  }
}
