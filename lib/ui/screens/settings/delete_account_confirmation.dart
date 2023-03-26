import 'package:santra_seller/controllers/settings_controller/delete_account_controller.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class DeleteAccountConfirmation extends StatelessWidget {
  DeleteAccountConfirmation({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  Widget bodyData(context) {
    return GetBuilder<DeleteAccountController>(
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height / 1.1,
              ),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingWithIcon(
                        icon: UIDATAIcons.deleteIcon, btntxt: "Delete Account"),
                    SpacingHeight.heightlistspacing15,
                    const Text(
                      "Enter OTP",
                      style: UIDataTextStyles.h1Heavy,
                    ),
                    SpacingHeight.heightlistspacing15,
                    const Text("An 6 digit code has been sent to",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    SpacingHeight.heightlistspacing5,
                    const Text("+97190707690",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),

                    SpacingHeight.heightlistspacing15,

                    CommonTextField(
                      isTextHidden: false,
                      fillcolor: Colors.white,
                      keyboardType: TextInputType.phone,
                      hintText: "OTP",
                    ),
                    SpacingHeight.heightlistspacing5,
                    BorderButton(
                      btntxt: "Continue",
                      backEndColor: Colors.transparent,
                      borderColor: UIDataColors.redColor,
                      buttontxtColor: UIDataColors.redColor,
                      onPressed: () {},
                    ),

                    SpacingHeight.heightlistspacing15,
                    // Obx(() => _.isLoading
                    //         ? const Center(
                    //             child: CircularProgressIndicator(),
                    //           )
                    //         :

                    //),
                  ],
                ).marginOnly(left: 20.0, right: 20.0),
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
        Get.offAllNamed(Routes.signuproutes);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
