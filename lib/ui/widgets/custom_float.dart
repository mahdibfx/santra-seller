import 'package:flutter/material.dart';
import '../../utils/uidata.dart';

class CustomFloat extends StatelessWidget {
  final IconData? icon;
  final Widget? builder;
  final VoidCallback? qrCallback;
  final isMini;

  const CustomFloat(
      {super.key,
      this.icon,
      this.builder,
      this.qrCallback,
      this.isMini = false});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      mini: isMini,
      onPressed: qrCallback,
      shape: const RoundedRectangleBorder(
        // <= Change BeveledRectangleBorder to RoundedRectangularBorder
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      backgroundColor: UIDataColors.primaryColor,
      child: Ink(
        // decoration: new BoxDecoration(shape: BoxShape.circle
        // gradient: new LinearGradient(colors: Colors.black)
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
                ? const Positioned(right: 7.0, top: 7.0, child: Text("")
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
