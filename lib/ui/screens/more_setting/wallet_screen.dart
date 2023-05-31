import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class WalletScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  WalletScreen({super.key});

  Widget bodyData() {
    return GetBuilder<AppTranslations>(
      builder: (tr) {
        return SafeArea(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              SpacingHeight.heightlistspacing20,
              Text(
                tr.translateData('more_wallet'),
                style: UIDataTextStyles.h1,
              ),
              SpacingHeight.heightlistspacing20,
            ],
          ).marginAll(10)),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.whiteColor,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'Wallet',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
