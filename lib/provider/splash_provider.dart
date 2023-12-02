import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santra_seller/provider/apps_flyr/appflyer_controller.dart';
import 'package:santra_seller/provider/firebase_events/firebase_events.dart';
import 'package:santra_seller/ui/screens/auth_screen/login_screen.dart';
import 'package:santra_seller/ui/screens/home_page/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../ui/widgets/dialogs/custom_dialogs.dart';
import '../ui/widgets/snackbar/common_snackbar.dart';
import '../utils/app_translation/app_translation.dart';
import '../utils/uidata.dart';

class SplashProvider extends ChangeNotifier {
  var tr = Get.put(AppTranslations());
  FirebaseAnalyticsController firebaseAnalytics =
      Get.put(FirebaseAnalyticsController());
  AppFlyerController afController = Get.put(AppFlyerController());

  bool isLoading = false;

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

  String _authStatus = 'Unknown';

  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    _authStatus = '$status';
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      _authStatus = '$status';
    }
    //final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
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
    // await appFlyerController.appflyerLogs();
    await checkInstallFirsTime();
    notifyListeners();
  }

  checkInstallFirsTime() async {
    await Future.delayed(const Duration(seconds: 3), () => initPlugin());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    afController.appflyerLogs();
    if (firstTime == null) {
      // first time
      await firebaseAnalytics.firebaseAppInstallEvent();
      await firebaseAnalytics.firebaseFirstAppOpenEvent();
      prefs.setBool('first_time', false);
    }
  }

  setLanguage(String languages) {
    language = languages;
    notifyListeners();
  }

  void checkUpdateAndMakeDescision() async {
    isInternetAvailable();
    await tr.fetchTranslationsv();
    if (tr.updateAvailable == true) {
      customOntapDialog(
          tr.translateData("new_update"),
          tr.translateData("update_message_popup"),
          tr.translateData("update_message"), () {
        goToStore();
      });
    } else {
      checkAlreadyLogin();
    }
    // forceUpdate().then((value) {
    //   if (updateAvailable == true) {
    //     customOntapDialog(
    //         tr.translateData("new_update"),
    //         tr.translateData("update_message_popup"),
    //         tr.translateData("update_message"), () {
    //       goToStore();
    //     });
    //   } else {
    //     checkAlreadyLogin();
    //   }
    // });
    // Future.delayed(const Duration(seconds: 3), () {
    //   checkAlreadyLogin();
    // });
    // update();
    // super.onInit();
  }

  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http.get(Uri.parse('https://google.com'));
        return response.statusCode == HttpStatus.ok;
      }
    } on SocketException catch (_) {
      CommonSnackbar.getSnackbar(
          "Error", "Internet is not available ", UIDataColors.redColor);
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

  // Future forceUpdate() async {
  //   var tr = Get.put(AppTranslations());
  //   try {
  //     setLoadingState(true);
  //     var url = Uri.parse(ApiData.splashNew);
  //     Map<String, dynamic> body = {};
  //     body['version'] = "4.1.7";
  //     body['platform'] =
  //         Platform.isIOS ? "Mobile_App_iOS" : "Mobile_App_Android";
  //     var response = await http.post(url, headers: ApiData.header, body: body);
  //     if (response.statusCode == 200) {
  //       setLoadingState(false);
  //       var data = jsonDecode(response.body);
  // var msg = data['data'][0]['force_update'].toString();
  // if (msg == "no") {
  //   updateAvailable = false;
  // } else if (msg == "yes") {
  //   updateAvailable = true;
  // }
  //     } else {
  //       setLoadingState(false);
  //       Get.snackbar(tr.translateData("oops_message"),
  //           tr.translateData("something_wrong_message"));
  //     }
  //   } catch (e) {
  //     setLoadingState(false);
  //     Get.snackbar(tr.translateData("oops_message"),
  //         tr.translateData("something_wrong_message"));
  //   }
  //   notifyListeners();
  // }
}
