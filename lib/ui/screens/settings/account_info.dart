import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import '../../../provider/setting_provider/account_info_provider.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import '../../widgets/textfields/common_textfield.dart';
import 'package:flutter/material.dart';
import '../add_manual_order/add_manual_order.dart';
import '/utils/uidata.dart';
import 'package:get/get.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  hitAllApis() async {
    await Future.microtask(() => context.read<AccountInfoProvider>().onInit());
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
  }

  Widget bodyData(context) {
    return Consumer<AppTranslations>(
          builder: (context, tr, child) {
        return Consumer<AccountInfoProvider>(
          builder: (context, _, child) {
            return SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: Get.height / 1.1,
                  ),
                  child: Form(
                    key: _.form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingWithIcon(
                            icon: UIDATAIcons.infoIcon, btntxt: tr.translateData("account_info_title")),

                        CommonTextField(
                          controller: _.emailController,
                          labelText: tr.translateData("setting_account_number"),
                          inputFormatters: [_.phoneMask],
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          prefixIcon: UIDATAIcons.callIcon,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val.isEmpty) {
                              return tr.translateData("email_validation");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing5,
                        CommonTextField(
                          controller: _.fNameController,
                          labelText: tr.translateData("setting_account_business"),
                          isTextHidden: false,
                          prefixIcon: UIDATAIcons.businessIcon,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val.isEmpty) {
                              return tr.translateData("enter_first_name");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing5,
                        CommonTextField(
                          controller: _.lNameController,
                          labelText: tr.translateData("setting_account_contact"),
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          prefixIcon: UIDATAIcons.userIcon,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val.isEmpty) {
                              return tr.translateData("enter_last_name");
                            } else {
                              return null;
                            }
                          },
                        ),
                        // SpacingHeight.heightlistspacing5,
                        // TappableTextField(
                        //   ontap: () {
                        //     _.pickUserDob(context);
                        //   },
                        //   prefixIcon: UIDATAIcons.calendarIcon,
                        //   fieldHeight: 50,
                        //   value: _.userDob != null
                        //       ? DateFormat('yyyy-MM-dd').format(_.userDob!)
                        //       : "",
                        // ),
                        SpacingHeight.heightlistspacing20,
                        _.isUpdateAccInfoLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PrimaryButtonWithIcon(
                                btntxt: tr.translateData("account_info_save_button"),
                                iconImage: UIDATAIcons.saveIcon,
                                onPressed: () {
                                  _.updateAccountInfo();
                                },
                              )
                      ],
                    ).paddingSymmetric(horizontal: 20),
                  ),
                ),
              ),
            );
          },
        );
      }
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
