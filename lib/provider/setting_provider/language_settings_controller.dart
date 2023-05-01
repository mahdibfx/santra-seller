import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LangaugeSettingsProvider with ChangeNotifier {
  bool isLoading = false;
  setTrue(){
    isLoading = true;
    notifyListeners();
  }
  setFalseValue(){
    isLoading = false;
    notifyListeners();
  }
}
