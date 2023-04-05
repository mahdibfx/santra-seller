import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class CartIconWithBadge extends StatelessWidget {
  String? icon;

  bool? showBadge;
  var onTap;
  CartIconWithBadge({Key? key, this.icon, this.showBadge, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    return GestureDetector(
      onTap: onTap!,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            UIDATAIcons.cartHallowIcon,
            height: 30,
            color: Colors.black,
          ),
          if (cartController.itemCount != 0)
            Positioned(
                right: -7,
                bottom: 25,
                child: Container(
                  height: 20,
                  // width: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color(0xffC32C4C),
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 2),
                    child: Obx(
                      () => Text(
                        cartController.itemCount.toString(),
                        style: UIDataTextStyles.caption,
                      ),
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
