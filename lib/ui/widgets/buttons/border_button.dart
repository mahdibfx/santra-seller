import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/uidata.dart';

import '../../../utils/app_translation/app_translation.dart';

final tr = Get.put(AppTranslations());

class BorderButton extends StatelessWidget {
  final String? btntxt;
  final String? iconImage;
  final Color? buttontxtColor;

  final double width;
  final double height;
  final Color? backEndColor;
  final Color? borderColor;
  final Color? iconColor;
  final onPressed;

  BorderButton({
    required this.btntxt,
    this.iconImage,
    this.buttontxtColor,
    this.width = double.infinity,
    this.height = 50.0,
    this.backEndColor = UIDataColors.primaryColor,
    this.borderColor,
    this.iconColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        color: backEndColor ?? Colors.white,
        border: Border.all(
          color: borderColor ??
              Colors.transparent, //                   <--- border color
          width: 1.0,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    btntxt ?? "",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: tr.getFont(),
                      fontWeight: FontWeight.bold,
                      color: buttontxtColor ?? Colors.white,
                    ),
                  ),
                  if (iconImage != null) SpacingWidth.widthlistspacing,
                  iconImage != null
                      ? SvgPicture.asset(
                          iconImage!,
                          color: iconColor ?? Colors.white,
                        )
                      : Container()
                ],
              ),
            )),
      ),
    );
  }
}
