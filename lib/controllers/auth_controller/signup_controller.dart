import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/widgets/snackbar/common_snackbar.dart';
import '../../utils/api_data.dart';
import '../../utils/routes/app_routes.dart';
import '../../utils/uidata.dart';

class SignUpController extends GetxController {
  bool isLoading = false;
  String? firebaseMessagingToken;
  bool passwordSecuretext = true;
  bool confirmPasswordSecuretext = true;
  updateLoginLoadingStatus(bool value) {
    isLoading = value;
    update();
  }

  bool isAgree = false;
  changeIsAgree(bool value) {
    isAgree = value;
    update();
  }

  Future getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firebaseMessagingToken = await FirebaseMessaging.instance.getToken();
    update();
    prefs.setString('fcmtoken', firebaseMessagingToken.toString());
    print("token: $firebaseMessagingToken");
  }

  bool securetext = true;
  bool isvisible = true;
  List<String> citiesList = [];

  final form = GlobalKey<FormState>();
  List locale = [];
  String? sellerCity = "Dubai";
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
    update();
  }

  @override
  void onInit() async {
    locale = [
      {'name': 'English', 'locale': const Locale("en", "US")},
      {'name': 'عربي', 'locale': const Locale("ar", "SA")}
    ];
    super.onInit();
    getFcmToken();

    update();
  }

  Future getCities() async {
    try {
      var url = Uri.parse(ApiData.getCities);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body["data"] as List<dynamic>;
        citiesList = data
            .map((d) => (d as Map<String, dynamic>)["city_name"].toString())
            .toList();
        print(citiesList);
      } else {
        CommonSnackbar.getSnackbar(
            "Failed", "Unable to load cities list", UIDataColors.redColor);
      }
    } catch (e) {
      CommonSnackbar.getSnackbar("Error",
          "Error while loading data, Please try again", UIDataColors.redColor);
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
        body['gcms_code'] = prefs.getString("fcmToken").toString();
        request.fields.addAll(body);
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200) {
          CommonSnackbar.getSnackbar("Success", "Account has been registered",
              UIDataColors.primaryColor);
          Get.offAllNamed(Routes.loginRoutes);
        } else {
          update();
          CommonSnackbar.getSnackbar(
              "Error",
              "Error while signing up, Please try again",
              UIDataColors.redColor);
        }
      } catch (e) {
        isLoading = false;
        update();

        CommonSnackbar.getSnackbar(
            "Server Error",
            "Server Error or Please Check your internet connection",
            UIDataColors.redColor);
      }
    }
    updateLoginLoadingStatus(false);
  }
}
