import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/auth_providers/sign_up_provider.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/ui/widgets/dropdown/common_dropdown.dart';

import '../../../../provider/more_settings_provider/my_customer_provider.dart';
import '../../../../utils/uidata.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import '../../../widgets/textfields/common_textfield.dart';
import '../../add_manual_order/add_manual_order.dart';

class AddCustomerScreen extends StatefulWidget {
  final bool isComingFromCart;
  const AddCustomerScreen({super.key, this.isComingFromCart = false});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> form = GlobalKey<FormState>();
  // SignUpController signUpController = Get.put(SignUpController());

  hitAllApis() async {
    await Future.microtask(() => context
        .read<MyCustomerProvider>()
        .isComingFromCart(widget.isComingFromCart));

    //     final provider = Provider.of<SignUpProvider>(context);
    // provider.getCities();

    // Provider.of<MyCustomerProvider>(context, listen: false).isComingFromCart(widget.isComingFromCart);
  }

  @override
  void initState() {
    final provider = Provider.of<SignUpProvider>(context, listen: false);
    provider.getCities();
    hitAllApis();

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   final provider = Provider.of<SignUpProvider>(context);
  //   provider.getCities(); // OK
  //   super.didChangeDependencies();
  // }

  Widget bodyData() {
    return Consumer<MyCustomerProvider>(
      builder: (context, _, child) {
        return SafeArea(
          child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingWithIcon(
                        icon: UIDATAIcons.customersIcon,
                        btntxt: "add_customer_title".tr),
                    CommonTextField(
                      controller: _.fnController,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      labelText: "add_customer_name".tr,
                      prefixIcon: UIDATAIcons.userIcon,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "full_name_validation".tr;
                        } else if (val == null) {
                          return "full_name_validation".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    CommonTextField(
                      controller: _.mobileController,
                      labelText: "add_customer_mobile".tr,
                      inputFormatters: [_.phoneMask],
                      prefixIcon: UIDATAIcons.callIcon,
                      maxLength: 12,
                      isTextHidden: false,
                      hintText: "Ex: 501234567",
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
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
                            return "valid_phone_971".tr;
                          }
                        } else {
                          return null;
                        }
                      },
                    ),
                    CommonTextField(
                      controller: _.emailController,
                      // hintText: 'Email'.tr,
                      labelText: "add_customer_email".tr,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Consumer<SignUpProvider>(
                            builder: (context, signUpController, child) {
                          return MyDropdown(
                              label: "signup_city".tr,
                              validator: (value) {
                                if (value == null) {
                                  return "select_city".tr;
                                }
                              },
                              prefixIcon: UIDATAIcons.location,
                              options: signUpController.citiesList,
                              onChanged: (val) {
                                _.city = val;
                              },
                              selectedOption: _.city);
                        })),
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
                    _.isAddCustomerLoading
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
                                    if (form.currentState!.validate()) {
                                      _.addCustomer();
                                    }
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
      // scaffoldKey: _key,
      showActions: false,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'My Customer',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
