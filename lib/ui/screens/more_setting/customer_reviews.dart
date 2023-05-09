// ignore_for_file: depend_on_referenced_packages

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/more_settings_provider/customer_reviews_provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/widgets/cards/customer_review_card.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/customer_reviews_widgets.dart/rating_overView.dart';
import '../../widgets/customer_reviews_widgets.dart/ratingbar_with_details.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class CustomerReviews extends StatefulWidget {
  const CustomerReviews({super.key});

  @override
  State<CustomerReviews> createState() => _CustomerReviewsState();
}

class _CustomerReviewsState extends State<CustomerReviews> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerReviewsProvider>(context, listen: false)
          .viewCustomerReviews();
    });
  }

  Widget bodyData() {
    return Consumer<AppTranslations>(
          builder: (con, tr, child) {
        return Consumer<CustomerReviewsProvider>(
          builder: (con, _, child) {
            return _.isReviewsLoading
                ? const SizedBox(
                    child: Center(
                    child: CircularProgressIndicator(),
                  ))
                : SafeArea(
                    child: SingleChildScrollView(
                      child: _.hasReviewsError
                          ?  SizedBox(
                              height: 600,
                              child: Center(child: Text(tr.translateData("no_reviews"))))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeadingWithIcon(
                                    icon: UIDATAIcons.starIcon,
                                    btntxt: tr.translateData("customer_reviews_title")),
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        if (_.customerReviews.data != null)
                                          RatingOverview(
                                            avgStars: _.customerReviews.data?[0]
                                                .averageStars
                                                .toString(),
                                            totalReviews: _.customerReviews.data?[0]
                                                .averageStars
                                                .toString(),
                                          ),
                                        SpacingHeight.heightlistspacing10,
                                        if (_.customerReviews.data != null)
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: _.customerReviews.data?[0]
                                                .starsPercent?.length,
                                            itemBuilder: (context, index) {
                                              return RatingBarWithDetails(
                                                barColor: _.barColors[index],
                                                barPercentage: _.customerReviews
                                                    .data?[0].starsPercent?[index]
                                                    .toDouble(),
                                                percenatageToShow: (_
                                                            .customerReviews
                                                            .data![0]
                                                            .starsPercent![index] *
                                                        100)
                                                    .toString(),
                                                totalReviews: _.customerReviews
                                                    .data?[0].stars?[index],
                                                noOfStars:
                                                    _.noOfStars[index].toString(),
                                              );
                                            },
                                          ),
                                      ],
                                    ).paddingSymmetric(
                                        horizontal: 30, vertical: 20)),
                                SpacingHeight.heightlistspacing15,
                                if (_.customerReviews.data != null)
                                  ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _.customerReviews.data?[0]
                                          .customerFeedback?.length,
                                      itemBuilder: (contex, index) {
                                        return CustomerReviewCard(
                                          review: _
                                              .customerReviews
                                              .data?[0]
                                              .customerFeedback?[index]
                                              .feedbackMessage,
                                          orderNumber: _.customerReviews.data?[0]
                                              .customerFeedback?[index].orderNumber,
                                          stars: _
                                              .customerReviews
                                              .data?[0]
                                              .customerFeedback?[index]
                                              .feedbackStarsInDouble,
                                          rating: _
                                              .customerReviews
                                              .data?[0]
                                              .customerFeedback?[index]
                                              .feedbackStars,
                                        );
                                      }),
                                SpacingHeight.heightlistspacing50
                              ],
                            ).paddingSymmetric(horizontal: 20),
                    ),
                  );
          },
        );
      }
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
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
