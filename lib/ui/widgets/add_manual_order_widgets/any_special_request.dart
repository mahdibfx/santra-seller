import 'package:flutter/material.dart';

import '../../../utils/uidata.dart';

class AnySpecialRequests extends StatelessWidget {
  var ontap;
  AnySpecialRequests({Key? key, required this.ontap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Any Special Requests?"),
        const Spacer(),
        GestureDetector(
          onTap: ontap,
          child: Text(
            "Add Note",
            style: TextStyle(
                color: UIDataColors.black,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }
}
