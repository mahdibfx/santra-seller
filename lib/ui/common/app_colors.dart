import 'package:flutter/material.dart';

/// Santra Sellers palette — teal brand on cream.
/// Values come straight from the design's CSS custom properties + `data.jsx`.
class AppColors {
  AppColors._();

  // ── Brand / surfaces ──────────────────────────────────────────────
  static const Color brand = Color(0xFF136163);
  static const Color brandBright = Color(0xFF18848E);
  static const Color brandSoft = Color(0xFFD7EFF0);
  static const Color brandSofter = Color(0xFFEBF7F7);
  static const Color brandShadow = Color(0x8C136163); // rgba(brand, .55)

  static const Color ink = Color(0xFF15211F);
  static const Color muted = Color(0xFF5E706E);
  static const Color faint = Color(0xFF9DAAA8);

  static const Color line = Color(0x17143C3C); // rgba(20,60,60,.09)
  static const Color lineStrong = Color(0x24143C3C); // rgba(20,60,60,.14)

  static const Color cream = Color(0xFFFBFAF8);
  static const Color surface = Color(0xFFFFFFFF);

  // ── Semantic ──────────────────────────────────────────────────────
  static const Color successFg = Color(0xFF1B7A43);
  static const Color successBg = Color(0xFFDBF3E4);
  static const Color dangerFg = Color(0xFFB4242B);
  static const Color dangerBg = Color(0xFFFBE2E2);
  static const Color danger = Color(0xFFC4302B); // destructive button / trash
  static const Color warnFg = Color(0xFFC2410C);
  static const Color warnBg = Color(0xFFFBE6DA);
  static const Color online = Color(0xFF1FAE5B);
  static const Color unreadDot = Color(0xFFE0533B);
}

/// A foreground / background / accent triplet (status pills, type chips).
class ColorTriplet {
  final Color fg;
  final Color bg;
  final Color dot;
  const ColorTriplet({required this.fg, required this.bg, required this.dot});
}
