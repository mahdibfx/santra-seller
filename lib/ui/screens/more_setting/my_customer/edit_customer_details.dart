import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
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
                        btntxt: "Edit Customer List".tr),
                    CommonTextField(
                      controller: _.fnController,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      labelText: "Full Name".tr,
                      prefixIcon: UIDATAIcons.userIcon,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "full_name_validation".tr;
                        } else if (val == null) {
                          return "enter_valid_name".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    CommonTextField(
                      controller: _.mobileController,
                      labelText: "Mobile",
                      prefixIcon: UIDATAIcons.callIcon,
                      isTextHidden: false,
                      inputFormatters: [_.phoneMask],
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
                      hintText: "Ex: 501234567",
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
                          return "valid_phone".tr;
                        } else if (val.isNotEmpty && val.length > 3) {
                          name = val.substring(0, 3);

                          if (name != "971") {
                            return "valid_phone".tr;
                          }
                        } else {
                          return null;
                        }
                      },
                    ),
                    CommonTextField(
                      controller: _.emailController,
                      // hintText: 'Email'.tr,
                      labelText: "Email",
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
                                label: "signup_city".tr,
                                validator: (value) {
                                  if (value == null) {
                                    return "select_city".tr;
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
                            labelText: "building_no".tr,
                            prefixIcon: UIDATAIcons.building,
                            isTextHidden: false,
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "enter_building_number".tr;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    CommonTextField(
                      controller: _.aptController,
                      labelText: "apt_villa".tr,
                      prefixIcon: UIDATAIcons.homeIcon,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "enter_building".tr;
                        }
                      },
                    ),
                    CommonTextField(
                      controller: _.addressController,
                      labelText: "address_link".tr,
                      prefixIcon: UIDATAIcons.locationPin,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "enter_address".tr;
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
                                  btntxt: "button_cancel".tr,
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
                                  btntxt: "account_info_save_button".tr,
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
