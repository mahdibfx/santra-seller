import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/ui/screens/notification/notification_screen.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class NotificationIconWithBadge extends StatelessWidget {
  String? icon;
  String? value;
  bool? showBadge;
  NotificationIconWithBadge({Key? key, this.icon, this.value, this.showBadge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final HomeController homeController = Get.find<HomeController>();

    return Consumer<HomeProvider>(builder: (context, _, child) {
        return GestureDetector(
          onTap: () {
            Get.to(()=> NotificationScreen());
          },
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                UIDATAIcons.bell,
                height: 30,
                color: Colors.black,
              ),
              if (_.homeData != null)
                if (_.homeData!.totalNotifications != "0")
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
                          child: Text(
                            _.homeData == null
                                ? '0'
                                : _.homeData!.totalNotifications
                                    .toString(),
                            style: UIDataTextStyles.caption,
                          ),
                        ),
                      ))
            ],
          ),
        );
      }
    );
  }
}
