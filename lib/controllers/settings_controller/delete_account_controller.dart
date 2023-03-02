import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logout_controller.dart';

class DeleteAccountController extends GetxController {
  final logoutController = Get.put(LogoutController());
  var isdelAccLoading = false.obs;

  Future deleteAccount() async {
    isdelAccLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiData.deleteAccountApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString('sellercode');
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        logoutController.logout();
      } else {
        generalException();
      }
    } catch (e) {
      generalException();

      if (kDebugMode) {
        print("Delete Seller ISSUE$e");
      }
    }
    isdelAccLoading(false);
  }
}
