import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:santra_seller/ui/widgets/cards/home_card.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';

Column skeletonizedHomeBody(BuildContext context) {
  return Column(
    children: [
      SpacingHeight.heightlistspacing10,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xff1E1E50),
                    Color(0xff0098B1),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        UIDATAIcons.walletIcon,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Orders',
                        style: UIDataTextStyles.h2.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '0', // Static data
                        style: UIDataTextStyles.counth1.copyWith(
                          color: Colors.white,
                        ),
                      ).paddingOnly(bottom: 0),
                    ],
                  ),
                  Center(
                    child: Container(
                      height: 65,
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // No-op for skeleton
                        },
                        child: Text(
                          'Monthly Sales',
                          style: UIDataTextStyles.h2.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '0', // Static data
                        textAlign: TextAlign.start,
                        style: UIDataTextStyles.counth1.copyWith(
                          color: Colors.white,
                        ),
                      ).paddingOnly(bottom: 0, left: 0),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // No-op for skeleton
                    },
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          UIDATAIcons.filterIcon,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingAll(15),
            ),
          ),
        ],
      ),
      SpacingHeight.heightlistspacing20,
      Row(
        children: [
          HomeCardWidget(
            santraNewCount: '0', // Static data
            isSantraCard: true,
            onTap: () {}, // No-op for skeleton
            heading: 'Santra Orders',
            count: '0', // Static data
            imageAsset: UIDataImage.santraOrderSVG,
          ),
          SpacingWidth.widthlistspacing20,
          HomeCardWidget(
            onTap: () {}, // No-op for skeleton
            heading: 'Manual Orders',
            count: '0', // Static data
            imageAsset: UIDataImage.manualOrderSVG,
          ),
        ],
      ),
      SpacingHeight.heightlistspacing20,
      Row(
        children: [
          HomeCardWidget(
            onTap: () {}, // No-op for skeleton
            heading: 'Pending Orders',
            count: '0', // Static data
            imageAsset: UIDataImage.pendingOrderSVG,
          ),
          SpacingWidth.widthlistspacing20,
          HomeCardWidget(
            onTap: () {}, // No-op for skeleton
            heading: 'All Orders',
            count: '0', // Static data
            imageAsset: UIDataImage.allOrderSVG,
          ),
        ],
      ),
    ],
  );
}