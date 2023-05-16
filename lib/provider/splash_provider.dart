import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/auth_screen/login_screen.dart';
import 'package:santra_seller/ui/screens/home_page/home_screen.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../ui/widgets/dialogs/custom_dialogs.dart';
import '../ui/widgets/snackbar/common_snackbar.dart';
import '../utils/app_translation/app_translation.dart';
import '../utils/uidata.dart';
import 'language_provider/language_provider.dart';

class SplashProvider extends ChangeNotifier {
     var tr = Get.put(AppTranslations());
  

  bool isLoading = false;
  bool updateAvailable = false;
  String? sellerCode;
  bool isHome = true;
  bool isMore = false;

  onHomeScreen() {
    isHome = true;
    isMore = false;
    notifyListeners();
  }

  onMoreScreen() {
    isHome = false;
    // isMore = true;
    notifyListeners();
  }

  homeAndMoreScreenOff() {
    isHome = false;
    isMore = false;
    notifyListeners();
  }

  String language = "en_us";
  final Uri link = Uri.parse('https://onelink.to/xbwv9t');

  setLoadingState(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setOldLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var checkLang = prefs.get("selectedlanguage");
    if (checkLang != null) {
      language = prefs.get("selectedlanguage") as String;
      notifyListeners();
    } else {
      language = 'en_us';
      notifyListeners();
    }

    notifyListeners();
  }

  setLanguage(String languages) {
    language = languages;
    notifyListeners();
  }

  void checkUpdateAndMakeDescision() async {

    isInternetAvailable();
    //  tr.fetchTranslationsv();
    forceUpdate().then((value) {
      if (updateAvailable == true) {
        customOntapDialog(
            tr.translateData("New Update"), tr.translateData("update_message_popup"), tr.translateData("update_message"),
            () {
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

  Future<bool> isInternetAvailable() async {
    var tr = Get.put(AppTranslations());
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http.get(Uri.parse('https://google.com'));
        return response.statusCode == HttpStatus.ok;
      }
    } on SocketException catch (_) {
      CommonSnackbar.getSnackbar("Error",
          "Internet is not available ", UIDataColors.redColor);
      return false;
    }
    return false;
  }

  Future<void> goToStore() async {
    if (!await launchUrl(link)) {
      throw 'Could not launch $link';
    }
  }

  checkAlreadyLogin() async {
     await tr.fetchTranslationsv();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var checkemail = prefs.getString("email");
    sellerCode = prefs.getString("sellercode");
    // var languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    // languageProvider.languageTextCall();
    print("SELLER $sellerCode");
    // var checkpassword = prefs.getString("password");
    if (checkemail != null) {
      Future.delayed(const Duration(seconds: 0),
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
    var tr = Get.put(AppTranslations());
    try {
      setLoadingState(true);

      var url = Uri.parse(ApiData.forceUpdateApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = "1";
      body['version'] = "4.0.0";
      body['app_type'] = "seller";
      body['platform'] =
          Platform.isIOS ? "Mobile_App_iOS" : "Mobile_App_Android";
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        setLoadingState(false);
        var data = jsonDecode(response.body);

        var msg = data['data'][0]['force_update'].toString();

        if (msg == "no") {
          updateAvailable = false;
        } else if (msg == "yes") {
          updateAvailable = true;
        }
      } else {
        setLoadingState(false);
        Get.snackbar(tr.translateData("oops_message"), tr.translateData("something_wrong_message"));
      }
    } catch (e) {
      setLoadingState(false);
      Get.snackbar(tr.translateData("oops_message"), tr.translateData("something_wrong_message"));
    }
    notifyListeners();
  }
}
