import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';
import '../../utils/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  bool isLoading = true;
  bool isOtpLoading = false;
  bool isResetPassLoading = false;
  bool currentPasswordSecuretext = true;
  bool newPasswordSecuretext = true;
  bool confirmPasswordSecuretext = true;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? otpCode;
  String? sellerCode;
  updateOtpLoadingState(bool value) {
    isOtpLoading = value;
    update();
  }

  updateResetPassLoadingState(bool value) {
    isResetPassLoading = value;
    update();
  }

  disposeValues() {
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    otpController.clear();
    phoneController.clear();
    otpCode = null;
    sellerCode = null;

    update();
  }

  Future confirmSellerAndGetOtp() async {
    try {
      updateOtpLoadingState(true);
      var url = Uri.parse(ApiData.verifyResetPassword);
      var request = http.MultipartRequest('POST', url);
      var body = <String, String>{};
      body['user_number'] = phoneController.text.toString();
      request.fields.addAll(body);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        otpCode = data['data'][0]['otp_code'].toString();
        sellerCode = data['data'][0]['seller_code'].toString();
        // showTimer.value = true;
        // Timer(const Duration(seconds: 30), () {
        //   showTimer.value = false;
        // });
        if (kDebugMode) {
          print(sellerCode);
          print(otpCode);
        }
        Get.toNamed(Routes.forgotPasswordConfirmation);
      } else {
        var data = jsonDecode(response.body);

        String failedMsg = data['data']['message'].toString();
        exceptionDialog("Failed", failedMsg);
      }
    } catch (err) {
      generalException();
    }
    updateOtpLoadingState(false);
  }

  Future resetPassword() async {
    try {
      updateResetPassLoadingState(true);

      var url = Uri.parse(ApiData.resetPasswordApi);
      var request = http.MultipartRequest('POST', url);
      var body = <String, String>{};
      body['seller_code'] = sellerCode ?? "";
      body['new_password'] = newPasswordController.text;
      request.fields.addAll(body);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        print(response.body);
        customOntapDialog(
            "Success", "You Password Has Been Successfully Updated!", "Okay",
            () {
          disposeValues();
          Get.back();
          Get.offNamed(Routes.loginRoutes);
        });
      } else {
        customOntapDialog("Failed", "Failed to update password", "Okay", () {
          Get.back();
        });
      }
    } catch (err) {
      generalException();
    }

    updateResetPassLoadingState(false);
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }
}
