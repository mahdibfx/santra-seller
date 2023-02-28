import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import 'common_textfield.dart';

class AccountInfoTextFields extends StatelessWidget {
  String title;
  var infoController;
  String hint;
  TextEditingController controller;
  String validatorText;
  AccountInfoTextFields(
      {Key? key,
      required this.infoController,
      required this.hint,
      required this.title,
      required this.controller,
      required this.validatorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: UIDataTextStyles.heading15Medium),
        const SizedBox(
          height: 5,
        ),
        CommonTextField(
          controller: controller,
          hintText: hint.tr,
          isTextHidden: false,
          maxLength: 12,
          fillcolor: UIDataColors.white,
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            bool email = infoController.emailRegex.hasMatch(val);
            if (val.isEmpty) {
              return validatorText;
            } else if (controller == infoController.emailController && !email) {
              return "please enter valid email address";
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}
