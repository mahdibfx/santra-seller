import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';

import '../../../ui/widgets/snackbar/common_snackbar.dart';
import '../../../utils/api_data.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata.dart';

class ContactUsController extends GetxController {
  bool isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  var phoneMask = MaskTextInputFormatter(
      mask: '971#########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  clearFieldsAfterSend() {
    usernameController.clear();
    emailController.clear();
    phonenumberController.clear();
    messageController.clear();
    update();
  }

  changeSendMsgLoadingState(value) {
    isLoading = value;
    update();
  }

  Future sendMessage() async {
    try {
      changeSendMsgLoadingState(true);

      var url = Uri.parse(ApiData.contactUsApi);
      Map<String, dynamic> body = {};
      body['full_name'] = usernameController.text;
      body['email_user'] = emailController.text;
      body['subject'] = phonenumberController.text;
      body['message'] = messageController.text;
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        CommonSnackbar.getSnackbar(
            "Success",
            "Your message has been delivered to Santra",
            UIDataColors.primaryColor);
        clearFieldsAfterSend();
        Get.offAllNamed(Routes.moreScreen);
      } else {
        CommonSnackbar.getSnackbar(
            "Failed", "Failed to send message", UIDataColors.primaryColor);
      }
    } catch (e) {
      generalException();
    }
    changeSendMsgLoadingState(false);
  }
}
