import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import 'app_icon.dart';

/// Product/reference thumbnail. Renders a remote image when [path] is a URL,
/// otherwise a branded placeholder (the design's local `assets/*.jpg` product
/// images aren't in the repo yet — drop them in and this resolves them).
class ThumbImage extends StatelessWidget {
  const ThumbImage({
    super.key,
    required this.path,
    required this.size,
    this.radius = 12,
    this.iconName = 'image',
  });

  final String path;
  final double size;
  final double radius;
  final String iconName;

  bool get _isNetwork => path.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.brandSofter,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.line),
      ),
      child: Center(child: AppIcon(iconName, size: size * 0.42, color: AppColors.brand)),
    );

    if (!_isNetwork) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
      ),
    );
  }
}
