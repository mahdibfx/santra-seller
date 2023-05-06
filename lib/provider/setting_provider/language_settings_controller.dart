import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangaugeSettingsProvider with ChangeNotifier {
  bool isLoadings = false;
 bool isCheckLanguage = false;
  setTrue( String language)async{
    isLoadings = true;
      notifyListeners();
      print(isLoadings);
    SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString("selectedlanguage", language);
                                  if(language == 'en_us'){
                                    Get.updateLocale(const Locale('en', 'us'));
                                  }else{
                                    Get.updateLocale(const Locale('ar', 'AE'));
                                  }
                                  
    notifyListeners();

  }
  setFalseValue(){
    isLoadings = false;
    notifyListeners();
    // Get.back();
  }
}
