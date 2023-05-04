import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:santra_seller/ui/screens/settings/delete_account_confirmation.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountProvider with ChangeNotifier {
  String? phoneNumber;
  TextEditingController explainationController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isdelAccLoading = false;
  bool isOtpLoading = false;
  String? otpCode;
  final form = GlobalKey<FormState>();
  final formDeleteAccScreen1 = GlobalKey<FormState>();
  var phoneMask = MaskTextInputFormatter(
      mask: '971#########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  updateOtpLoadingState(bool value) {
    isOtpLoading = value;
    notifyListeners();
  }

  updateDelAccState(bool value) {
    isdelAccLoading = value;
    notifyListeners();
  }

  getPhoneFromSp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var phone = preferences.getString("phonenumber");
    phoneController.text = phone!;
    notifyListeners();
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
        request.headers.addAll(ApiData.header);
        var streamedResponse = await request.send();
        print(phoneController.text);
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
          Get.to(() => DeleteAccountConfirmation());
          //  Get.toNamed(Routes.deleteAccountConfirmation);
        } else {
          exceptionDialog(
              "oops_message".tr, "went_wrong_while".tr);
          print(response.body);
        }
      } catch (err) {
        print(err);
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
        var response =
            await http.post(url, headers: ApiData.header, body: body);
        if (response.statusCode == 200) {
        } else {
          print(response.body);
          generalException();
        }
      } catch (e) {
        print(e);
        generalException();

        if (kDebugMode) {
          print("Delete Seller ISSUE$e");
        }
      }
      updateDelAccState(false);
    }
  }

  void deleteAccountonInit() {
    getPhoneFromSp();
    notifyListeners();
  }
}
