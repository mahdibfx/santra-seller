import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangaugeSettingsProvider with ChangeNotifier {
  bool isLoadings = false;
  setTrue() async {
    isLoadings = true;
    notifyListeners();
  }

  setLanguage(String language) async {
    setTrue();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedlanguage", language);
    if (language == 'en_us') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('ar', 'AE'));
    }
    setFalseValue();
    notifyListeners();
  }

  setFalseValue() {
    isLoadings = false;
    notifyListeners();
    // Get.back();
  }
}
