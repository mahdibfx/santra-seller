import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../screens/more_setting/my_customer/add_customer.dart';
import '../../screens/more_setting/my_customer/my_customer_screen.dart';
import '../buttons/material_buttons/primaryButtonWithIcon.dart';

class CustomDetailBottomSheet extends StatelessWidget {
  CustomDetailBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppTranslations>(
      builder: (tr) {
        return SizedBox(
          height: 230,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(tr.translateData("add_customer_title"),
                      style: UIDataTextStyles.textMedium),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(5),
                          primary: UIDataColors.lightGrayColor),
                      onPressed: (() => Get.back()),
                      child: SvgPicture.asset(
                        width: 20,
                        height: 20,
                        color: UIDataColors.blackColor,
                        UIDATAIcons.close,
                      ),
                    ).paddingOnly(top: 5),
                  ),
                ],
              ).paddingOnly(top: 10, left: 10, right: 10),
              Padding(
                padding: const EdgeInsets.only(
                    right: 10, bottom: 20.0, left: 10, top: 20),
                child: PrimaryButtonWithIcon(
                  btntxt: tr.translateData("client_list_button"),
                  iconImage: UIDATAIcons.customersIcon,
                  onPressed: () {
                    Get.back();
                    Get.to(() => const MyCustomerScreen(comingFromCart: true));
                    // Get.toNamed(Routes.mycustomerscreen,
                    //     arguments: "commingFromCart");
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 20.0, left: 10),
                child: PrimaryButtonWithIcon(
                  btntxt: tr.translateData("new_customer_button"),
                  backEndColor: UIDataColors.whiteColor,
                  buttontxtColor: UIDataColors.primaryColor,
                  iconImageColor: UIDataColors.primaryColor,
                  iconImage: UIDATAIcons.userIcon,
                  onPressed: () {
                    Get.back();
                    Get.to(() => const AddCustomerScreen(isComingFromCart: true));
                  },
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
