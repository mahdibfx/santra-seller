import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata.dart';

final tr = Get.put(AppTranslations());

class MyDropdown extends StatefulWidget {
  final List<String> options;
  String? selectedOption;
  var validator;
  String? prefixIcon;
  String? label;
  double? iconSize;

  var onChanged;
  MyDropdown(
      {super.key,
      required this.options,
      required this.selectedOption,
      required this.prefixIcon,
      this.label,
      this.validator,
      this.iconSize,
      this.onChanged});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: false,
      child: DropdownButtonFormField(
          isExpanded: true,
          validator: widget.validator,
          items: widget.options.map((String selOption) {
            return DropdownMenuItem(
                value: selOption,
                child: Text(
                  selOption,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: tr.getFont(),
                      letterSpacing: 0.0),
                ));
          }).toList(),
          onChanged: widget.onChanged,
          icon: Padding(
            padding: const EdgeInsets.only(right: 18.0),
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
                    height: widget.iconSize,
                    color: UIDataColors.blackText,
                  ).paddingSymmetric(vertical: widget.iconSize ?? 11))
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

class MBDropDown extends StatefulWidget {
  final List<String> options;
  String? selectedOption;
  var validator;
  String? prefixIcon;
  String? label;
  double? iconSize;

  var onChanged;
  MBDropDown(
      {super.key,
      required this.options,
      required this.selectedOption,
      required this.prefixIcon,
      this.label,
      this.validator,
      this.iconSize,
      this.onChanged});

  @override
  _MBDropDown createState() => _MBDropDown();
}

class _MBDropDown extends State<MBDropDown> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField(
          padding: EdgeInsets.zero,
          menuMaxHeight: 500,
          isDense: false,
          isExpanded: true,
          validator: widget.validator,
          items: widget.options.map((String selOption) {
            return DropdownMenuItem(
                value: selOption,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      selOption,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: tr.getFont(),
                          letterSpacing: 0.0),
                    ),
                    // if (selOption == widget.options[0])
                    //   const Divider(
                    //     color: UIDataColors.primaryColor,
                    //   )
                  ],
                ));
          }).toList(),
          onChanged: widget.onChanged,
          icon: Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: SvgPicture.asset(UIDATAIcons.arrowDown),
          ),
          value: widget.selectedOption ?? "",
          decoration: InputDecoration(
            // label: Text(
            //   widget.label ?? "",
            //   style: const TextStyle(color: Colors.black),
            // ),
            prefixIcon: widget.prefixIcon != null
                ? GestureDetector(
                    child: SvgPicture.asset(
                    widget.prefixIcon!,
                    height: widget.iconSize,
                    color: UIDataColors.blackText,
                  ).paddingSymmetric(vertical: widget.iconSize ?? 11))
                : null,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: UIDataColors.primaryColor.withOpacity(0.7),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: UIDataColors.primaryColor.withOpacity(0.7),
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
