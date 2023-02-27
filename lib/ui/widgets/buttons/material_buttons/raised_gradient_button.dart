import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RaisedGradientButton extends StatelessWidget {
  final String? btntxt;
  final Color? buttontxtColor;
  final Gradient? gradient;
  final double width;
  final double height;
  final onPressed;

  RaisedGradientButton({
    required this.btntxt,
    this.buttontxtColor,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                btntxt ?? "",
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: buttontxtColor != null ? buttontxtColor : Colors.white,
                ),
              ),
            )),
      ),
    );
  }
}
