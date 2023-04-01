import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:santra_seller/ui/widgets/cards/my_customer_card.dart';
import 'package:santra_seller/ui/widgets/scaffold/common_scaffold.dart';
import 'package:santra_seller/utils/routes/app_routes.dart';
import 'package:santra_seller/utils/uidata.dart';

import '../../../../controllers/more_screen_controller.dart/my_customer/my_customer_controller.dart';
import '../../../../utils/uidata/textStyles.dart';
import '../../../widgets/buttons/icon_setting_button.dart';
import '../../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../../widgets/textfields/common_textfield.dart';
import 'card_customer_detail.dart';

class ViewCustomerDetails extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  ViewCustomerDetails({super.key});

  Widget bodyData(BuildContext context) {
     Size size = MediaQuery.of(context).size;
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
      
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
 Text("Choose the payment methord", style: UIDataTextStyles.dialogMsg).paddingOnly(top: 40, bottom: 20),


                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("Online payment", style: UIDataTextStyles.h3)),
                      Expanded(child: FlutterSwitch(
                  activeColor: UIDataColors.primaryColor,
                  width: size.width * 0.11,
                  toggleColor: UIDataColors.whiteColor,
                  padding: 2,
                  height: size.height * 0.03,
                  value: true,
                  // value: widget.productSettingsController
                  //             .allProducts?[widget.index!].productStatus ==
                  //         "approved"
                  //     ? true
                  //     : false,
                  onToggle: (val) {
                    // setState(() {
                    //   widget.currentStatus = val;
                    //   widget.productSettingsController
                    //       .toggleStatus(widget.index);
                    //   widget.productSettingsController
                    //       .changeProductAvailability(
                    //           widget.productSettingsController
                    //               .allProducts?[widget.index!].productCode,
                    //           widget.currentStatus == true
                    //               ? "enable"
                    //               : "out_of_stock");
                    // });
                  },
                )),
                     Expanded(child: Text("Pay on receipt", style: UIDataTextStyles.h3))
                  ],
                ),
                

                Padding(
                   padding: const EdgeInsets.only(top: 20.0),
                   child: PrimaryButtonWithIcon(
                        btntxt: "Submit",
                        backEndColor: UIDataColors.whiteColor,
                        buttontxtColor: UIDataColors.primaryColor,
                        iconImageColor: UIDataColors.primaryColor,
                        iconImage: UIDATAIcons.sendIcon,
                        onPressed: () {},
                      ),
                 )

                 
              ],
            ),

            

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
