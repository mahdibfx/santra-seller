import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/routes/app_routes.dart';
import 'logout_controller.dart';

class DeleteAccountController extends GetxController {
  final logoutController = Get.put(LogoutController());
  String? phoneNumber;
  TextEditingController explainationController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController phoneController = TextEditingController(text: "971");
  bool isdelAccLoading = false;
  bool isOtpLoading = false;
  String? otpCode;
  final form = GlobalKey<FormState>();
  final formDeleteAccScreen1 = GlobalKey<FormState>();
  updateOtpLoadingState(bool value) {
    isOtpLoading = value;
    update();
  }

  updateDelAccState(bool value) {
    isdelAccLoading = value;
    update();
  }

  Future getOtp() async {
    if (formDeleteAccScreen1.currentState!.validate()) {
      try {
        updateOtpLoadingState(true);
        var url = Uri.parse(ApiData.getOtp);
        var request = http.MultipartRequest('POST', url);
        var body = <String, String>{};
        body['user_number'] = phoneController.text.toString();
        request.fields.addAll(body);
        var streamedResponse = await request.send();

        var response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200) {
          print(phoneController.text);
          var data = jsonDecode(response.body);
          otpCode = data['data'][0]['otp_code'].toString();
          // showTimer.value = true;
          // Timer(const Duration(seconds: 30), () {
          //   showTimer.value = false;
          // });
          if (kDebugMode) {
            print(otpCode);
          }
          Get.toNamed(Routes.deleteAccountConfirmation);
        } else {
          exceptionDialog(
              "Oops", "Something went wrong, you may try again in a while");
        }
      } catch (err) {
        generalException();
      }
      updateOtpLoadingState(false);
    }
  }

  Future deleteAccount() async {
    if (form.currentState!.validate()) {
      updateDelAccState(true);
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var url = Uri.parse(ApiData.deleteAccountApi);
        Map<String, dynamic> body = {};
        body['seller_code'] = prefs.getString('sellercode');
        body['phone'] = phoneController.text.toString();
        body['explaination'] = explainationController.text.toString();
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
      updateDelAccState(false);
    }
  }
}
