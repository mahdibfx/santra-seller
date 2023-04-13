import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';

class AboutUsController extends GetxController {
  bool isLoading = false;
  bool hasAboutUsError = false;
  String? aboutUsText;
  updateLoadingState(bool value) {
    isLoading = value;
    update();
  }

  Future aboutUs() async {
    try {
      updateLoadingState(true);

      var url = Uri.parse(ApiData.aboutUsApi);
      var request = http.MultipartRequest('GET', url);
      request.headers.addAll(ApiData.header);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        print(data);
        aboutUsText = data['data'][0]['page_content'].toString();
        print(aboutUsText);
      } else {
        generalException();
      }
    } catch (err) {
      generalException();
    }

    updateLoadingState(false);
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    aboutUs();
    update();
  }
}
