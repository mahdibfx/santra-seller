import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import 'package:http/http.dart' as http;

import '../../utils/app_translation/app_translation.dart';

class ChangeEmailProvider extends ChangeNotifier {
    final BuildContext context;

  ChangeEmailProvider(this.context);

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
       var tr = Provider.of<AppTranslations>(context, listen: false);
    if (form.currentState!.validate()) {
      if (emailController.text != confirmeEmailController.text) {
        exceptionDialog(tr.translateData("no_match"),
            tr.translateData("same_email_message"));
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
                tr.translateData("success_message"), tr.translateData("updated_email"), tr.translateData("okay"),
                () {
              Get.back();
              Get.back();
              // Get.offNamed(Routes.settings);
            });
          } else {
            customOntapDialog(tr.translateData("failed_message"), tr.translateData("failed_update_email"), tr.translateData("okay"), () {
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
