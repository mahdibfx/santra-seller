import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangaugeSettingsProvider with ChangeNotifier {
  bool isLoading = false;
  setTrue( String language)async{
    isLoading = true;
      notifyListeners();
      print(isLoading);
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
    isLoading = false;
    notifyListeners();
    // Get.back();
  }
}
