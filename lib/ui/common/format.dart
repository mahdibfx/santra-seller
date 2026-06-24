import 'package:flutter/widgets.dart';

/// Localized currency: `AED 245` (en) / `245 د.إ` (ar).
String money(int amount, BuildContext context) {
  final ar = Localizations.localeOf(context).languageCode == 'ar';
  return ar ? '$amount د.إ' : 'AED $amount';
}

const List<String> kMonthsEn = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];
const List<String> kMonthsAr = [
  'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
];

/// `23 Jun 2026` (en) / `23 يونيو 2026` (ar) from an ISO yyyy-MM-dd string.
String formatIsoDate(String iso, BuildContext context) {
  if (iso.isEmpty) return '';
  final parts = iso.split('-');
  if (parts.length != 3) return iso;
  final y = parts[0];
  final m = int.tryParse(parts[1]) ?? 1;
  final d = int.tryParse(parts[2]) ?? 1;
  final ar = Localizations.localeOf(context).languageCode == 'ar';
  final mon = (ar ? kMonthsAr : kMonthsEn)[(m - 1).clamp(0, 11)];
  return '$d $mon $y';
}
