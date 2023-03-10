import 'package:flutter/material.dart';

import '../../utils/routes/app_routes.dart';
import '../../utils/uidata.dart';
import 'package:get/get.dart';

class CustomFloat extends StatelessWidget {
  final IconData? icon;
  final Widget? builder;
  final VoidCallback? qrCallback;
  final isMini;

  CustomFloat({this.icon, this.builder, this.qrCallback, this.isMini = false});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      clipBehavior: Clip.antiAlias,
      mini: isMini,
      onPressed: qrCallback,
      backgroundColor: Colors.white,
      child: Ink(
        // decoration: new BoxDecoration(
        // gradient: new LinearGradient(colors: UIData.kitGradients)
        // ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Icon(
              icon,
              color: Get.currentRoute == Routes.addManualOrder
                  ? UIDataColors.fbbtnColor
                  : Colors.grey,
              size: 30,
            ),
            builder != null
                ? Positioned(right: 7.0, top: 7.0, child: Text("")
                    // CircleAvatar(
                    //   backgroundColor: Colors.red,
                    //   child: builder,
                    //   radius: 10.0,
                    // ),
                    )
                : Container(),
            // builder
          ],
        ),
      ),
    );
  }
}
