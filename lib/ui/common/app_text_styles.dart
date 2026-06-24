import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Locale-aware typography.
///
/// EN → Fraunces (display / headings) + Inter (body).
/// AR → IBM Plex Sans Arabic (both display and body).
/// Mirrors the design's `--font-display` / `--font-body` CSS variables.
class AppTextStyles {
  AppTextStyles._();

  static bool _isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  /// Display / heading face (serif in EN, Arabic sans in AR).
  static TextStyle display(
    BuildContext context, {
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.ink,
    double? height,
    double? letterSpacing,
  }) {
    final arabic = _isArabic(context);
    final base = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      // Arabic headings read better without negative tracking.
      letterSpacing: arabic ? 0 : letterSpacing,
    );
    return arabic
        ? GoogleFonts.ibmPlexSansArabic(textStyle: base)
        : GoogleFonts.fraunces(textStyle: base);
  }

  /// Body / UI face (Inter in EN, Arabic sans in AR).
  static TextStyle body(
    BuildContext context, {
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.ink,
    double? height,
    double? letterSpacing,
  }) {
    final arabic = _isArabic(context);
    final base = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: arabic ? 0 : letterSpacing,
    );
    return arabic
        ? GoogleFonts.ibmPlexSansArabic(textStyle: base)
        : GoogleFonts.inter(textStyle: base);
  }
}
