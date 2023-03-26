import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';
import 'package:intl/intl.dart';

class AccountInfoController extends GetxController {
  var isUpdateAccInfoLoading = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  final form = GlobalKey<FormState>();
  String? email;
  String? firstName;
  String? lastName;
  RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  DateTime? userDob;

  var formatteUserDob;

  Future pickUserDob(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2023),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null) {
      userDob = picked;
      formatteUserDob = DateFormat('yyyy-MM-dd').format(userDob!);
      if (kDebugMode) {
        print(formatteUserDob.toString());
      }
    }
    update();
  }

  Future getAccountInfoFromSPAndSaveInController() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString("email");
    firstName = preferences.getString("firstname");
    lastName = preferences.getString("lastname");
    var date = DateTime.parse(preferences.getString("dob").toString());

    userDob = date;
    if (email != null &&
        firstName != null &&
        lastName != null &&
        userDob != null) {
      emailController.text = email!;
      fNameController.text = firstName!;
      lNameController.text = lastName!;
      formatteUserDob = userDob;
    }
    update();
  }

  setValuesAfterUpdating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", emailController.text);
    prefs.setString("firstname", fNameController.text);
    prefs.setString("lastname", lNameController.text);
    prefs.setString("dob", formatteUserDob.toString());
    update();
  }

  Future updateAccountInfo() async {
    if (form.currentState!.validate()) {
      try {
        isUpdateAccInfoLoading(true);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? sellerCode = prefs.getString("sellercode");
        var url = Uri.parse(ApiData.updateaAccountInfoApi);
        var request = http.MultipartRequest('POST', url);
        var body = <String, String>{};
        body['seller_code'] = sellerCode ?? "";
        body['first_name'] = fNameController.text;
        body['last_name'] = lNameController.text;
        body['user_email'] = emailController.text;
        body['date_of_birth'] = formatteUserDob.toString();
        request.fields.addAll(body);
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200) {
          setValuesAfterUpdating();
          customOntapDialog("Success",
              "You Account Info Has Been Successfully Updated!", "Okay", () {
            Get.back();
            Get.back();
            // Get.offNamed(Routes.settings);
          });
        } else {
          customOntapDialog("Failed", "Failed to update account info", "Okay",
              () {
            Get.back();
          });
        }
      } catch (err) {
        generalException();
      }
    }
    isUpdateAccInfoLoading(false);
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    getAccountInfoFromSPAndSaveInController();
    update();
  }
}
