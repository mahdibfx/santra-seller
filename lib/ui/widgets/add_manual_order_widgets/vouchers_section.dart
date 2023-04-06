import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/controllers/cart_controller/cart_controller.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/voucher_code_form_field.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/voucher_tile.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import '../../../utils/uidata.dart';

class VouchersSection extends StatelessWidget {
  CartController cartController = Get.put(CartController());
  VouchersSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.1,
              blurRadius: 4,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingWithIcon(
                icon: UIDATAIcons.voucherStarIcon, btntxt: "Vouchers"),
            SizedBox(
              height: 55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: cartController.vouchersList.length,
                itemBuilder: ((context, index) {
                  return VoucherTile(
                    index: index,
                    title: cartController.vouchersList[index].offerTitle,
                    subtitle: cartController.vouchersList[index].msg,
                    buttonTitle: cartController.activeOffers.contains(index)
                        ? "Applied"
                        : "Apply",
                  );
                }),
              ),
            ),
            SpacingHeight.heightlistspacing20,
            VoucherCodeFormField()
          ],
        ),
      ),
    );
  }
}
