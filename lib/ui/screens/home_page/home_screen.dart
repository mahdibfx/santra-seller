// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import '../../../controllers/home_controller/home_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
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
                      Row(
                        children: [
                          Icon(Icons.money),
                          Text(
                            "Monthly Total Earning",
                            style: UIDataTextStyles.homeheadingstyle,
                          ),
                        ],
                      ),
                      SpacingHeight.heightlistspacing20,
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Order'),
                                  Text(
                                    '270',
                                    style: UIDataTextStyles.homeheadingstyle
                                        .copyWith(fontSize: 20),
                                  ),
                                  Text('Monthly')
                                ],
                              ),
                            ),
                          ),
                          SpacingWidth.widthlistspacing,
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Revenue'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '40,500',
                                        style: UIDataTextStyles.homeheadingstyle
                                            .copyWith(fontSize: 20),
                                      ),
                                      Text('AED')
                                    ],
                                  ),
                                  Text('Monthly')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SpacingHeight.heightlistspacing20,
                      Row(
                        children: [
                          Icon(Icons.menu),
                          Text(
                            "Order Management",
                            style: UIDataTextStyles.homeheadingstyle,
                          ),
                        ],
                      ),
                      SpacingHeight.heightlistspacing20,
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: GridTile(
                              footer: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.card_travel),
                                  SpacingWidth.widthlistspacing,
                                  Text('Monthly'),
                                ],
                              ).marginAll(10),
                              child: Center(
                                child: Container(
                                  color: Colors.white,
                                  height: 70,
                                  child: Column(
                                    children: [
                                      Text(
                                        '40,500',
                                        style: UIDataTextStyles.homeheadingstyle
                                            .copyWith(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ), //just for testing, will fill with image later
                            ),
                          );
                        },
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
      appTitle: 'Logo',
      backarrow: UIDataColors.black,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
