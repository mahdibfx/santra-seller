import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordProvider with ChangeNotifier {
  bool isUpdatePassLoading = false;
  bool currentPasswordSecuretext = true;
  bool newPasswordSecuretext = true;
  bool confirmPasswordSecuretext = true;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final form = GlobalKey<FormState>();
  changeUpdatePassLoadingState(value) {
    isUpdatePassLoading = value;
    notifyListeners();
  }

  resetControllers() {
    confirmNewPasswordController.clear();
    newPasswordController.clear();
    currentPasswordController.clear();
    notifyListeners();
  }

  Future updatePassword() async {
    if (form.currentState!.validate()) {
      if (newPasswordController.text != confirmNewPasswordController.text) {
        exceptionDialog("no_match".tr,
            "enter_same_password".tr);
      } else {
        try {
          changeUpdatePassLoadingState(true);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? sellerCode = prefs.getString("sellercode");

          var url = Uri.parse(ApiData.updatePasswordApi);
          var request = http.MultipartRequest('POST', url);
          var body = <String, String>{};
          body['seller_code'] = sellerCode ?? "";
          body['current_password'] = currentPasswordController.text;
          body['new_password'] = newPasswordController.text;
          request.fields.addAll(body);
          request.headers.addAll(ApiData.header);
          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);
          if (response.statusCode == 200) {
            customOntapDialog("Success",
                "You Password Has Been Successfully Updated!", "Okay", () {
              resetControllers();
              Get.back();
              Get.back();
              // Get.offNamed(Routes.settings);
            });
          } else {
            customOntapDialog("Failed", "Failed to update password", "Okay",
                () {
              Get.back();
            });
          }
        } catch (err) {
          generalException();
        }
      }
    }
    changeUpdatePassLoadingState(false);
    notifyListeners();
  }
}
