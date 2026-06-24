import 'package:flutter/material.dart';

import 'icon_square_button.dart';

/// Back button + optional trailing widget. Used on auth + detail screens.
class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.onBack, this.right});

  final VoidCallback onBack;
  final Widget? right;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconSquareButton(iconName: 'chevronLeft', onTap: onBack, flipForRtl: true),
          right ?? const SizedBox(width: 44),
        ],
      ),
    );
  }
}
