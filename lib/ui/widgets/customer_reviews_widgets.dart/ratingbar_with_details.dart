import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:santra_seller/utils/uidata.dart';

import '../../../utils/uidata/textStyles.dart';

class RatingBarWithDetails extends StatelessWidget {
  String? noOfStars;
  double? barPercentage;
  String? totalReviews;
  String? percenatageToShow;
  Color? barColor;
  RatingBarWithDetails(
      {Key? key,
      required this.barColor,
      required this.noOfStars,
      required this.barPercentage,
      required this.totalReviews,
      required this.percenatageToShow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          noOfStars ?? "",
          style: UIDataTextStyles.h2,
        ),
        SpacingWidth.widthlistspacing5,
        Expanded(
          flex: 7,
          child: LinearPercentIndicator(
            barRadius: const Radius.circular(5),
            // width: 200.0,
            lineHeight: 14.0,
            percent: 0.9,
            backgroundColor: Colors.grey.withOpacity(0.5),
            progressColor: barColor,
          ),
        ),
        Text(
          "$percenatageToShow%",
          style: UIDataTextStyles.h2,
        ),
        const Spacer(),
        Text(
          totalReviews ?? "",
          style: UIDataTextStyles.h2,
        ),
      ],
    ).paddingSymmetric(vertical: 2.5);
  }
}
