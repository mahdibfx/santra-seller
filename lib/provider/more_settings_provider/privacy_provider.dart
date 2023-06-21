import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';

class PrivacyProvider with ChangeNotifier {
  bool isTnCLoading = false;
  bool hasError = false;
  String terms = "Loading T&Cs";
  bool isPrivacyLoading = false;
  bool hasPrivacyError = false;
  String msg = "Loading...";
  updatePrivacyLoadingStatus(val) {
    isPrivacyLoading = val;
    notifyListeners();
  }

  updateTnCLoadingStatus(val) {
    isTnCLoading = val;
    notifyListeners();
  }

  Future privacyPolicy() async {
    try {
      updatePrivacyLoadingStatus(true);
      var url = Uri.parse(ApiData.privacyApi);
      var response = await http.get(url, headers: ApiData.header);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        msg = data['data'][0]['page_content'].toString();
        if (kDebugMode) {
          print(response.body);
          print(msg);
        }
      } else {
        exceptionDialog("Oops", "Something went wrong!");
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      exceptionDialog("Oops", "Something went wrong!");
    }
    updatePrivacyLoadingStatus(false);
    notifyListeners();
  }

  Future termsAndCondition() async {
    try {
      updateTnCLoadingStatus(true);

      var url = Uri.parse(ApiData.termsAPi);
      final response = await http.get(url, headers: ApiData.header);

      if (response.statusCode == 200) {
        hasError = false;
        final body = jsonDecode(response.body);
        terms = body["data"][0]['page_content'].toString();
        print(terms);
      } else {
        hasError = true;
      }
    } catch (e) {
      generalException();
    }
    updateTnCLoadingStatus(false);
    notifyListeners();
  }
}
