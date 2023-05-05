import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';

class AccountInfoProvider extends ChangeNotifier {
  var isUpdateAccInfoLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  final form = GlobalKey<FormState>();
  String? email;
  String? firstName;
  String? lastName;
  var phoneMask = MaskTextInputFormatter(
      mask: '971#########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  DateTime? userDob;
  changeLoadingState(val) {
    isUpdateAccInfoLoading = val;
    notifyListeners();
  }

  Future pickUserDob(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2023),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null) {
      userDob = picked;
      // date = DateFormat('yyyy-MM-dd').format(userDob!);
      // if (kDebugMode) {
      //   print(formatteUserDob.toString());
      // }
    }
    notifyListeners();
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
      userDob = date;
    }
    notifyListeners();
  }

  setValuesAfterUpdating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", emailController.text);
    prefs.setString("firstname", fNameController.text);
    prefs.setString("lastname", lNameController.text);
    prefs.setString("dob", userDob.toString());
    notifyListeners();
  }

  Future updateAccountInfo() async {
    if (form.currentState!.validate()) {
      try {
        changeLoadingState(true);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? sellerCode = prefs.getString("sellercode");
        var url = Uri.parse(ApiData.updateaAccountInfoApi);
        var request = http.MultipartRequest('POST', url);
        var body = <String, String>{};
        body['seller_code'] = sellerCode ?? "";
        body['first_name'] = fNameController.text;
        body['last_name'] = lNameController.text;
        body['user_email'] = emailController.text;
        body['date_of_birth'] = "";
        request.fields.addAll(body);
        request.headers.addAll(ApiData.header);
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200) {
          setValuesAfterUpdating();
          customOntapDialog("Success",
              "account_updated".tr, "okay".tr, () {
            Get.back();
            Get.back();
            // Get.offNamed(Routes.settings);
          });
        } else {
          customOntapDialog("Failed", "failed_update_account".tr, "okay".tr,
              () {
            Get.back();
          });
        }
      } catch (err) {
        generalException();
      }
    }
    changeLoadingState(false);
    notifyListeners();
  }

  void onInit() async {
    getAccountInfoFromSPAndSaveInController();
    notifyListeners();
  }
}
