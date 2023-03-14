import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class PDCardAddManualOrder extends StatelessWidget {
  var onTap;
  PDCardAddManualOrder({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                height: 80,
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    UIDataImage.dummyImage,
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(
                height: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Product Name",
                      style: UIDataTextStyles.h2,
                    ),
                    Text(
                      "AED 15",
                      style: UIDataTextStyles.h2,
                    ),
                  ],
                ).marginOnly(top: 5, bottom: 5, left: 8, right: 8)),
            const Spacer(),
            GestureDetector(
              onTap: onTap,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  height: 80,
                  width: 80,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: UIDataColors.primaryColor),
                    child: const Icon(
                      Icons.add,
                      size: 40,
                    ),
                  )),
            ),
          ],
        ).paddingOnly(left: 5, right: 5, top: 5, bottom: 5));
  }
}
