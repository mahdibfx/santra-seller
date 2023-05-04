import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:santra_seller/ui/screens/auth_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ui/widgets/snackbar/common_snackbar.dart';
import '../../../utils/api_data.dart';

import '../../../utils/uidata.dart';

class SignUpProvider extends ChangeNotifier {
  bool isLoading = false;
  String? firebaseMessagingToken;
  bool passwordSecuretext = true;
  bool confirmPasswordSecuretext = true;
  updateLoginLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }

  bool isAgree = false;
  changeIsAgree(bool value) {
    isAgree = value;
    notifyListeners();
  }

  Future getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firebaseMessagingToken = await FirebaseMessaging.instance.getToken();
    notifyListeners();
    prefs.setString('fcmtoken', firebaseMessagingToken.toString());
    print("token: $firebaseMessagingToken");
  }

  bool securetext = true;
  bool isvisible = true;
  List<String> citiesList = [];

  final form = GlobalKey<FormState>();
  List locale = [];
  String? sellerCity = "Dubai";
  var phoneMask = MaskTextInputFormatter(
      mask: '971#########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  TextEditingController businessController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  clearValuesAfterSignup() {
    businessController.clear();
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    conformPasswordController.clear();
    addressController.clear();
    sellerCity = "Dubai";
    notifyListeners();
  }

  void signUpProviderOnInit() async {
    locale = [
      {'name': 'English', 'locale': const Locale("en", "US")},
      {'name': 'عربي', 'locale': const Locale("ar", "SA")}
    ];
    await getFcmToken();
    await getCities();

    notifyListeners();
  }

  Future getCities() async {
    try {
      var url = Uri.parse(ApiData.getCities);
      final response = await http.get(url, headers: ApiData.header);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body["data"] as List<dynamic>;
        citiesList = data
            .map((d) => (d as Map<String, dynamic>)["city_name"].toString())
            .toList();
        notifyListeners();
        print(citiesList);
      } else {
        CommonSnackbar.getSnackbar(
            "oops_message".tr, "error_load_data".tr, UIDataColors.redColor);
      }
    } catch (e) {
      CommonSnackbar.getSnackbar("oops_message".tr,
          "error_load_data".tr, UIDataColors.redColor);
    }
  }

  Future<void> signupMethod() async {
    if (form.currentState!.validate()) {
      updateLoginLoadingStatus(true);

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var url = Uri.parse(ApiData.registerSellerApi);
        var request = http.MultipartRequest('POST', url);
        var body = <String, String>{};
        body['business_name'] = businessController.text;
        body['full_name'] = fullNameController.text;
        body['seller_email'] = emailController.text;
        body['user_password'] = passwordController.text;
        body['user_number'] = phoneController.text;
        body['seller_city'] = sellerCity ?? "";
        body['seller_address'] = addressController.text;
        body['gcms_code'] = firebaseMessagingToken.toString();
        request.fields.addAll(body);
        request.headers.addAll(ApiData.header);
        print(body);
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        var data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          CommonSnackbar.getSnackbar("Success", "Account has been registered",
              UIDataColors.primaryColor);
          clearValuesAfterSignup();
          Get.offAll(() => const LoginScreen());
        } else if (response.statusCode == 430) {
          CommonSnackbar.getSnackbar(
              "oops_message".tr, "alread_registered".tr, UIDataColors.primaryColor);
        } else {
          notifyListeners();
          CommonSnackbar.getSnackbar(
              "error_message".tr,
              "something_wrong_message".tr,
              UIDataColors.redColor);
        }
      } catch (e) {
        isLoading = false;
        notifyListeners();

        CommonSnackbar.getSnackbar(
            "error_message".tr,
            "something_wrong_message".tr,
            UIDataColors.redColor);
      }
    }
    updateLoginLoadingStatus(false);
  }
}
