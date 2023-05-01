import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../api_data.dart';
import 'package:flutter/material.dart';

class AppTranslations extends Translations {
  Map<String, Map<String, String>> _translations = {};
  String? selectedLanguage;

  Future<String> language() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var selectedlanguage = prefs.get("selectedlanguage") as String;
    return selectedlanguage;
  }

  Future<bool> fetchTranslations() async {
    var url = Uri.parse(ApiData.languageSelection);
    var response = await http.post(url, headers: ApiData.header);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final languageDataEngDynamic = data['data'][0]['en_us'];
      Map<String, String> convertedData =
          languageDataEngDynamic.cast<String, String>();
      _translations = {'en_us': convertedData};

      final languageDataArabicDynamic = data['data'][0]['ar_AE'];
      Map<String, String> convertedDataArabic =
          languageDataArabicDynamic.cast<String, String>();
      _translations = {'en_us': convertedData, 'ar_AE': convertedDataArabic};
      print(_translations);
      selectedLanguage = await language();
      if (selectedLanguage != 'en_us') {
        Get.updateLocale(const Locale('ar', 'AE'));
      }

      return true;
    } else {
      throw Exception('Failed to fetch translations');
    }
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;
}
