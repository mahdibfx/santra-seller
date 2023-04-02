import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/login_model.dart';
import '../../models/notification/notification_model.dart';
import '../../ui/widgets/snackbar/common_snackbar.dart';
import '../../utils/api_data.dart';
import '../../utils/routes/app_routes.dart';
import '../../utils/uidata.dart';

class NotificationController extends GetxController {

  bool isLoading = false;
  var sellerCode = '';
  List<NotificationData> notificationList = [];
  List<OldNotification> oldNotifications = [];


  @override
  void onInit() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    var sellercod = prefs.getString("sellercode");
    if (sellercod != null) {
      sellerCode = sellercod;
    }
loginfunction();
    super.onInit();
    update();
  }

  
 


  void loginfunction() async {
    isLoading = true;
    update();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var body = <String, String>{};
      body['seller_code'] = sellerCode;
      var res =
          await http.post(Uri.parse("${ApiData.mainurl}all_notifications"), body: body);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        var newdata = NotificationModel.fromJson(data);
        notificationList =newdata.data;
        oldNotifications = notificationList[0].oldNotifications;
        update();
      
         isLoading = false;
      update();

      } else {
         isLoading = false;
      update();
        print(res.body);
        CommonSnackbar.getSnackbar(
            "Error", "Error ", UIDataColors.redColor);
      }
    } catch (e) {
      isLoading = false;
      update();

      CommonSnackbar.getSnackbar(
          "Server Error",
          "Server Error or Please Check your internet connection",
          UIDataColors.redColor);
    }

     isLoading = false;
      update();
  }

  
}
