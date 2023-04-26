import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class MyDropdown extends StatefulWidget {
  final List<String> options;
  String? selectedOption;
  var validator;
  String? prefixIcon;
  String? label;

  var onChanged;
  MyDropdown(
      {super.key,
      required this.options,
      required this.selectedOption,
      required this.prefixIcon,
      this.label,
      this.validator,
      this.onChanged});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField(
          isExpanded: true,
          validator: widget.validator,
          items: widget.options.map((String selOption) {
            return DropdownMenuItem(
                value: selOption,
                child: Text(
                  selOption,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Markpro',
                      letterSpacing: 0.0),
                ));
          }).toList(),
          onChanged: widget.onChanged,
          icon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SvgPicture.asset(UIDATAIcons.arrowDown),
          ),
          value: widget.selectedOption ?? "",
          decoration: InputDecoration(
            label: Text(
              widget.label ?? "",
              style: const TextStyle(color: Colors.black),
            ),
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
          )),
    );
  }
}
