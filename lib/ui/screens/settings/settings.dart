// ignore_for_file: depend_on_referenced_packages

import 'package:provider/provider.dart';
import 'package:santra_seller/provider/setting_provider/delete_account_provider.dart';
import 'package:santra_seller/provider/setting_provider/logout_controller.dart';
import 'package:santra_seller/provider/splash_provider.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/provider/auth_providers/login_provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/screens/settings/account_info.dart';
import 'package:santra_seller/ui/screens/settings/change_email.dart';
import 'package:santra_seller/ui/screens/settings/change_password.dart';
import 'package:santra_seller/ui/screens/settings/delete_account.dart';
import 'package:santra_seller/ui/screens/settings/language_screen.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DeleteAccountProvider>(context, listen: false)
          .deleteAccountonInit();
    });
  }

  Widget bodyData(context) {
    return Consumer<LogoutProvider>(
      builder: (context, value, child) {
        return Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingWithIcon(
                      icon: UIDATAIcons.settingsIcon, btntxt: "more_setting".tr),
                  SpacingHeight.heightlistspacing15,
                  ReusableIconSetting(
                    icon: UIDATAIcons.infoIcon,
                    onPressed: () {
                      Get.to(() => const AccountInfo());
                    },
                    btntxt: "setting_account".tr,
                  ),
                  ReusableIconSetting(
                    icon: UIDATAIcons.emailIcon,
                    iconColor: UIDataColors.primaryColor,
                    onPressed: () {
                      Get.to(() => const ChangeEmail());
                    },
                    btntxt: "setting_email".tr,
                  ),
                  ReusableIconSetting(
                    icon: UIDATAIcons.lockIcon,
                    onPressed: () {
                      Get.to(() => ChangePassword());
                      // Get.toNamed(Routes.changePassword);
                    },
                    btntxt: 'setting_password'.tr,
                  ),
                  ReusableIconSetting(
                    icon: UIDATAIcons.languageIcon,
                    onPressed: () {
                      Get.to(() => const LanguageSettings());
                    },
                    btntxt: 'setting_language'.tr,
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
                        Provider.of<LogoutProvider>(context, listen: false)
                            .logout()
                            .then((value) {
                          Provider.of<SplashProvider>(context, listen: false)
                              .flushSplashData();
                          Provider.of<LoginProvider>(context, listen: false)
                              .flushLoginDataData();
                          Provider.of<CartProvider>(context, listen: false)
                              .flushCart();
                        });
                      });
                    },
                    btntxt: 'setting_logout'.tr,
                  ),
                  //   ;
                  // }),
                  ReusableIconSetting(
                    icon: UIDATAIcons.deleteIcon,
                    onPressed: () {
                      Get.to(() => DeleteAccount());
                    },
                    btntxt: 'setting_delete'.tr,
                  ),

                  SpacingHeight.heightlistspacing50
                ],
              ).paddingSymmetric(horizontal: 20)),
            ),
            value.isLogoutLoading
                ? Opacity(
                    opacity: 0.8,
                    child: ModalBarrier(
                        dismissible: false,
                        color: Colors.black.withOpacity(0.5)),
                  )
                : Container(),
            value.isLogoutLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        );
      },
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
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
