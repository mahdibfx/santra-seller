import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
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
                        icon: UIDATAIcons.infoIcon, btntxt: "account_info_title".tr),

                    CommonTextField(
                      controller: _.emailController,
                      labelText: "Number",
                      inputFormatters: [_.phoneMask],
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      prefixIcon: UIDATAIcons.callIcon,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your email";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing5,
                    CommonTextField(
                      controller: _.fNameController,
                      labelText: "Business Name",
                      isTextHidden: false,
                      prefixIcon: UIDATAIcons.businessIcon,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your first name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SpacingHeight.heightlistspacing5,
                    CommonTextField(
                      controller: _.lNameController,
                      labelText: "Contact Person",
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      prefixIcon: UIDATAIcons.userIcon,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter your last name";
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
                            btntxt: "account_info_save_button".tr,
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
