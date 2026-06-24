import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';

/// The project's single text primitive. Use a named factory — never a raw
/// `Text` with hardcoded font/size/weight. `display: true` selects the serif
/// (Arabic sans in AR); otherwise the body face.
class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w500,
    this.color = AppColors.ink,
    this.display = false,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final bool display;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  // ── Named factories ───────────────────────────────────────────────
  factory AppText.displayLarge(String data, {Color color = AppColors.ink, double fontSize = 32, TextAlign? textAlign, double? height}) =>
      AppText(data, display: true, fontSize: fontSize, fontWeight: FontWeight.w600, color: color, letterSpacing: -0.5, textAlign: textAlign, height: height);

  factory AppText.display(String data, {Color color = AppColors.ink, double fontSize = 24, FontWeight fontWeight = FontWeight.w600, TextAlign? textAlign}) =>
      AppText(data, display: true, fontSize: fontSize, fontWeight: fontWeight, color: color, textAlign: textAlign);

  factory AppText.title(String data, {Color color = AppColors.ink, double fontSize = 17, FontWeight fontWeight = FontWeight.w600, int? maxLines, TextOverflow? overflow}) =>
      AppText(data, fontSize: fontSize, fontWeight: fontWeight, color: color, maxLines: maxLines, overflow: overflow);

  factory AppText.body(String data, {Color color = AppColors.ink, double fontSize = 15, FontWeight fontWeight = FontWeight.w500, double height = 1.5, TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) =>
      AppText(data, fontSize: fontSize, fontWeight: fontWeight, color: color, height: height, textAlign: textAlign, maxLines: maxLines, overflow: overflow);

  factory AppText.caption(String data, {Color color = AppColors.muted, double fontSize = 13, FontWeight fontWeight = FontWeight.w600, TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) =>
      AppText(data, fontSize: fontSize, fontWeight: fontWeight, color: color, textAlign: textAlign, maxLines: maxLines, overflow: overflow);

  factory AppText.label(String data, {Color color = AppColors.faint, double fontSize = 12.5, double letterSpacing = 0.6}) =>
      AppText(data, fontSize: fontSize, fontWeight: FontWeight.w700, color: color, letterSpacing: letterSpacing);

  @override
  Widget build(BuildContext context) {
    final style = display
        ? AppTextStyles.display(context, fontSize: fontSize, fontWeight: fontWeight, color: color, height: height, letterSpacing: letterSpacing)
        : AppTextStyles.body(context, fontSize: fontSize, fontWeight: fontWeight, color: color, height: height, letterSpacing: letterSpacing);
    return Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
