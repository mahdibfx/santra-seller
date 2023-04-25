// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:santra_seller/controllers/auth_controller/signup_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../models/login_model.dart';
// import '../../ui/screens/home_page/home_screen.dart';
// import '../../ui/widgets/snackbar/common_snackbar.dart';
// import '../../utils/api_data.dart';
// import '../../utils/routes/app_routes.dart';
// import '../../utils/uidata.dart';

// class LoginController extends GetxController {
//   // bool isLoading = true;
//   // SignUpController signUpController = Get.put(SignUpController());
//   bool isLoading = false;
//   bool securetext = true;
//   bool remember = false;
//   bool isvisible = true;
//   var roleset;
//   var sellerStatus;
//   String emailstore = "";
//   String passwordstore = "";

//   List locale = [];
//   List userprofilelist = [];

//   //     Services
//   updateLoginLoadingStatus(bool value) {
//     isLoading = value;
//     update();
//   }

//   var userToken;
//   var eaToken;
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   TextEditingController rememberselect = TextEditingController();

//   RegExp emailRegex = RegExp(
//     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
//   );
//   String? firebaseMessagingToken;

//   @override
//   void onInit() async {
//     getFcmToken();
//     setLoginValues();
//     super.onInit();

//     update();
//   }

//   setLoginValues() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var checkemail = prefs.getString("email");
//     var checkpassword = prefs.getString("password");
//     if (checkemail != null || checkpassword != null) {
//       email.text = checkemail!;
//       password.text = checkpassword!;
//     }
//     update();
//   }

//   void updatelang(Locale locale) {
//     Get.back();
//     Get.updateLocale(locale);
//   }

//   Future getFcmToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     firebaseMessagingToken = await FirebaseMessaging.instance.getToken();
//     update();
//     prefs.setString('fcmtoken', firebaseMessagingToken.toString());
//     print("token: $firebaseMessagingToken");
//   }

//   void loginfunction() async {
//     updateLoginLoadingStatus(true);
//     update();
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var body = <String, String>{};
//       body['user_name'] = email.text;
//       body['user_password'] = password.text;
//       body["gcms_code"] = firebaseMessagingToken.toString();
//       var res = await http.post(Uri.parse("${ApiData.mainurl}login"),
//           headers: ApiData.header, body: body);
//       if (res.statusCode == 200) {
//         var data = jsonDecode(res.body);
//         var newdata = LoginModel.fromJson(data);
//         sellerStatus = newdata.data[0].message.toString();
//         print(newdata);
//         GetStorage().write('sellerStatus', sellerStatus);

//         await saveSharedPrefData(newdata.data[0], prefs);
//         Get.offAll(() => HomeScreen());
//       } else {
//         update();
//         print(res.body);
//         CommonSnackbar.getSnackbar(
//             "Error", "Error in login", UIDataColors.redColor);
//       }
//     } catch (e) {
//       update();

//       CommonSnackbar.getSnackbar(
//           "Server Error",
//           "Server Error or Please Check your internet connection",
//           UIDataColors.redColor);
//     }

//     updateLoginLoadingStatus(false);
//   }

//   saveSharedPrefData(LoginData data, SharedPreferences prefs) {
//     prefs.setString("email", email.text);
//     prefs.setString("userEmail", data.userEmail);
//     prefs.setString("firstname", data.firstName);
//     prefs.setString("lastname", data.lastName);
//     prefs.setString("phonenumber", data.phoneNumber);
//     prefs.setString("gender", data.userGender);
//     prefs.setString("logo", data.sellerLogo);
//     prefs.setString("sellercode", data.sellerCode);
//     prefs.setString("status", data.userStatus);
//     prefs.setString("sellercity", data.userCountry);
//     prefs.setString("dob", data.dateOfBirth.toString());
//     prefs.setString("password", password.text);
//     prefs.setString("sellerStatus", data.message);
//   }

//   Future<String> sellerSt() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     sellerStatus = prefs.get('sellerStatus');

//     return sellerStatus.toString();
//   }
// }
