import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:santra_seller/utils/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController extends GetxController {
  var isLogoutLoading = false.obs;

  Future logout() async {
    isLogoutLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString('sellercode');
      String? fcmToken = prefs.getString('fcmtoken');
      var url = Uri.parse(ApiData.logoutApi);
      var request = http.MultipartRequest('POST', url);
      var body = <String, String>{};
      body['seller_code'] = sellerCode ?? "";
      body['gcms_code'] = fcmToken ?? "";
      request.fields.addAll(body);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        //@todo
        // prefs.clear();
        Get.offAllNamed(Routes.loginRoutes);
      } else {
        generalException();
        if (kDebugMode) {
          print("seller not logOut yet..");
        }
      }
    } catch (e) {
      generalException();
    }
    isLogoutLoading(false);
  }
}
