// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:santra_seller/controllers/settings_controller/delete_account_controller.dart';
import 'package:santra_seller/controllers/settings_controller/logout_controller.dart';
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
  final logoutController = Get.put(LogoutController());
  final deleteAccountController = Get.put(DeleteAccountController());
  Widget bodyData(context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              textScaleFactor: 2,
            ),
            ReusableIconSetting(
              icon: UIDATAIcons.infoIcon,
              onPressed: () {
                Get.toNamed(Routes.accountInfoRoute);
              },
              btntxt: const Text('Account info'),
            ),
            ReusableIconSetting(
              icon: UIDATAIcons.emailIcon,
              iconColor: UIDataColors.primaryColor,
              onPressed: () {
                Get.toNamed(Routes.changeEmail);
              },
              btntxt: const Text('Change Email'),
            ),
            ReusableIconSetting(
              icon: UIDATAIcons.lockIcon,
              onPressed: () {
                Get.toNamed(Routes.changePassword);
              },
              btntxt: const Text('Change Password'),
            ),
            ReusableIconSetting(
              icon: UIDATAIcons.languageIcon,
              onPressed: () {},
              btntxt: const Text('Language'),
            ),
            // GetBuilder<LogoutController>(builder: (logoutController) {
            //   return
            ReusableIconSetting(
              icon: UIDATAIcons.logoutIcon,
              onPressed: () {
                customOntapDialogTwoButtons(context, "Logout",
                    "Are You Sure You Want To Logout?", "Cancel", "Logout", () {
                  Get.back();
                }, () {
                  Get.back();
                  logoutController.logout();
                });
              },
              btntxt: const Text('Logout'),
            ),
            //   ;
            // }),
            ReusableIconSetting(
              icon: UIDATAIcons.deleteIcon,
              onPressed: () {
                customOntapDialogTwoButtons(
                    context,
                    "Delete Account",
                    "Are You Sure You Want To Permanantly Delete Your Account?",
                    "Cancel",
                    "Delete", () {
                  Get.back();
                }, () {
                  Get.back();
                  deleteAccountController.deleteAccount();
                });
              },
              btntxt: const Text('Delete Account'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      backgroundcolor: UIDataColors.whiteColor,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'Add customer',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.signuproutes);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
