// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import '../../../controllers/home_controller/home_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class CustomerScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  CustomerScreen({super.key});

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
                  child: Center(
                    child: Container(
                      child: Text('Customer screen'),
                    ),
                  ),
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
      appTitle: 'Add customer',
      backarrow: UIDataColors.black,
      qrCallback: () {
        Get.offAllNamed(Routes.addCustomer);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
