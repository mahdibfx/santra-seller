// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:santra_seller/utils/api_data.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../ui/widgets/dialogs/custom_dialogs.dart';
// import 'package:http/http.dart' as http;

// class ChangeEmailController extends GetxController {
//   bool securetext = true;
//   var isUpdateEmailLoading = false.obs;
//   TextEditingController currentEmailController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController confirmeEmailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   String? currentEmail;
//   final form = GlobalKey<FormState>();
//   RegExp emailRegex = RegExp(
//     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
//   );
//   Future getCurrentEmail() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     currentEmail = preferences.getString("userEmail");

//     if (currentEmail != null) {
//       currentEmailController.text = currentEmail!;
//     }
//     update();
//   }

//   Future updateEmail() async {
//     if (form.currentState!.validate()) {
//       if (emailController.text != confirmeEmailController.text) {
//         exceptionDialog("No Match!",
//             "Please Enter Same Email in new email and confirm email fields");
//       } else {
//         try {
//           isUpdateEmailLoading(true);
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           String? sellerCode = prefs.getString("sellercode");

//           var url = Uri.parse(ApiData.updateaEmail);
//           var request = http.MultipartRequest('POST', url);
//           var body = <String, String>{};
//           body['seller_code'] = sellerCode ?? "";
//           body['user_email'] = emailController.text;
//           body['user_password'] = passwordController.text;
//           request.fields.addAll(body);
//           request.headers.addAll(ApiData.header);
//           var streamedResponse = await request.send();
//           var response = await http.Response.fromStream(streamedResponse);
//           if (response.statusCode == 200) {
//             customOntapDialog(
//                 "Success", "You email Has Been Successfully Updated!", "Okay",
//                 () {
//               Get.back();
//               Get.back();
//               // Get.offNamed(Routes.settings);
//             });
//           } else {
//             customOntapDialog("Failed", "Failed to update email", "Okay", () {
//               Get.back();
//             });
//           }
//         } catch (err) {
//           generalException();
//         }
//       }
//     }
//     isUpdateEmailLoading(false);
//     update();
//   }

//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     getCurrentEmail();
//   }
// }
