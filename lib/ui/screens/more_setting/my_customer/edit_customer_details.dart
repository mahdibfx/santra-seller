import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import '../../../../provider/more_settings_provider/my_customer_provider.dart';

import '../../../../utils/uidata.dart';
import '../../../widgets/buttons/border_button.dart';
import '../../../widgets/buttons/icon_setting_button.dart';
import '../../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../../widgets/dropdown/common_dropdown.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import '../../../widgets/textfields/common_textfield.dart';
import '../../add_manual_order/add_manual_order.dart';

class EditCustomerDetails extends StatefulWidget {
  int? index;
  EditCustomerDetails({super.key, this.index});

  @override
  State<EditCustomerDetails> createState() => _EditCustomerDetailsState();
}

class _EditCustomerDetailsState extends State<EditCustomerDetails> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final formEdit = GlobalKey<FormState>();
  hitAllApis() async {
    await Future.microtask(() =>
        context.read<MyCustomerProvider>().setValuesForEdit(widget.index));
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
  }

  Widget bodyData() {
    return GetBuilder<AppTranslations>(
      builder: (tr) {
        return Consumer<MyCustomerProvider>(
          builder: (context, _, child) {
            return SafeArea(
              child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Form(
                    key: formEdit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingWithIcon(
                            icon: UIDATAIcons.customersIcon,
                            btntxt: tr.translateData("customer_edit_title")),
                        CommonTextField(
                          controller: _.fnController,
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          labelText: tr.translateData("add_customer_name"),
                          prefixIcon: UIDATAIcons.userIcon,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val.isEmpty) {
                              return tr.translateData("full_name_validation");
                            } else if (val == null) {
                              return tr.translateData("enter_valid_name");
                            } else {
                              return null;
                            }
                          },
                        ),
                        CommonTextField(
                          controller: _.mobileController,
                          labelText: tr.translateData("add_customer_mobile"),
                          prefixIcon: UIDATAIcons.callIcon,
                          isTextHidden: false,
                          inputFormatters: [_.phoneMask],
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.text,
                          hintText: " 501234567",
                          onChanged: (val) {
                            String? check0;

                            if (val.isNotEmpty && val.length > 3) {
                              check0 = val.substring(0, 4);
                              if (check0 == "9710") {
                                _.mobileController.clear();
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
                                return tr.translateData("valid_phone");
                              }
                            } else {
                              return null;
                            }
                          },
                        ),
                        CommonTextField(
                          controller: _.emailController,
                          labelText: tr.translateData("add_customer_email"),
                          prefixIcon: UIDATAIcons.emailIcon,
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.text,
                          // validator: (val) {
                          //   bool email = _.emailRegex.hasMatch(val);
                          //   if (val.isEmpty) {
                          //     return "Please enter Email";
                          //   } else if (!email) {
                          //     return "Please Enter valid Email";
                          //   } else {
                          //     return null;
                          //   }
                          // },
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: MyDropdown(
                                    label: tr.translateData("signup_city"),
                                    validator: (value) {
                                      if (value == null) {
                                        return tr.translateData("select_city");
                                      }
                                    },
                                    prefixIcon: UIDATAIcons.location,
                                    options: _.citiesList!,
                                    onChanged: (val) {
                                      _.city = val;
                                    },
                                    selectedOption: _.city)),
                            SpacingWidth.widthlistspacing15,
                            Expanded(
                              child: CommonTextField(
                                controller: _.buildingController,
                                labelText: tr.translateData("building_no"),
                                prefixIcon: UIDATAIcons.building,
                                isTextHidden: false,
                                fillcolor: UIDataColors.whiteColor,
                                keyboardType: TextInputType.text,
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return tr.translateData("enter_building_number");
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        CommonTextField(
                          controller: _.aptController,
                          labelText: tr.translateData("apt_villa"),
                          prefixIcon: UIDATAIcons.homeIcon,
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val.isEmpty) {
                              return tr.translateData("enter_building");
                            }
                          },
                        ),
                        CommonTextField(
                          controller: _.addressController,
                          labelText: tr.translateData("address_link"),
                          prefixIcon: UIDATAIcons.locationPin,
                          isTextHidden: false,
                          fillcolor: UIDataColors.whiteColor,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val.isEmpty) {
                              return tr.translateData("enter_address");
                            }
                          },
                        ),
                        SpacingHeight.heightlistspacing10,
                        _.isUpdateCustomerLoading
                            ? const SizedBox(
                                child: Center(
                                child: CircularProgressIndicator(),
                              ))
                            : Row(
                                children: [
                                  Expanded(
                                    child: BorderButton(
                                      onPressed: () {
                                        Get.back();
                                        _.disposeValues();
                                      },
                                      btntxt: tr.translateData("button_cancel"),
                                      iconImage: UIDATAIcons.close,
                                      iconColor: UIDataColors.primaryColor,
                                      buttontxtColor: UIDataColors.primaryColor,
                                      borderColor: UIDataColors.primaryColor,
                                      backEndColor: UIDataColors.whiteColor,
                                    ),
                                  ),
                                  SpacingWidth.widthlistspacing15,
                                  Expanded(
                                    child: PrimaryButtonWithIcon(
                                      onPressed: () {
                                        if (formEdit.currentState!.validate()) {
                                          _.updateCustomer();
                                        }
                                        //   _.addCustomer();
                                      },
                                      btntxt: tr.translateData("account_info_save_button"),
                                      iconImage: UIDATAIcons.saveIcon,
                                    ),
                                  ),
                                ],
                              ),
                        SpacingHeight.heightlistspacing50
                      ],
                    ).paddingSymmetric(horizontal: 15),
                  )),
            );
          },
        );
      }
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
      appTitle: 'Edit Customer Details',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
