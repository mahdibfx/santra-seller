import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoundedIconButton extends StatelessWidget {
  var onTap;
  String? icon;
  double? iconSize;
  Color? iconColor;
  Color? bgClr;
  double? size;
  RoundedIconButton(
      {super.key,
      required this.onTap,
      this.icon,
      this.iconSize,
      this.bgClr,
      this.size,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: size ?? 28,
          width: size ?? 28,
          decoration: BoxDecoration(
              color: bgClr ?? Colors.black.withOpacity(0.07),
              shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: icon == null
                ? Icon(
                    Icons.favorite,
                    color: iconColor,
                    size: iconSize,
                  )
                : SvgPicture.asset(
                    icon ?? "",
                    height: iconSize ?? 10,
                    color: iconColor,
                  ),
          ),
        ),
      ),
    );
  }
}
