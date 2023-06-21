import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/uidata.dart';

import '../../../../utils/app_translation/app_translation.dart';
final tr = Get.put(AppTranslations());
class PrimaryButtonWithIcon extends StatelessWidget {
  final String? btntxt;
  final String? subBtntxt;
  final String? moreBtntxt;
  final String? iconImage;
  final Color? buttontxtColor;
  final Gradient? gradient;
  final double width;
  final double height;
  final Color? backEndColor;
   final Color? iconImageColor;
  final onPressed;

  PrimaryButtonWithIcon({
    required this.btntxt,
    this.subBtntxt,
    this.moreBtntxt,
    this.iconImage,
    this.buttontxtColor = Colors.white,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.backEndColor = UIDataColors.primaryColor,
    this.iconImageColor = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        color: backEndColor,
        // gradient: LinearGradient(
        //   colors: <Color>[
        //     UIDataColors.primaryColor,
        //     UIDataColors.primaryColor.withOpacity(0.9),
        //     UIDataColors.primaryColor,
        //   ],
        // ),
        border: Border.all(
          color:
              UIDataColors.primaryColor, //                   <--- border color
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
                      fontSize: 16.0,
                      fontFamily: tr.getFont(),
                      fontWeight: FontWeight.bold,
                      color: buttontxtColor,
                    ),
                  ),
                  subBtntxt == null? SizedBox(): Text(subBtntxt!,style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: tr.getFont(),
                      fontWeight: FontWeight.normal,
                      color: buttontxtColor,
                    ),).marginOnly(left: 10),
                    moreBtntxt == null? SizedBox(): Text(moreBtntxt!,style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: tr.getFont(),
                      fontWeight: FontWeight.bold,
                      color: buttontxtColor,
                    ),),
                 iconImage != null ? SpacingWidth.widthlistspacing : Container(),
                  iconImage != null
                      ? SvgPicture.asset(
                          iconImage!,
                          color: iconImageColor,
                        )
                      : Container()
                ],
              ),
            )),
      ),
    );
  }
}
