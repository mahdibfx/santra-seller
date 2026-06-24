import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import 'app_icon.dart';

/// 44×44 rounded-square surface button with an icon (back, bell, lang toggle).
/// Optionally shows a small unread dot.
class IconSquareButton extends StatelessWidget {
  const IconSquareButton({
    super.key,
    required this.iconName,
    required this.onTap,
    this.iconColor = AppColors.ink,
    this.size = 44,
    this.radius = 14,
    this.flipForRtl = false,
    this.showDot = false,
    this.label,
  });

  final String iconName;
  final VoidCallback onTap;
  final Color iconColor;
  final double size;
  final double radius;
  final bool flipForRtl;
  final bool showDot;

  /// When set, renders this text instead of an icon (used for the "ع/EN" toggle).
  final String? label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.line, width: 1.5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (label != null)
              Text(label!,
                  style: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.w700, fontSize: 13))
            else
              AppIcon(iconName, size: 21, color: iconColor, flipForRtl: flipForRtl),
            if (showDot)
              Positioned(
                top: 11,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.unreadDot,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
