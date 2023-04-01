import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:santra_seller/ui/widgets/cards/my_customer_card.dart';
import 'package:santra_seller/ui/widgets/scaffold/common_scaffold.dart';
import 'package:santra_seller/utils/routes/app_routes.dart';
import 'package:santra_seller/utils/uidata.dart';

import '../../../../controllers/more_screen_controller.dart/my_customer/my_customer_controller.dart';
import '../../../widgets/buttons/icon_setting_button.dart';
import '../../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../../widgets/textfields/common_textfield.dart';
import 'card_customer_detail.dart';

class ViewCustomerDetails extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  ViewCustomerDetails({super.key});

  Widget bodyData() {
    return GetBuilder<MyCustomerController>(
      builder: (_) {
        return _.isViewCustomerLoading
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
                        icon: UIDATAIcons.userIcon,
                        iconColor: UIDataColors.primaryColor,
                        btntxt: "Customer Info".tr),

                    SpacingHeight.heightlistspacing10,

                    CardCustomerDetail(),

                    SpacingHeight.heightlistspacing20,
                  ],
                ).paddingSymmetric(horizontal: 15)),
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
      appTitle: 'Customer Detail',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
