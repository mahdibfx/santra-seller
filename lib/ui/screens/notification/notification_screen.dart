// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:santra_seller/ui/widgets/dropdown/common_dropdown.dart';

import '../../../controllers/home_controller/home_controller.dart';
import '../../../controllers/notification/notification_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/cards/home_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class NotificationScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  NotificationScreen({super.key});

  Widget bodyData(context) {
    return GetBuilder<NotificationController>(
      builder: (_) {
        return 
        _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                       HeadingWithIcon(
                            icon: UIDATAIcons.bell, btntxt: "Notifications"),
                      SpacingHeight.heightlistspacing10,

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _.oldNotifications.length,
                        itemBuilder: ((context, index) {
                          var notification = _.oldNotifications[index];
                        return Container(
                          height: 50,
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
                          child: Row(children: [
                          Text(notification.notifiactionDetail, style: UIDataTextStyles.title13Normal.copyWith(fontWeight: FontWeight.w500),),
                          // Text( dateFormat(notification.notificationTime.toIso8601String())),
                        
                        
                          ],).paddingAll(10),
                        ).marginOnly(bottom: 10);
                      }))
                    
                      
                    ],
                  ).marginOnly(left: 20, right: 20),
                ),
              );
      },
    );
    
  }
   String dateFormat(String date) {
    var inputFormat = DateTime.parse(date);
    var outputFormat = DateFormat('hh:mm a yyyy/MM/dd');
    var outputDate = outputFormat.format(inputFormat);
    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appbarSvg: true,
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
