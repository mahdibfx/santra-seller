import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class RatingOverview extends StatelessWidget {
  String? avgStars;
  String? totalReviews;
  RatingOverview({Key? key, required this.avgStars, required this.totalReviews})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          double.parse(avgStars ?? "0.0").toString(),
          style: UIDataTextStyles.rating,
        ),
        RatingBar(
          initialRating: double.parse(avgStars ?? "0.0"),
          direction: Axis.horizontal,
          ignoreGestures: true,
          itemCount: 5,
          unratedColor: Colors.grey,
          glowColor: Colors.amber,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemSize: 20,
          ratingWidget: RatingWidget(
              full: SvgPicture.asset(UIDATAIcons.starIconFilled,
                  color: Colors.amber),
              half: SvgPicture.asset(UIDATAIcons.starIcon, color: Colors.amber),
              empty: Padding(
                padding: const EdgeInsets.all(2.0),
                child:
                    SvgPicture.asset(UIDATAIcons.starIcon, color: Colors.amber),
              )),
          onRatingUpdate: (rating) {},
        ),
        // Spacer(),
        Text(
          "$totalReviews reviews",
          style: UIDataTextStyles.h2,
        ),
      ],
    );
  }
}
