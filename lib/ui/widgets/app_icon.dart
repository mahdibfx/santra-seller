import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/app_colors.dart';
import '../common/app_icon_data.dart';

/// Renders one of the design's line icons by [name] (see `kIconSvg`).
/// Tints the whole glyph via a srcIn color filter.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size = 22,
    this.color = AppColors.ink,
    this.flipForRtl = false,
  });

  final String name;
  final double size;
  final Color color;

  /// Mirror horizontally in RTL (chevrons, arrows, send).
  final bool flipForRtl;

  @override
  Widget build(BuildContext context) {
    final svg = kIconSvg[name];
    if (svg == null) {
      return SizedBox(width: size, height: size);
    }
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final picture = SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
    if (flipForRtl && rtl) {
      return Transform.flip(flipX: true, child: picture);
    }
    return picture;
  }
}
