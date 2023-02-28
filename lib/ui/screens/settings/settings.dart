// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:santra_seller/controllers/more_screen_controller.dart/more_controller.dart';
import 'package:santra_seller/ui/screens/settings/account_info.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';

import '../../../controllers/home_controller/home_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class Settings extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Settings({super.key});

  Widget bodyData(context) {
    return GetBuilder<MoreScreenController>(
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
                      const Text(
                        'Settings',
                        textScaleFactor: 2,
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          Get.toNamed(Routes.accountInfoRoute);
                        },
                        btntxt: const Text('Account info'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.alternate_email),
                        onPressed: () {
                          Get.toNamed(Routes.changeEmail);
                        },
                        btntxt: const Text('Change Email'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.lock),
                        onPressed: () {
                          Get.toNamed(Routes.changePassword);
                        },
                        btntxt: const Text('Change Password'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.language),
                        onPressed: () {},
                        btntxt: const Text('Language'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          customOntapDialogTwoButtons(
                              context,
                              "Logout",
                              "Are You Sure You Want To Logout?",
                              "Cancel",
                              "Logout", () {
                            Get.back();
                          }, () {});
                        },
                        btntxt: const Text('Logout'),
                      ),
                      ReusableIconSetting(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          customOntapDialogTwoButtons(
                              context,
                              "Delete Account",
                              "Are You Sure You Want To Permanantly Delete Your Account?",
                              "Cancel",
                              "Delete", () {
                            Get.back();
                          }, () {});
                        },
                        btntxt: const Text('Delete Account'),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
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
        Get.offAllNamed(Routes.signuproutes);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
