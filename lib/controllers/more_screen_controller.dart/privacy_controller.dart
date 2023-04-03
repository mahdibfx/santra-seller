import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';

class PrivacyController extends GetxController {
  var isLoading = false.obs;
  bool hasError = false;
  var terms = ''.obs;

  Future termsAndCondition() async {
    try {
      isLoading(true);
      var url = Uri.parse(ApiData.termsAPi);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        terms.value = body["data"][0]['page_content'].toString();
        print(terms.value);
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
    termsAndCondition();
    update();
  }
}
