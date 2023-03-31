// ignore_for_file: depend_on_referenced_packages

import 'package:santra_seller/controllers/more_screen_controller.dart/customer_reviews_controller.dart';
import 'package:santra_seller/ui/widgets/cards/customer_review_card.dart';

import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/customer_reviews_widgets.dart/rating_overView.dart';
import '../../widgets/customer_reviews_widgets.dart/ratingbar_with_details.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class CustomerReviews extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  CustomerReviews({super.key});

  Widget bodyData() {
    return GetBuilder<CustomerReviewsController>(
      builder: (_) {
        return _.isReviewsLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingWithIcon(
                          icon: UIDATAIcons.starIcon,
                          btntxt: "Customer Reviews"),
                      SpacingHeight.heightlistspacing10,
                      Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              RatingOverview(
                                avgStars: _
                                    .customerReviews.data![0].averageStars
                                    .toString(),
                                totalReviews: _
                                    .customerReviews.data![0].averageStars
                                    .toString(),
                              ),
                              SpacingHeight.heightlistspacing10,
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return RatingBarWithDetails(
                                    barColor: _.barColors[index],
                                    barPercentage: _.customerReviews.data?[0]
                                        .starsPercent?[index]
                                        .toDouble(),
                                    // _.customerReviews.data[0]
                                    //     .starsPercent[index]

                                    percenatageToShow: (_.customerReviews
                                                .data![0].starsPercent![index] *
                                            100)
                                        .toString(),
                                    totalReviews: _
                                        .customerReviews.data?[0].stars?[index],
                                    noOfStars: _.noOfStars[index].toString(),
                                  );
                                },
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 30, vertical: 20)),
                      SpacingHeight.heightlistspacing15,
                      ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _.customerReviews.data?[0].customerFeedback
                              ?.length,
                          itemBuilder: (contex, index) {
                            return CustomerReviewCard(
                              review: _.customerReviews.data?[0]
                                  .customerFeedback?[index].feedbackMessage,
                              orderNumber: _.customerReviews.data?[0]
                                  .customerFeedback?[index].orderNumber,
                              stars: 4,
                              rating: _.customerReviews.data?[0]
                                  .customerFeedback?[index].feedbackStars,
                            );
                          })
                    ],
                  ).paddingSymmetric(horizontal: 20),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: '',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.signuproutes);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
