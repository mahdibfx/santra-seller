import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';

import '../../../provider/cart_provider.dart';
import '../dialogs/custom_dialogs.dart';

// ignore: must_be_immutable
class VoucherCodeFormField extends StatelessWidget {
  VoucherCodeFormField({
    super.key,
  });
  // CartController cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<AppTranslations>(builder: (context, tr, child) {
        return Consumer<CartProvider>(builder: (context, cartController, child) {
          return Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Form(
                        child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            key: Key(cartController.voucherCode.toString()),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            cursorWidth: 0.75,
                            textInputAction: TextInputAction.done,
                            //  controller: value.voucherCodeController,
                            style: const TextStyle(
                                color: UIDataColors.blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                fontFamily: "MarkPro"),
                            inputFormatters: const [],
                            enableSuggestions: false,
                            cursorColor: UIDataColors.primaryColor,

                            onChanged: ((val) {
                              cartController.voucherCode = val;
                            }),
                            initialValue: cartController.voucherCode == null
                                ? ""
                                : cartController.voucherCode.toString(),
                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: SizedBox(
                                height: 30,
                                width: 40,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    UIDATAIcons.voucherTagIcon,
                                    color: UIDataColors.blackColor,
                                  ),
                                ),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 0, right: 8),
                                child: GestureDetector(
                                    child: TextButton(
                                        onPressed: () {
                                          if (cartController.voucherCode == null) {
                                            exceptionDialog(tr.translateData("voucher_code"),
                                                tr.translateData("valid_voucher"));
                                          } else if (cartController.promoValid) {
                                            exceptionDialog(
                                                tr.translateData("already_applied"),
                                                tr.translateData("voucher_applied")
                                                    .capitalize!);
                                          } else {
                                            cartController.promoDiscount();
                                          }
                                        },
                                        child:  Text(tr.translateData("change_password_save_button"),
                                            style: TextStyle(
                                                color: UIDataColors.primaryColor,
                                                fontFamily: "Markpro")))),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              // hintText: value.voucherCode,
                              label: Text(tr.translateData("add_voucher_code"),
                                  style: TextStyle(
                                      color: Colors.grey.shade600, fontSize: 15)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: UIDataColors.grayColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: UIDataColors.grayColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: UIDataColors.grayColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      }
    );
  }
}
