import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';

class AboutUsProvider with ChangeNotifier {
  bool isLoading = false;
  bool hasAboutUsError = false;
  String? aboutUsText;
  updateLoadingState(bool value) {
    isLoading = value;
    notifyListeners();
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

        aboutUsText = data['data'][0]['page_content'].toString();
      } else {
        generalException();
      }
    } catch (err) {
      generalException();
    }

    updateLoadingState(false);
    notifyListeners();
  }

  void aboutUsOnInit() async {
    aboutUs();
    notifyListeners();
  }
}
