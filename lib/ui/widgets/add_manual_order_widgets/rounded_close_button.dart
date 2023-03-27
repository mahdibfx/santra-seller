import 'package:flutter/material.dart';

class RoundedCloseButton extends StatelessWidget {
  var onTap;
  RoundedCloseButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4), shape: BoxShape.circle),
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
