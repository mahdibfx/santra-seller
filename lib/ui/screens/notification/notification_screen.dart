// ignore_for_file: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import '../../../provider/notification_provider.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/buttons/icon_setting_button.dart';
import '../../widgets/scaffold/common_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Widget bodyData(context) {
    return Consumer<AppTranslations>(
          builder: (con, tr, child) {
        return Consumer<NotificationProvider>(
          builder: (context, _, child) {
            return _.isLoading
                ? const SizedBox(
                    child: Center(
                    child: CircularProgressIndicator(),
                  ))
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          HeadingWithIcon(
                            icon: UIDATAIcons.bell,
                            btntxt: tr.translateData("notifications_title"),
                            iconColor: UIDataColors.primaryColor,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _.notificationList.length,
                              itemBuilder: ((context, index) {
                                var notifications = _.notificationList[index];
                                return Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 2),
                                        // height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              spreadRadius: 0.1,
                                              blurRadius: 4,
                                              offset: const Offset(0,
                                                  0), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              notifications.notifiactionDetail,
                                              style: UIDataTextStyles.title13Normal
                                                  .copyWith(
                                                      fontWeight: FontWeight.w500),
                                            ),
                                            // Text( dateFormat(notification.notificationTime.toIso8601String())),
                                          ],
                                        ).paddingSymmetric(horizontal: 15))
                                    .marginOnly(bottom: 10);
                              })),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _.oldNotifications.length,
                              itemBuilder: ((context, index) {
                                var notification = _.oldNotifications[index];
                                return Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 2),
                                        // height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              spreadRadius: 0.1,
                                              blurRadius: 4,
                                              offset: const Offset(0,
                                                  0), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              notification.notifiactionDetail,
                                              style: UIDataTextStyles.title13Normal
                                                  .copyWith(
                                                      fontWeight: FontWeight.w500),
                                            ),
                                            // Text( dateFormat(notification.notificationTime.toIso8601String())),
                                          ],
                                        ).paddingSymmetric(horizontal: 15))
                                    .marginOnly(bottom: 10);
                              })),
                          SpacingHeight.heightlistspacing50
                        ],
                      ).marginOnly(left: 20, right: 20),
                    ),
                  );
          },
        );
      }
    );
  }

  String dateFormat(String date) {
    var inputFormat = DateTime.parse(date);
    var outputFormat = DateFormat('hh:mm a yyyy/MM/dd');
    var outputDate = outputFormat.format(inputFormat);
    return outputDate;
  }

  hitAllApis() async {
    await Future.microtask(() => context.read<NotificationProvider>().onInit());
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
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
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
