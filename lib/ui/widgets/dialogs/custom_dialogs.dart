import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';

generalException() {
  Get.dialog(CupertinoAlertDialog(
      title:  Text(
        "oops_message".tr,
        style: UIDataTextStyles.dialogTitle,
      ),
      content: Column(
        children:  [
          Text(
            "unknown_error".tr,
            style: UIDataTextStyles.dialogMsg,
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child:  Text(
              "okay".tr,
              style: UIDataTextStyles.dialogButton,
            )),
      ]));
}

exceptionDialog(String title, String msg) {
  return Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      title: title.capitalize!,
      middleText: msg.capitalize!,
      backgroundColor: Colors.white,
      titleStyle: UIDataTextStyles.dialogTitle,
      middleTextStyle: UIDataTextStyles.dialogMsg,
      radius: 15,
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child:  Text("okay".tr, style: UIDataTextStyles.dialogButton))
      ]);
}

customOntapDialog(String title, String msg, buttonTitle, var ontap) {
  return Get.defaultDialog(
      barrierDismissible: false,
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      title: title.capitalize!,
      middleText: msg.capitalize!,
      backgroundColor: Colors.white,
      titleStyle: UIDataTextStyles.dialogTitle,
      middleTextStyle: UIDataTextStyles.dialogMsg,
      radius: 15,
      actions: [
        TextButton(
            onPressed: ontap,
            child: Text(buttonTitle, style: UIDataTextStyles.dialogButton))
      ]);
}

customOntapDialogTwoButtons(BuildContext context, String title, String msg,
    buttonTitle1, buttonTitle2, var ontap, var ontap2) {
  return showCupertinoModalPopup<void>(
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title, style: UIDataTextStyles.dialogTitle),
      content: Text(
        msg.capitalize!,
        style: UIDataTextStyles.dialogMsg,
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: ontap,
          child: Text(buttonTitle1, style: UIDataTextStyles.dialogButton),
        ),
        CupertinoDialogAction(
          onPressed: ontap2,
          child: Text(buttonTitle2, style: UIDataTextStyles.dialogButton),
        ),
      ],
    ),
  );
}

customOntapDialogSingleButtons(
  BuildContext context,
  String title,
  String msg,
  buttonTitle1,
  var ontap,
) {
  return showCupertinoModalPopup<void>(
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title, style: UIDataTextStyles.dialogTitle),
      content: Text(
        msg.capitalize!,
        style: UIDataTextStyles.dialogMsg,
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: ontap,
          child: Text(
            buttonTitle1,
            style: UIDataTextStyles.dialogButton,
          ),
        ),
      ],
    ),
  );
}
