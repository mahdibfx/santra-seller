import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/auth_screen/login_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/more_screen.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/widgets/snackbar/common_snackbar.dart';
import '../../utils/api_data.dart';
import '../../utils/app_translation/app_translation.dart';
import '../../utils/uidata.dart';

class ContactUsProvider with ChangeNotifier {
  final BuildContext context;

  ContactUsProvider(this.context);

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
    notifyListeners();
  }

  changeSendMsgLoadingState(value) {
    isLoading = value;
    notifyListeners();
  }

  Future sendMessage() async {
       var tr = Provider.of<AppTranslations>(context, listen: false);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      changeSendMsgLoadingState(true);

      var url = Uri.parse(ApiData.contactUsApi);
      Map<String, dynamic> body = {};
      body['full_name'] = usernameController.text;
      body['email_user'] = emailController.text;
      body['subject'] = phonenumberController.text;
      body['message'] = messageController.text;
      var response = await http.post(url, body: body, headers: ApiData.header);
      if (response.statusCode == 200) {
        CommonSnackbar.getSnackbar(
            tr.translateData("success_message"),
            tr.translateData("message_delivered"),
            UIDataColors.primaryColor);
        clearFieldsAfterSend();

        if (prefs.getString("sellercode") == null) {
          Get.offAll(const LoginScreen());
        } else {
          Get.offAll(() => MoreSettingScreen());
        }
        // Get.back();
        // Get.back();
      } else {
        CommonSnackbar.getSnackbar(
            "Failed", "Failed to send message", UIDataColors.primaryColor);
      }
    } catch (e) {
      generalException();
    }
    changeSendMsgLoadingState(false);
    notifyListeners();
  }
}
