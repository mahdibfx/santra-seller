import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api_data.dart';

class AppTranslations extends GetxController {
  static final Map<String, Map<String, String>> _translations = {};
  String selectedLanguage = 'en_us';
  dynamic engLang;
  dynamic arabLang;
  bool updateAvailable = false;

  Future<String> language() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var oldLang = prefs.get("selectedlanguage");
    if (oldLang != null) {
      selectedLanguage = prefs.get("selectedlanguage") as String;
      update();
      return selectedLanguage;
    }

    return 'en_us';
  }

  setNewLanguage(String lang) {
    selectedLanguage = lang;
    update();
  }

  setShared(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedlanguage", lang);
  }

  langNew() async {
    String newLnag = 'en_us';
    await language().then((value) {
      return value;
    });
    return newLnag;
  }

  fetchTranslationsv() async {
    // var url = Uri.parse(ApiData.languageSelection);
    var url = Uri.parse(ApiData.splashNew);
    Map<String, dynamic> body = {};
    body['version'] = "4.6.2";
    body['platform'] = Platform.isIOS ? "Mobile_App_iOS" : "Mobile_App_Android";
    var response = await http.post(url, headers: ApiData.header, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      engLang = data['data'][0]['en_us'];
      arabLang = data['data'][0]['ar_AE'];
      String msg = data['data'][0]['update_force'][0]['force_update'];
      update();
      if (msg == "no") {
        updateAvailable = false;
      } else if (msg == "yes") {
        updateAvailable = true;
      }
      update();
      return _translations;
    } else {
      throw Exception('Failed to fetch translations');
    }
  }

  String translateData(String tralate) {
    if (selectedLanguage == 'en_us') {
      return engLang[tralate] ?? tralate.replaceAll('_', " ");
    }
    return arabLang[tralate] ?? tralate.replaceAll("_", " ");
  }

  String getFont() {
    final langCode = Get.locale!.languageCode;
    if (langCode == 'en') {
      return "Markpro";
    } else {
      return "AktivGrotesk-Medium";
    }
  }
}
