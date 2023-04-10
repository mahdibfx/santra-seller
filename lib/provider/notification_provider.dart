import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/widgets/snackbar/common_snackbar.dart';
import '../../utils/api_data.dart';
import '../../utils/uidata.dart';
import '../models/notification/notification_model.dart';

class NotificationProvider extends ChangeNotifier {

  bool isLoading = false;
  var sellerCode = '';
  List<Notifications> notificationList = [];
  List<Notifications> oldNotifications = [];

   onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sellercod = prefs.getString("sellercode");
    if (sellercod != null) {
      sellerCode = sellercod;
    }
    loginfunction();
    notifyListeners();
  }

  
 


  void loginfunction() async {
    isLoading = true;
    notifyListeners();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var body = <String, String>{};
      body['seller_code'] = sellerCode;
      var res =
          await http.post(Uri.parse("${ApiData.mainurl}all_notifications"), body: body);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        var newdata = NotificationModel.fromJson(data);
        var notificationData  =newdata.data;
        notificationList = notificationData[0].newNotifications;
        oldNotifications = notificationData[0].oldNotifications;
        notifyListeners();
      
         isLoading = false;
      notifyListeners();

      } else {
         isLoading = false;
      notifyListeners();
        print(res.body);
        CommonSnackbar.getSnackbar(
            "Error", "Error ", UIDataColors.redColor);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();

      CommonSnackbar.getSnackbar(
          "Server Error",
          "Server Error or Please Check your internet connection",
          UIDataColors.redColor);
    }

     isLoading = false;
      notifyListeners();
  }

  
}
