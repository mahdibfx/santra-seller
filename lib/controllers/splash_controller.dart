import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/ui/screens/auth_screen/login_screen.dart';
import 'package:santra_seller/ui/screens/home_page/home_screen.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../ui/widgets/dialogs/custom_dialogs.dart';

class SplashProvider extends ChangeNotifier {
  bool isLoading = false;
  bool updateAvailable = false;
  String? sellerCode;
  final Uri link = Uri.parse('https://onelink.to/xbwv9t');
  setLoadingState(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void checkUpdateAndMakeDescision() async {
    forceUpdate().then((value) {
      if (updateAvailable == true) {
        customOntapDialog(
            "New Update",
            "New critical update available, please update before you continue",
            "Update", () {
          goToStore();
        });
      } else {
        checkAlreadyLogin();
      }
    });
    // Future.delayed(const Duration(seconds: 3), () {
    //   checkAlreadyLogin();
    // });
    // update();
    // super.onInit();
  }

  Future<void> goToStore() async {
    if (!await launchUrl(link)) {
      throw 'Could not launch $link';
    }
  }

  checkAlreadyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var checkemail = prefs.getString("email");
    sellerCode = prefs.getString("sellercode");

    print("SELLER $sellerCode");
    // var checkpassword = prefs.getString("password");
    if (checkemail != null) {
      Future.delayed(const Duration(seconds: 1),
          () => Get.offAll(() => const HomeScreen()));
      // Get.offAndToNamed(Routes.loginRoutes);
    } else {
      Get.offAll(() => const LoginScreen());
    }
    notifyListeners();
  }

  void flushSplashData() {
    sellerCode = null;
    notifyListeners();
  }

  Future forceUpdate() async {
    try {
      setLoadingState(true);

      var url = Uri.parse(ApiData.forceUpdateApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = "1";
      body['version'] = "3.3.7";
      body['app_type'] = "seller";
      body['platform'] =
          Platform.isIOS ? "Mobile_App_iOS" : "Mobile_App_Android";
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        print(body);
        setLoadingState(false);
        var data = jsonDecode(response.body);

        var msg = data['data'][0]['force_update'].toString();
        print(response.body);
        if (msg == "no") {
          updateAvailable = false;
        } else if (msg == "yes") {
          updateAvailable = true;
        }
      } else {
        setLoadingState(false);
        Get.snackbar("Oops", "Something went wrong!");
      }
    } catch (e) {
      setLoadingState(false);
      Get.snackbar("Oops",
          "Something went wrong!, Please Check Your Internet Connection");
    }
    notifyListeners();
  }
}
