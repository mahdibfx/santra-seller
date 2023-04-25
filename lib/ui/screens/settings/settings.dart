// ignore_for_file: depend_on_referenced_packages
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/controllers/settings_controller/delete_account_controller.dart';
import 'package:santra_seller/controllers/settings_controller/logout_controller.dart';
import 'package:santra_seller/controllers/splash_controller.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/provider/login_provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/screens/settings/account_info.dart';
import 'package:santra_seller/ui/screens/settings/change_email.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';

import '../../../config/env.dart';
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
    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingWithIcon(
                  icon: UIDATAIcons.settingsIcon, btntxt: "Setting"),
              SpacingHeight.heightlistspacing15,
              ReusableIconSetting(
                icon: UIDATAIcons.infoIcon,
                onPressed: () {
                    Get.to(() =>  AccountInfo());
                
                },
                btntxt: "Account info",
              ),
              ReusableIconSetting(
                icon: UIDATAIcons.emailIcon,
                iconColor: UIDataColors.primaryColor,
                onPressed: () {
                    Get.to(() =>  ChangeEmail());
              
                },
                btntxt: "Change Email",
              ),
              ReusableIconSetting(
                icon: UIDATAIcons.lockIcon,
                onPressed: () {
                  Get.toNamed(Routes.changePassword);
                },
                btntxt: 'Change Password',
              ),
              ReusableIconSetting(
                icon: UIDATAIcons.languageIcon,
                onPressed: () {
                  Get.toNamed(Routes.languageSettings);
                },
                btntxt: 'Language',
              ),
              // GetBuilder<LogoutController>(builder: (logoutController) {
              //   return
              ReusableIconSetting(
                icon: UIDATAIcons.logoutIcon,
                onPressed: () {
                  customOntapDialogTwoButtons(
                      context,
                      "Logout",
                      "Are You Sure You Want To Logout?",
                      "Cancel",
                      "Logout", () {
                    Get.back();
                  }, () {
                    Get.back();
                    logoutController.logout().then((value) {
                      Provider.of<SplashProvider>(context, listen: false)
                          .flushSplashData();
                      Provider.of<LoginProvider>(context, listen: false)
                          .flushLoginDataData();
                      Provider.of<CartProvider>(context, listen: false)
                          .flushCart();
                    });
                  });
                },
                btntxt: 'Logout',
              ),
              //   ;
              // }),
              ReusableIconSetting(
                icon: UIDATAIcons.deleteIcon,
                onPressed: () {
                  Get.toNamed(Routes.deleteAccount);

                  // customOntapDialogTwoButtons(
                  //     context,
                  //     "Delete Account",
                  //     "Are You Sure You Want To Permanantly Delete Your Account?",
                  //     "Cancel",
                  //     "Delete", () {
                  //   Get.back();
                  // }, () {
                  //   Get.back();
                  //   deleteAccountController.deleteAccount();
                  // });
                },
                btntxt: 'Delete Account',
              ),

              SpacingHeight.heightlistspacing50
            ],
          ).paddingSymmetric(horizontal: 20)),
        ),
        Obx(
          () => logoutController.isLogoutLoading.isTrue
              ? Opacity(
                  opacity: 0.8,
                  child: ModalBarrier(
                      dismissible: false, color: Colors.black.withOpacity(0.5)),
                )
              : Container(),
        ),
        Obx(() => logoutController.isLogoutLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
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
        Get.offAll(() =>  const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
