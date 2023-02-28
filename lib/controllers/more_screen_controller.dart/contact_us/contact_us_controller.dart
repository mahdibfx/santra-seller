import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../../../ui/widgets/snackbar/common_snackbar.dart';
import '../../../utils/api_data.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata.dart';

class ContactUsController extends GetxController {
  RxBool isLoading = false.obs;
  // bool isLoading = true;
  bool securetext = true;
  bool remember = false;
  bool isvisible = true;

  var roleset;

  final form = GlobalKey<FormState>();

  List locale = [];

  List userprofilelist = [];

  //     Services

  var userToken;
  var eaToken;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  @override
  void onInit() async {
    locale = [
      {'name': 'English', 'locale': Locale("en", "US")},
      {'name': 'عربي', 'locale': Locale("ar", "SA")}
    ];
    super.onInit();
  }

  @override
  void onReady() async {
    // await checkfunction();
    // loginfunction();
    // getrole();

    isLoading = false.obs;
    update();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void updatelang(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  Future<void> signupMethod() async {
    if (form.currentState!.validate()) {
      isLoading = true.obs;
      update();
      try {
        Map<String, String> header = {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
          // 'Content-Type': 'application/json; charset=UTF-8',
        };
        final msg = jsonEncode({
          'username': username.text,
          "email": email.text,
          "phone_number": phonenumber.text,
          "address": address.text,
        });
        print(msg);
        var res = await http.post(
          Uri.parse("${ApiData.mainurl}register/"),
          body: msg,
          headers: header,
        );
        print(res.statusCode);
        print("user data $msg");
        var data = json.decode(res.body);
        print(data);

        isLoading = true.obs;
        update();
        if (res.statusCode == 200) {
          if ((data["success"] == true &&
              data["message"] == "User has been Successfully created!")) {
            Get.offAllNamed(Routes.loginRoutes);
            CommonSnackbar.getSnackbar("Message",
                "User has been Successfully created!", UIDataColors.blue);
          } else if (data["success"] == false &&
              data["message"] == "Error in register!") {
            CommonSnackbar.getSnackbar(
                "Message", "Error in register!", UIDataColors.red);

            isLoading = false.obs;
            update();
            return;
          } else if (data["success"] == false &&
              data["message"] == "Passwords do NOT match!") {
            CommonSnackbar.getSnackbar(
                "Message", "Passwords do NOT match!", UIDataColors.red);

            isLoading = false.obs;
            update();
            return;
          }
        } else if (res.statusCode == 400) {
          var username =
              data["username"] == "Username already taken try another!.";
          var useremail =
              data['email'] == "A user with that Email already exists.";

          print(useremail);

          if (username == false || useremail == false) {
            CommonSnackbar.getSnackbar("Message", "$data", UIDataColors.red);
            isLoading = false.obs;
            update();
            return;
          }
        }
      } catch (e) {
        print("check error ${e}");

        CommonSnackbar.getSnackbar(
            "Server Error", e.toString(), UIDataColors.red);

        isLoading = false.obs;
        update();
        return;
      }
    }
  }
}
