import 'package:flutter/material.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';

import '../../controllers/auth_controller/login_controller.dart';
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
      onPressed:  qrCallback,
      backgroundColor: UIDataColors.primaryColor,
      child: Ink(
        // decoration: new BoxDecoration(
        // gradient: new LinearGradient(colors: UIData.kitGradients)
        // ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
              size: 40,
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
