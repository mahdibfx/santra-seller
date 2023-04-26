import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordProvider with ChangeNotifier {
  bool isUpdatePassLoading = false;
  bool currentPasswordSecuretext = true;
  bool newPasswordSecuretext = true;
  bool confirmPasswordSecuretext = true;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final form = GlobalKey<FormState>();
  changeUpdatePassLoadingState(value) {
    isUpdatePassLoading = value;
    notifyListeners();
  }

  resetControllers() {}
  Future updatePassword() async {
    if (form.currentState!.validate()) {
      if (newPasswordController.text != confirmNewPasswordController.text) {
        exceptionDialog("No Match!",
            "Please Enter Same Password in new password and confirm new password");
      } else {
        try {
          changeUpdatePassLoadingState(true);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? sellerCode = prefs.getString("sellercode");

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
            customOntapDialog("Success",
                "You Password Has Been Successfully Updated!", "Okay", () {
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
