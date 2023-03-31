import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/uidata.dart';

class MyDropdown extends StatefulWidget {
  final List<String> options;
  String? selectedOption;
  var validator;
  String? prefixIcon;
  MyDropdown(
      {super.key,
      required this.options,
      required this.selectedOption,
      required this.prefixIcon,
      this.validator});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        validator: widget.validator,
        items: widget.options.map((String selOption) {
          return DropdownMenuItem(
              value: selOption,
              child: Text(
                selOption,
              ));
        }).toList(),
        onChanged: (newValue) {
          // do other stuff with _category
          setState(() => widget.selectedOption = newValue);
        },
        value: widget.selectedOption ?? "City",
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon != null
              ? GestureDetector(
                  child: SvgPicture.asset(
                  widget.prefixIcon!,
                  color: UIDataColors.blackText,
                ).paddingSymmetric(vertical: 11))
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xff757575).withOpacity(0.7),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xff757575).withOpacity(0.7),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          contentPadding: const EdgeInsets.only(left: 10),
          filled: true,
          fillColor: Colors.white,
        ));
  }
}
