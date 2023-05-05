import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/home_page/home_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../../../provider/more_settings_provider/my_customer_provider.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../buttons/material_buttons/primaryButtonWithIcon.dart';
import '../textfields/common_textfield.dart';

class PaymentLinkBottomSheet extends StatelessWidget {
  // final cartdController = Get.find<MyCustomerController>();
  PaymentLinkBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("cart_payment_link".tr,
                  style: UIDataTextStyles.textMedium),
              SizedBox(
                width: 32,
                height: 32,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(5),
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
          Divider(
            height: 1,
            color: Colors.green.withOpacity(0.2),
          ).paddingOnly(top: 10, bottom: 0, left: 10, right: 10),
          Text("send_link".tr)
              .paddingAll(10),
          Consumer<MyCustomerProvider>(builder: (context, _, child) {
            return CommonTextField(
              readOnly: true,
              labelText: "link".tr,
              isTextHidden: false,
              fillcolor: Color.fromARGB(255, 255, 255, 255),
              keyboardType: TextInputType.text,
              initVal: _.link.text,
            ).paddingOnly(right: 10, left: 10);
          }),
          Divider(
            height: 1,
            color: Colors.green.withOpacity(0.2),
          ).paddingOnly(right: 10, left: 10, top: 5),
          Consumer<MyCustomerProvider>(builder: (context, _, child) {
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, top: 0),
                      child: PrimaryButtonWithIcon(
                        btntxt: "payment_link_copy_button".tr,
                        iconImage: UIDATAIcons.copyLink,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _.link.text));
                          _.showToast(
                            "Success",
                            "Copied to clipboard'",
                          );
                          Get.back();
                          Get.offAll(() => const HomeScreen());
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: PrimaryButtonWithIcon(
                        btntxt: "payment_link_share_button".tr,
                        backEndColor: UIDataColors.whiteColor,
                        buttontxtColor: UIDataColors.primaryColor,
                        iconImageColor: UIDataColors.primaryColor,
                        iconImage: UIDATAIcons.shareIcon,
                        onPressed: () {
                          // Get.back();
                          Share.share(_.link.text, subject: _.link.text);
                          Get.offAll(() => const HomeScreen());
                        },
                      ),
                    ),
                  )
                ],
              ).paddingOnly(right: 10, left: 10),
            );
          }),
          SpacingHeight.heightlistspacing35
        ],
      ),
    );
  }
}
