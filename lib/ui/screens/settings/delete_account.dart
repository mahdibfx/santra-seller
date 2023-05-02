import 'package:provider/provider.dart';
import 'package:santra_seller/provider/setting_provider/delete_account_provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class DeleteAccount extends StatefulWidget {
  DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
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
    return Consumer<DeleteAccountProvider>(
      builder: (context, _, child) {
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
                        icon: UIDATAIcons.deleteIcon, btntxt: "delete_account_title".tr),
                     Text(
                      "delete_account_reason".tr,
                      style: UIDataTextStyles.title,
                    ),
                    SpacingHeight.heightlistspacing15,
                    CommonTextField(
                      maxlines: 5,
                      isTextHidden: false,
                      fillcolor: Colors.white,
                      keyboardType: TextInputType.phone,
                      hintText: "delete_account_reason_field".tr,
                    ),
                    Form(
                        key: _.formDeleteAccScreen1,
                        child: IgnorePointer(
                          ignoring: true,
                          child: CommonTextField(
                            controller: _.phoneController,
                            isTextHidden: false,
                            fillcolor: Colors.white,
                            keyboardType: TextInputType.phone,
                            labelText: "delete_account_number".tr,
                            inputFormatters: [_.phoneMask],
                            hintText: "Ex: 501234567",
                            maxLength: 12,
                            onChanged: (val) {
                              String? check0;

                              if (val.isNotEmpty && val.length > 3) {
                                check0 = val.substring(0, 4);
                                if (check0 == "9710") {
                                  _.phoneController.clear();
                                }
                              }
                            },
                            validator: (val) {
                              String? name;
                              if (val.isEmpty || val.length < 12) {
                                return "valid_phone".tr;
                              } else if (val.isNotEmpty && val.length > 3) {
                                name = val.substring(0, 3);

                                if (name != "971") {
                                  return "valid_phone_971".tr;
                                }
                              } else {
                                return null;
                              }
                            },
                          ),
                        )),
                    SpacingHeight.heightlistspacing5,
                    _.isOtpLoading
                        ? const Center(child: CircularProgressIndicator())
                        : BorderButton(
                            btntxt: "delete_account_continue_button".tr,
                            backEndColor: Colors.white,
                            borderColor: UIDataColors.secondaryColor,
                            buttontxtColor: UIDataColors.secondaryColor,
                            onPressed: () {
                              _.getOtp();
                              // Get.toNamed(Routes.deleteAccountConfirmation);
                            },
                          ),
                    SpacingHeight.heightlistspacing15,
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
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
