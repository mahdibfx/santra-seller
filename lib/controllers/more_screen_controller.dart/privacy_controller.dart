import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/routes/app_routes.dart';
import '../../utils/api_data.dart';

class PrivacyController extends GetxController {
  var isLoading = false.obs;
  bool hasError = false;
  var terms = ''.obs;
  bool isPrivacyLoading = false;
  bool hasPrivacyError = false;
  var msg = "Loading...".obs;
  updatePrivacyLoadingStatus(val) {
    isPrivacyLoading = val;
    update();
  }

  Future privacyPolicy() async {
    try {
      updatePrivacyLoadingStatus(true);
      var url = Uri.parse(ApiData.privacyApi);
      var response = await http.get(url, headers: ApiData.header);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        msg.value = data['data'][0]['page_content'].toString();
        if (kDebugMode) {
          print(response.body);
          print(msg);
        }
      } else {
        exceptionDialog("Oops", "Something went wrong!");
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      exceptionDialog("Oops", "Something went wrong!");
    }
    updatePrivacyLoadingStatus(false);
  }

  Future termsAndCondition() async {
    try {
      isLoading(true);
      var url = Uri.parse(ApiData.termsAPi);
      final response = await http.get(url, headers: ApiData.header);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        terms.value = body["data"][0]['page_content'].toString();
      } else {
        hasError = true;
      }
    } catch (e) {
      generalException();
    }
    isLoading(false);
  }

  @override
  void onInit() async {
    super.onInit();
    if (Get.currentRoute == Routes.signuproutes) {
      termsAndCondition();
    }

    if (Get.currentRoute == Routes.privacy) {
      privacyPolicy();
    }
    update();
  }
}
