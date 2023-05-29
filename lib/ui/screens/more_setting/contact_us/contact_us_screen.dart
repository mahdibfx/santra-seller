import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';

import '../../../../provider/more_settings_provider/contact_us_provider.dart';
import '../../../../utils/uidata.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/textfields/common_textfield.dart';
import '../../add_manual_order/add_manual_order.dart';

class ContactUsScreen extends StatefulWidget {

  ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final form = GlobalKey<FormState>();

  Widget bodyData(context) {
    return GetBuilder<AppTranslations>(
      builder: (tr) {
        return Consumer<ContactUsProvider>(
          builder: (con, _, child) {
            return SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  HeadingWithIcon(
                      icon: UIDATAIcons.orderRemarks,
                      btntxt: tr.translateData("side_menu__contact_signin")),
                  Form(
                    key: form,
                    child: Column(
                      children: [
                        Column(children: [
                          CommonTextField(
                            textInputAction: TextInputAction.next,
                            controller: _.usernameController,
                            labelText: tr.translateData("conatct_us_name"),
                            isTextHidden: false,
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val.isEmpty) {
                                return tr.translateData("full_name_validation");
                              }
                            },
                          ),
                          CommonTextField(
                            textInputAction: TextInputAction.next,
                            controller: _.emailController,
                            labelText: tr.translateData('conatct_us_email'),
                            isTextHidden: false,
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              bool email = _.emailRegex.hasMatch(val);
                              if (val.isEmpty) {
                                return tr.translateData("email_validation");
                              } else if (!email) {
                                return tr.translateData("valid_email_validation");
                              }
                            },
                          ),
                          CommonTextField(
                            textInputAction: TextInputAction.next,
                            controller: _.phonenumberController,
                            labelText: tr.translateData('conatct_us_mobile'),
                            isTextHidden: false,
                            inputFormatters: [_.phoneMask],
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.number,
                            maxLength: 12,
                            hintText: " 501234567",
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
                                return tr.translateData("valid_phone");
                              } else if (val.isNotEmpty && val.length > 3) {
                                name = val.substring(0, 3);
    
                                if (name != "971") {
                                  return tr.translateData("valid_phone_971");
                                }
                              } else {
                                return null;
                              }
                            },
                          ),
                          CommonTextField(
                            maxlines: 5,
                            controller: _.messageController,
                            hintText: tr.translateData('conatct_us_message'),
                            isTextHidden: false,
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val.isEmpty) {
                                return tr.translateData("your_query");
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
                                btntxt: tr.translateData("conatct_us_send_button"),
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
                    tr.translateData('conatct_us_keep'),
                    style: UIDataTextStyles.h1,
                  ),
                  SpacingHeight.heightlistspacing5,
                   Text(
                    '+971 50 188 6867',
                    style: UIDataTextStyles.title,
                  ),
                  SpacingHeight.heightlistspacing5,
                   Text(
                    tr.translateData('conatct_us_email_text'),
                    style: UIDataTextStyles.title,
                  ),
                  SpacingHeight.heightlistspacing5,
                   Text(
                    tr.translateData('conatct_us_email_address_text_1'),
                    style: UIDataTextStyles.title,
                  ),
                   Text(
                   tr.translateData( 'conatct_us_email_address_text_2'),
                    style: UIDataTextStyles.title,
                  ),
                   Text(
                    tr.translateData('conatct_us_email_address_text_3'),
                    style: UIDataTextStyles.title,
                  ),
                  SpacingHeight.heightlistspacing50
                ],
              ).paddingSymmetric(horizontal: 15)),
            );
          },
        );
      }
    );
  }
  @override
  void initState() {
    appFlyerController.contactCustomerServiceEvent();
    super.initState();
  
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
      appTitle:'',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
