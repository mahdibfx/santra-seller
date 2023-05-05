import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import 'package:http/http.dart' as http;

class ChangeEmailProvider extends ChangeNotifier {
  bool securetext = true;
  var isUpdateEmailLoading = false;
  TextEditingController currentEmailController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmeEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? currentEmail;
  final form = GlobalKey<FormState>();
  RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  Future getCurrentEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentEmail = preferences.getString("userEmail");

    if (currentEmail != null) {
      currentEmailController.text = currentEmail!;
    }
    notifyListeners();
  }

  Future updateEmail() async {
    if (form.currentState!.validate()) {
      if (emailController.text != confirmeEmailController.text) {
        exceptionDialog("no_match".tr,
            "same_email_message".tr);
      } else {
        try {
          isUpdateEmailLoading = true;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? sellerCode = prefs.getString("sellercode");

          var url = Uri.parse(ApiData.updateaEmail);
          var request = http.MultipartRequest('POST', url);
          var body = <String, String>{};
          body['seller_code'] = sellerCode ?? "";
          body['user_email'] = emailController.text;
          body['user_password'] = passwordController.text;
          request.fields.addAll(body);
          request.headers.addAll(ApiData.header);
          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);
          if (response.statusCode == 200) {
            customOntapDialog(
                "success_message".tr, "updated_email".tr, "okay".tr,
                () {
              Get.back();
              Get.back();
              // Get.offNamed(Routes.settings);
            });
          } else {
            customOntapDialog("failed_message".tr, "failed_update_email".tr, "okay".tr, () {
              Get.back();
            });
          }
        } catch (err) {
          generalException();
        }
      }
    }
    isUpdateEmailLoading = false;
    notifyListeners();
  }

  void onInit() {
    getCurrentEmail();
    notifyListeners();
  }
}
