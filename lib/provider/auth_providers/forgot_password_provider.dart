import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/auth_screen/login_screen.dart';
import 'package:santra_seller/ui/screens/auth_screen/reset_password_confirmation.dart';
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';
import '../../utils/app_translation/app_translation.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final BuildContext context;

  ForgotPasswordProvider(this.context);

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
  var phoneMask = MaskTextInputFormatter(
      mask: '971#########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  updateOtpLoadingState(bool value) {
    isOtpLoading = value;
    notifyListeners();
  }

  updateResetPassLoadingState(bool value) {
    isResetPassLoading = value;
    notifyListeners();
  }

  disposeValues() {
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    otpController.clear();
    phoneController.clear();
    otpCode = null;
    sellerCode = null;

    notifyListeners();
  }

  Future confirmSellerAndGetOtp() async {
    var tr = Provider.of<AppTranslations>(context, listen: false);
    try {
      updateOtpLoadingState(true);
      var url = Uri.parse(ApiData.verifyResetPassword);
      var request = http.MultipartRequest('POST', url);
      var body = <String, String>{};
      body['user_number'] = phoneController.text.toString();
      request.fields.addAll(body);
      request.headers.addAll(ApiData.header);
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
        Get.to(() => ForgotPasswordConfirmation());
        // Get.toNamed(Routes.forgotPasswordConfirmation);
      } else {
        var data = jsonDecode(response.body);

        String failedMsg = data['data']['message'].toString();
        exceptionDialog(tr.translateData("failed_message"), failedMsg);
      }
    } catch (err) {
      generalException();
    }
    updateOtpLoadingState(false);
  }

  Future resetPassword() async {
    var tr = Provider.of<AppTranslations>(context, listen: false);
    try {
      updateResetPassLoadingState(true);

      var url = Uri.parse(ApiData.resetPasswordApi);
      var request = http.MultipartRequest('POST', url);
      var body = <String, String>{};
      body['seller_code'] = sellerCode ?? "";
      body['new_password'] = newPasswordController.text;
      request.fields.addAll(body);
      request.headers.addAll(ApiData.header);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        print(response.body);
        customOntapDialog(
            tr.translateData("success_message"), tr.translateData("password_updated"), tr.translateData("okay"),
            () {
          disposeValues();
          Get.back();
          Get.offAll(const LoginScreen());
          // Get.offNamed(Routes.loginRoutes);
        });
      } else {
        customOntapDialog(tr.translateData("failed_message"), tr.translateData("failed_update_password"), tr.translateData("okay"), () {
          Get.back();
        });
      }
    } catch (err) {
      generalException();
    }

    updateResetPassLoadingState(false);
    notifyListeners();
  }
}
