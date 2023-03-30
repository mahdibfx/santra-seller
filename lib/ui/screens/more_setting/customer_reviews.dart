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
        return _.isLoading
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
                              const RatingOverview(),
                              SpacingHeight.heightlistspacing10,
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return RatingBarWithDetails(
                                    barColor: _.barColors[index],
                                    barPercentage: 80,
                                    percenatageToShow: "80",
                                    totalReviews: "783",
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
                          itemCount: 5,
                          itemBuilder: (contex, index) {
                            return CustomerReviewCard(
                              review:
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500",
                              orderNumber: "899",
                              stars: 4,
                              rating: "4",
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
