import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/routes/app_routes.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';

import '../../../utils/uidata.dart';
import '../buttons/icon_button.dart';

class MyCustomerCard extends StatelessWidget {
  final String name;
  final String number;
  final dynamic onTap;

  const MyCustomerCard(
      {super.key,
      required this.name,
      required this.number,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      // height: 80,
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        UIDATAIcons.userIcon,
                        height: 20,
                        color: UIDataColors.primaryColor,
                      ),
                      SpacingWidth.widthlistspacing,
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.56,
                        child: Text(
                          name,
                          style: UIDataTextStyles.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.65,
                        height: 0.25,
                        color: UIDataColors.primaryColor,
                      ),
                      SizedBox(
                        width: size.width * 0.11,
                      ),

                      InkWell(
                        onTap: onTap,
                        child: SvgPicture.asset(
                          UIDATAIcons.editCustomer,
                          color: UIDataColors.primaryColor,
                          height: 22,
                          //height: 20,
                        ),
                      ),
                      // ReusableIconButton(
                      //   icon: UIDATAIcons.editCustomer,
                      //   onPressed: onTap,
                      // )
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        UIDATAIcons.callIcon,
                        height: 20,
                        color: UIDataColors.primaryColor,
                      ),
                      SpacingWidth.widthlistspacing,
                      Text(
                        number,
                        style: UIDataTextStyles.title,
                      ),
                    ],
                  ),
                ],
              ).paddingSymmetric(
                  horizontal: size.width * 0.045, vertical: size.height * 0.02)
            ],
          )
        ],
      ),
    );
  }
}
