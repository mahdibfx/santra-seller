import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/auth_providers/sign_up_provider.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/cart_card.dart';
import 'package:santra_seller/ui/widgets/buttons/border_button.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import 'package:santra_seller/ui/widgets/dropdown/common_dropdown.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';

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
  late CartProvider cartProvider;
  hitAllApis() async {
    await Future.microtask(() => context
        .read<MyCustomerProvider>()
        .isComingFromCart(widget.isComingFromCart));
  }

  @override
  void initState() {
    final provider = Provider.of<SignUpProvider>(context, listen: false);
    cartProvider = Provider.of(context, listen: false);
    provider.getCities();
    final customerProvider =
        Provider.of<MyCustomerProvider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      customerProvider.setCities();
      customerProvider.clearCityAndArea();
    });
    hitAllApis();
    super.initState();
  }

  Widget bodyData() {
    return GetBuilder<AppTranslations>(builder: (tr) {
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
                          btntxt: tr.translateData("add_customer_title")),
                      CommonTextField(
                        textInputAction: TextInputAction.next,
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
                            return tr.translateData("full_name_validation");
                          } else {
                            return null;
                          }
                        },
                      ),
                      CommonTextField(
                        textInputAction: TextInputAction.next,
                        controller: _.mobileController,
                        labelText: tr.translateData("add_customer_mobile"),
                        inputFormatters: [_.phoneMask],
                        prefixIcon: UIDATAIcons.callIcon,
                        maxLength: 12,
                        isTextHidden: false,
                        hintText: " 501234567",
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
                      // CommonTextField(
                      //   textInputAction: TextInputAction.next,
                      //   controller: _.emailController,
                      //   labelText: tr.translateData("add_customer_email"),
                      //   prefixIcon: UIDATAIcons.emailIcon,
                      //   isTextHidden: false,
                      //   fillcolor: UIDataColors.whiteColor,
                      //   keyboardType: TextInputType.text,
                      //   // validator: (val) {
                      //   //   bool email = _.emailRegex.hasMatch(val);
                      //   //   if (val.isEmpty) {
                      //   //     return "Please enter Email";
                      //   //   } else if (!email) {
                      //   //     return "Please Enter valid Email";
                      //   //   } else {
                      //   //     return null;
                      //   //   }
                      //   // },
                      // ),
                      SpacingHeight.heightlistspacing5,
                      MyDropdown(
                          label: tr.translateData("signup_city"),
                          validator: (value) {
                            if (value == null) {
                              return tr.translateData("select_city");
                            }
                          },
                          prefixIcon: UIDATAIcons.location,
                          options: _.cityList,
                          onChanged: (val) {
                            _.city = val;
                            _.getAreas(_.city);
                          },
                          selectedOption: _.city),
                      SpacingHeight.heightlistspacing15,

                      if (_.areas.isNotEmpty)
                        DropdownSearch<String>(
                          dropdownButtonProps: DropdownButtonProps(
                              icon: Padding(
                            padding: const EdgeInsets.only(right: 0.0),
                            child: SvgPicture.asset(UIDATAIcons.arrowDown),
                          )),
                          popupProps: areaFiledProps(tr),
                          items: _.areas,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              label: Text(
                                tr.translateData("area"),
                                style: const TextStyle(color: Colors.black),
                              ),
                              prefixIcon: SvgPicture.asset(
                                UIDATAIcons.areaIcon,
                                color: UIDataColors.blackText,
                              ).paddingSymmetric(vertical: 14),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xff757575).withOpacity(0.7),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xff757575).withOpacity(0.7),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          onChanged: (val) {
                            _.area = val;
                          },
                          validator: (value) {
                            if (value == null) {
                              return tr.translateData("select_city");
                            }
                          },
                          selectedItem: _.area,
                        ),
                      SpacingHeight.heightlistspacing10,
                      // CommonTextField(
                      //   textInputAction: TextInputAction.next,
                      //   controller: _.buildingController,
                      //   labelText: tr.translateData("building_no"),
                      //   prefixIcon: UIDATAIcons.building,
                      //   isTextHidden: false,
                      //   fillcolor: UIDataColors.whiteColor,
                      //   keyboardType: TextInputType.text,
                      //   validator: (val) {
                      //     if (val.isEmpty) {
                      //       return tr.translateData("enter_building_number");
                      //     }
                      //   },
                      // ),
                      // CommonTextField(
                      //   textInputAction: TextInputAction.next,
                      //   controller: _.aptController,
                      //   labelText: tr.translateData("apt_villa"),
                      //   prefixIcon: UIDATAIcons.homeIcon,
                      //   isTextHidden: false,
                      //   fillcolor: UIDataColors.whiteColor,
                      //   keyboardType: TextInputType.text,
                      //   validator: (val) {
                      //     if (val.isEmpty) {
                      //       return tr.translateData("enter_building");
                      //     }
                      //   },
                      // ),
                      CommonTextField(
                        controller: _.addressController,
                        labelText: tr.translateData("address_link"),
                        prefixIcon: UIDATAIcons.homeIcon,
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
                                      if (form.currentState!.validate()) {
                                        _.addCustomer(cartProvider!);
                                      }
                                    },
                                    btntxt: tr.translateData(
                                        "account_info_save_button"),
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
    });
  }

  PopupProps<String> areaFiledProps(AppTranslations tr) {
    return PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
            autofocus: true,
            decoration: InputDecoration(
              counterText: "",
              prefixIcon: SvgPicture.asset(
                UIDATAIcons.searchIcon,
                color: const Color.fromARGB(255, 55, 63, 68),
              ).paddingSymmetric(vertical: 11),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xff757575).withOpacity(0.7),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              label: Text(tr.translateData("search")),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xff757575).withOpacity(0.7),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              fillColor: Colors.white,
              filled: true,
              hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: tr.getFont(),
                  letterSpacing: 0.0),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 11.0, horizontal: 18.0),
              labelStyle: const TextStyle(color: Colors.black, fontSize: 15.0),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
            )));
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
