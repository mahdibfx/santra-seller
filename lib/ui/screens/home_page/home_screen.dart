// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter_svg/svg.dart';

import '../../../controllers/home_controller/home_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/cards/home_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  HomeScreen({super.key});

  Widget bodyData() {
    return GetBuilder<HomeController>(
      builder: (_) {
        return _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SpacingHeight.heightlistspacing10,
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 95,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color.fromARGB(255, 4, 67, 112),
                                    Color.fromARGB(255, 70, 172, 240),
                                    
                                  ],
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Row(
                                children: [
                                   Container(
              // height: 40,
              child: SvgPicture.asset(
                UIDataImage.dollarIconSVG,
                fit: BoxFit.fitWidth,
              ),
            ).marginOnly(left: 20, right: 10, top: 10),
                                  Column(
                                    children: [
                                      Text('Orders Monthly',style: UIDataTextStyles.logintitlt2.copyWith(color: Colors.white,fontSize: 14, fontWeight: FontWeight.w500)),
                                      SpacingHeight.heightlistspacing15,
                                      Text(
                                        '270',
                                        style: UIDataTextStyles.logintitlt2.copyWith(color: Colors.white)
                                            .copyWith(fontSize: 20),
                                      ),
                                    ],
                                  ).marginOnly(top: 15,right: 10),
                                  VerticalDivider(
                                    width: 2,
                                    color: UIDataColors.white,
                                  ).marginOnly(top: 20, bottom: 20),
                                  Column(
                                    children: [
                                      Text('Profit Monthly',style: UIDataTextStyles.logintitlt2.copyWith(color: Colors.white,fontSize: 14, fontWeight: FontWeight.w500)),
                                      SpacingHeight.heightlistspacing15,
                                      Text(
                                        '42.65',
                                        style: UIDataTextStyles.logintitlt2.copyWith(color: Colors.white)
                                            .copyWith(fontSize: 20),
                                      ),
                                    ],
                                  ).marginOnly(top: 15, left: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SpacingHeight.heightlistspacing20,
                      Row(
                        children: [
                          HomeCardWidget(
                            heading: 'Santra Orders',
                            count: '153',
                            imageAsset: UIDataImage.santraOrderSVG,
                          ),
                          SpacingWidth.widthlistspacing,
                          HomeCardWidget(
                            heading: 'Manual Orders',
                            count: '153',
                            imageAsset: UIDataImage.manualOrderSVG,
                          ),
                        ],
                      ),
                      SpacingHeight.heightlistspacing10,
                      Row(
                        children: [
                          HomeCardWidget(
                            heading: 'Pending Orders',
                            count: '153',
                            imageAsset: UIDataImage.pendingOrderSVG,
                          ),
                          SpacingWidth.widthlistspacing,
                          HomeCardWidget(
                            heading: 'All Orders',
                            count: '153',
                            imageAsset: UIDataImage.allOrderSVG,
                          ),
                        ],
                      ),
                    ],
                  ).marginAll(10),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.commonColor,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.white,
      appbarSvg: true,
      backarrow: UIDataColors.black,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
