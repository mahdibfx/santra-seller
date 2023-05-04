import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';

import '../../../../provider/more_settings_provider/contact_us_provider.dart';
import '../../../../utils/uidata.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/textfields/common_textfield.dart';
import '../../add_manual_order/add_manual_order.dart';

class ContactUsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  ContactUsScreen({super.key});
  final form = GlobalKey<FormState>();
  Widget bodyData() {
    return Consumer<ContactUsProvider>(
      builder: (con, _, child) {
        return SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              HeadingWithIcon(
                  icon: UIDATAIcons.orderRemarks,
                  btntxt: "side_menu__contact_signin".tr),
              Form(
                key: form,
                child: Column(
                  children: [
                    Column(children: [
                      CommonTextField(
                        controller: _.usernameController,
                        labelText: "conatct_us_name".tr,
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "full_name_validation".tr;
                          }
                        },
                      ),
                      CommonTextField(
                        controller: _.emailController,
                        labelText: 'conatct_us_email'.tr,
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          bool email = _.emailRegex.hasMatch(val);
                          if (val.isEmpty) {
                            return "email_validation".tr;
                          } else if (!email) {
                            return "valid_email_validation".tr;
                          }
                        },
                      ),
                      CommonTextField(
                        controller: _.phonenumberController,
                        labelText: 'conatct_us_mobile'.tr,
                        isTextHidden: false,
                        inputFormatters: [_.phoneMask],
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        hintText: "Ex: 501234567",
                        onChanged: (val) {
                          String? check0;

                          if (val.isNotEmpty && val.length > 3) {
                            check0 = val.substring(0, 4);
                            if (check0 == "9710") {
                              _.phonenumberController.clear();
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
                      CommonTextField(
                        maxlines: 5,
                        controller: _.messageController,
                        hintText: 'conatct_us_message'.tr,
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "your_query".tr;
                          }
                        },
                      ),
                      SpacingHeight.heightlistspacing10,
                    ]),
                    SpacingHeight.heightlistspacing10,
                    _.isLoading
                        ? const SizedBox(
                            child: Center(
                            child: CircularProgressIndicator(),
                          ))
                        : PrimaryButtonWithIcon(
                            btntxt: "conatct_us_send_button".tr,
                            iconImage: UIDATAIcons.sendIcon,
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                _.sendMessage();
                              }
                            },
                          ),
                    SpacingHeight.heightlistspacing15,
                  ],
                ),
              ),
               Text(
                'conatct_us_keep'.tr,
                style: UIDataTextStyles.h1,
              ),
              SpacingHeight.heightlistspacing5,
              const Text(
                '+971 50 188 6867',
                style: UIDataTextStyles.title,
              ),
              SpacingHeight.heightlistspacing5,
               Text(
                'conatct_us_email_text'.tr,
                style: UIDataTextStyles.title,
              ),
              SpacingHeight.heightlistspacing5,
               Text(
                'conatct_us_email_address_text_1'.tr,
                style: UIDataTextStyles.title,
              ),
               Text(
                'conatct_us_email_address_text_2'.tr,
                style: UIDataTextStyles.title,
              ),
               Text(
                'conatct_us_email_address_text_3'.tr,
                style: UIDataTextStyles.title,
              ),
              SpacingHeight.heightlistspacing50
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
      appTitle: 'conatct_us_title'.tr,
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
