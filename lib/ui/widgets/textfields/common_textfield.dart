// import 'package:ihprpm/utils/uidata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import 'package:get/get.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final validator;
  final String? labelText;
  final String? fieldHeading;
  final Color? fillcolor;
  final TextStyle? textStyle;

  final Color? bordercolor;
  final bool? isTextHidden;
  final String? hintText;
  final IconData? buttonIcon;
  final String? prefixIcon;
  final bool? togglePassword;
  final int? maxLength;
  final int? maxlines;
  final toggleFunction;
  final String? toggleIcon;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final String? initVal;
  final onTap;
  final prefixIconTap;
  final onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focus;
  final TextInputAction? textInputAction;

  CommonTextField(
      {this.controller,
      this.textStyle,
      this.maxlines: 1,
      this.validator,
      this.initVal,
      this.bordercolor,
      this.labelText,
      this.fillcolor,
      this.hintText,
      this.isTextHidden,
      this.buttonIcon,
      this.prefixIcon,
      this.onChanged,
      this.togglePassword = false,
      this.toggleFunction,
      this.toggleIcon,
      this.keyboardType,
      this.maxLength,
      this.readOnly,
      this.onTap,
      this.inputFormatters,
      this.prefixIconTap,
      this.fieldHeading,
      this.textInputAction,
      this.focus});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldHeading == null ? const SizedBox() : Text(fieldHeading ?? ''),
        SpacingHeight.heightlistspacing5,
        TextFormField(
          style:  TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: tr.getFont(),
              letterSpacing: 0.0),
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          obscureText: isTextHidden!,
          readOnly: readOnly == null ? false : true,
          onTap: onTap,
          maxLength: maxLength,
          focusNode: focus != null ? focus : null,
          keyboardType:
              keyboardType == null ? TextInputType.text : keyboardType,
          textInputAction: textInputAction?? TextInputAction.done,
          maxLines: maxlines,
          initialValue: initVal,
          decoration: InputDecoration(
            counterText: "",
            prefixIcon: prefixIcon != null
                ? GestureDetector(
                    onTap: prefixIconTap,
                    child: SvgPicture.asset(
                      prefixIcon!,
                      color: UIDataColors.blackText,
                    ).paddingSymmetric(vertical: 11))
                : null,
            suffixIcon: togglePassword!
                ? GestureDetector(
                    onTap: toggleFunction,
                    child: SvgPicture.asset(
                      toggleIcon ?? "",
                      color: UIDataColors.blackText,
                    ).paddingSymmetric(vertical: 11, horizontal: 11))

                // GestureDetector(
                //     child: Icon(
                //       toggleIcon,
                //       color: Colors.black,
                //     ),
                //     onTap: toggleFunction)
                : null,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: bordercolor ?? const Color(0xff757575).withOpacity(0.7),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: bordercolor ?? const Color(0xff757575).withOpacity(0.7),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            hintText: hintText,
            fillColor: fillcolor ?? const Color(0xff757575).withOpacity(0.7),
            filled: true,
            hintStyle:  TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: tr.getFont(),
                letterSpacing: 0.0),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 11.0, horizontal: 18.0),
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black, fontSize: 15.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
          ),
          controller: controller,
          validator: validator,
        ),
      ],
    ).marginOnly(bottom: 10);
  }
}
