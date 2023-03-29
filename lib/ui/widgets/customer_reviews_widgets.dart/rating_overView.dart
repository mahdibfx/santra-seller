import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class RatingOverview extends StatelessWidget {
  const RatingOverview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "4.7",
          style: UIDataTextStyles.rating,
        ),
        RatingBar(
          initialRating: 4,
          direction: Axis.horizontal,
          itemCount: 5,
          unratedColor: Colors.grey,
          glowColor: Colors.amber,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemSize: 23,
          ratingWidget: RatingWidget(
              full: SvgPicture.asset(UIDATAIcons.starIconFilled,
                  color: Colors.amber),
              half: SvgPicture.asset(UIDATAIcons.starIcon, color: Colors.amber),
              empty: Padding(
                padding: const EdgeInsets.all(2.0),
                child:
                    SvgPicture.asset(UIDATAIcons.starIcon, color: Colors.amber),
              )),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        // Spacer(),
        const Text(
          "1315 Reviews",
          style: UIDataTextStyles.h2,
        ),
      ],
    );
  }
}
