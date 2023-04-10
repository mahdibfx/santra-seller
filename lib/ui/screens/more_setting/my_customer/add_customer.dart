import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/controllers/auth_controller/signup_controller.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/my_customer/my_customer_controller.dart';
import 'package:santra_seller/provider/sign_up_provider.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/ui/widgets/dropdown/common_dropdown.dart';

import '../../../../provider/my_customer_provider.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/uidata.dart';
import '../../../widgets/scaffold/common_scaffold.dart';
import '../../../widgets/textfields/common_textfield.dart';

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
                        btntxt: "Add Customer List".tr),
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
                      //controller: _.mobileController,
                      labelText: "Mobile",
                      inputFormatters: [_.phoneMask],
                      prefixIcon: UIDATAIcons.callIcon,
                      maxLength: 12,
                      isTextHidden: false,
                      fillcolor: UIDataColors.whiteColor,
                      keyboardType: TextInputType.text,
                      onChanged: (val) {
                        _.phoneCon = val;
                        print(_.phoneCon);
                      },
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Consumer<SignUpProvider>(
                            builder: (context, signUpController, child) {
                          return MyDropdown(
                              label: "City",
                              validator: (value) {
                                if (value == null) {
                                  return "Please select city";
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
                                    if (form.currentState!.validate()) {
                                      _.addCustomer();
                                    }
                                  },
                                  btntxt: "Save",
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
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'My Customer',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
