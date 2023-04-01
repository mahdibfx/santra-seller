import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class CustomerReviewCard extends StatelessWidget {
  final String? orderNumber;
  final String? review;
  final double? stars;
  final String? rating;
  CustomerReviewCard(
      {super.key,
      required this.orderNumber,
      required this.review,
      required this.stars,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Order No. $orderNumber",
                      style: UIDataTextStyles.h2.copyWith(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    RatingBar(
                      initialRating: stars ?? 0,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      unratedColor: Colors.grey,
                      glowColor: Colors.amber,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                      itemSize: 15,
                      ratingWidget: RatingWidget(
                          full: SvgPicture.asset(UIDATAIcons.starIconFilled,
                              color: Colors.amber),
                          half: SvgPicture.asset(UIDATAIcons.starIcon,
                              color: Colors.amber),
                          empty: Padding(
                            padding: const EdgeInsets.all(2.5),
                            child: SvgPicture.asset(UIDATAIcons.starIcon,
                                color: Colors.amber),
                          )),
                      // itemBuilder: (context, _) =>
                      //     SvgPicture.asset(UIDATAIcons.starIcon),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    SpacingWidth.widthlistspacing5,
                    Text(
                      "$rating",
                      style: UIDataTextStyles.h2,
                    ),
                  ],
                ),
                const Divider(
                  color: UIDataColors.primaryColor,
                  thickness: 0.1,
                ),
                Text(
                  review ?? "",
                  style: UIDataTextStyles.title
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ).paddingSymmetric(horizontal: 12, vertical: 12)),
        SpacingHeight.heightlistspacing10
      ],
    );
  }
}
