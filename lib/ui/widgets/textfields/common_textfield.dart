// import 'package:ihprpm/utils/uidata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:santra_seller/utils/uidata.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import 'package:get/get.dart';


class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final validator;
  final String? labelText;
  final String? fieldHeading;
  final Color? fillcolor;
  final TextStyle ? textStyle;

  final Color? bordercolor;
  final bool? isTextHidden;
  final String? hintText;
  final IconData? buttonIcon;
  final IconData? prefixIcon;
  final bool? togglePassword;
  final int? maxLength;
  final int  ? maxlines ;
  final toggleFunction;
  final IconData? toggleIcon;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final onTap;
  final prefixIconTap;
  final onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focus;

  CommonTextField(

      {this.controller,
        this.textStyle,
        this.maxlines :1,
        this.validator,
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
        this.focus});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldHeading == null ? SizedBox() : Text(fieldHeading??''),
        SpacingHeight.heightlistspacing5,
        TextFormField(
          style: textStyle ?? null,

          onChanged: onChanged,
          inputFormatters: inputFormatters,
          obscureText: isTextHidden! ,
          readOnly: readOnly == null ? false : true,
          onTap: onTap,
          maxLength: maxLength ,
          focusNode: focus != null ? focus : null,
          keyboardType: keyboardType == null ? TextInputType.text : keyboardType,
          textInputAction: TextInputAction.done,
          maxLines: maxlines,

          decoration: InputDecoration(
            prefixIcon: prefixIcon != null
                ? GestureDetector(
              child: Icon(
                prefixIcon,
                color: Colors.black,
                size: 25.0,
              ),
              onTap: prefixIconTap,
            )
                : null,
            suffixIcon: togglePassword!
                ? GestureDetector(
                child: Icon(
                  toggleIcon,
                  color: Colors.black,
                ),
                onTap: toggleFunction)
                : null,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: bordercolor ?? Color(0xff757575).withOpacity(0.7),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: bordercolor ?? Color(0xff757575).withOpacity(0.7),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            hintText: hintText,
            fillColor: fillcolor ?? Color(0xff757575).withOpacity(0.7),
            filled: true,
            hintStyle:
            TextStyle(
                color: Color(0xff9EA0A4),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins-Regular',
                letterSpacing: 0.0),
            contentPadding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 18.0),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black, fontSize: 15.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
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
