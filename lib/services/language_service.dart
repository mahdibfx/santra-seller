import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked_services/stacked_services.dart';

/// Toggles the app locale (EN ⇄ AR). easy_localization persists the choice and
/// rebuilds the tree (flipping `Directionality` for RTL automatically).
class LanguageService {
  static const Locale en = Locale('en');
  static const Locale ar = Locale('ar');

  BuildContext? get _context => StackedService.navigatorKey?.currentContext;

  bool get isArabic => _context?.locale.languageCode == 'ar';
  String get code => isArabic ? 'ar' : 'en';

  Future<void> toggle() async {
    final context = _context;
    if (context == null) return;
    await context.setLocale(isArabic ? en : ar);
  }

  Future<void> setArabic(bool arabic) async {
    final context = _context;
    if (context == null) return;
    await context.setLocale(arabic ? ar : en);
  }
}
