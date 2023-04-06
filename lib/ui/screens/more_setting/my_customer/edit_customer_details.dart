import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/my_customer/my_customer_controller.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/uidata.dart';
import '../../../widgets/buttons/border_button.dart';
import '../../../widgets/buttons/icon_setting_button.dart';
import '../../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../../widgets/dropdown/common_dropdown.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import '../../../widgets/textfields/common_textfield.dart';

class EditCustomerDetails extends StatefulWidget {
  int? index;
  EditCustomerDetails({super.key, this.index});

  @override
  State<EditCustomerDetails> createState() => _EditCustomerDetailsState();
}

class _EditCustomerDetailsState extends State<EditCustomerDetails> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final formEdit = GlobalKey<FormState>();
  MyCustomerController customerController = Get.put(MyCustomerController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.setValuesForEdit(widget.index);
    });
  }

  Widget bodyData() {
    return GetBuilder<MyCustomerController>(
      builder: (_) {
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
                          return "Please enter full name";
                        } else if (val == null) {
                          return "Please enter valid name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    CommonTextField(
                      controller: _.mobileController,
                      labelText: "Mobile",
                      hintText: "971#########",
                      prefixIcon: UIDATAIcons.callIcon,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        String? name;
                        if (val.isEmpty || val.length < 12) {
                          return "Please Enter Valid Phone Number";
                        } else if (val.isNotEmpty && val.length > 3) {
                          name = val.substring(0, 3);

                          if (name != "971") {
                            return "Phone Number Must Start With 971";
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
                      validator: (val) {
                        bool email = _.emailRegex.hasMatch(val);
                        if (val.isEmpty) {
                          return "Please enter Email";
                        } else if (!email) {
                          return "Please Enter valid Email";
                        } else {
                          return null;
                        }
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: MyDropdown(
                                label: "City",
                                validator: (value) {
                                  if (value == null) {
                                    return "Please select city";
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
                            labelText: "Building No.",
                            prefixIcon: UIDATAIcons.building,
                            isTextHidden: false,
                            fillcolor: UIDataColors.whiteColor,
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Enter building#";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    CommonTextField(
                      controller: _.aptController,
                      labelText: "Apt/Villa",
                      prefixIcon: UIDATAIcons.homeIcon,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please enter building type";
                        }
                      },
                    ),
                    CommonTextField(
                      controller: _.addressController,
                      labelText: "Address Link",
                      prefixIcon: UIDATAIcons.locationPin,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please enter address link";
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
                                  btntxt: "Cancel",
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
                                  btntxt: "Save",
                                  iconImage: UIDATAIcons.saveIcon,
                                ),
                              ),
                            ],
                          )
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
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
