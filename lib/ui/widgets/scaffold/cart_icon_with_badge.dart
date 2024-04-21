import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../provider/cart_provider.dart';
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
    // final CartController cartController = Get.find<CartController>();
    return Consumer<CartProvider>(builder: (context, cartController, child) {
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
                  bottom: 20,
                  child: Container(
                    height: 20,
                    width: 20,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                      cartController.itemCount.toString(),
                      style: UIDataTextStyles.caption
                          .copyWith(color: Colors.white),
                    ),
                  ))
          ],
        ),
      );
    });
  }
}
