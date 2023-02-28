import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInfoController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  final form = GlobalKey<FormState>();
  String? email;
  String? firstName;
  String? lastName;
  String? dob;
  RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  Future getAccountInfoFromSPAndSaveInController() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString("email");
    firstName = preferences.getString("firstname");
    lastName = preferences.getString("lastname");
    dob = preferences.getString("dob");
    if (email != null && firstName != null && lastName != null && dob != null) {
      emailController.text = email!;
      fNameController.text = firstName!;
      lNameController.text = lastName!;
      dobController.text = dob!;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    getAccountInfoFromSPAndSaveInController();
    update();
  }
}
