import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../api_data.dart';
import 'package:flutter/material.dart';


class AppTranslations extends GetxController  {
  static Map<String, Map<String, String>> _translations = {};
  String selectedLanguage = 'en_us';
  dynamic engLang;
  dynamic arabLang;

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

  setNewLanguage(String lang){
    selectedLanguage = lang;
    update();
    
  }
  setShared(String lang)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedlanguage",lang);
  }

  langNew() async {
    String newLnag = 'en_us';
    await language().then((value) {
      return value;
    });
    return newLnag;
  }

  fetchTranslationsv() async {
    var url = Uri.parse(ApiData.languageSelection);
    var response = await http.post(url, headers: ApiData.header);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      engLang = data['data'][0]['en_us'];
      // Map<String, String> convertedData = engLang.cast<String, String>();
      update();
      // _translations = {'en_us': convertedData};

      arabLang = data['data'][0]['ar_AE'];
      update();
      // Map<String, String> convertedDataArabic = arabLang.cast<String, String>();
      // _translations = {'en_us': convertedData, 'ar_AE': convertedDataArabic};
      // selectedLanguage = await language();
      // if (selectedLanguage != 'en_us') {
      //   Get.updateLocale(const Locale('ar', 'AE'));
      // }

      return _translations;
    } else {
      throw Exception('Failed to fetch translations');
    }
  }


  String translateData(String tralate){
    if(selectedLanguage == 'en_us'){
      return engLang[tralate];
    }
  return   arabLang[tralate];
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
