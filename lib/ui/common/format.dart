import 'package:flutter/widgets.dart';

/// Localized currency: `AED 245` (en) / `245 د.إ` (ar).
/// Shows 2 decimals only when the amount isn't whole (e.g. `AED 72.98`).
String money(num amount, BuildContext context) {
  final ar = Localizations.localeOf(context).languageCode == 'ar';
  final n = amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(2);
  return ar ? '$n د.إ' : 'AED $n';
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

/// "23 Jun 2026 · 14:05" from the timestamp the server sent, as sent.
///
/// No timezone conversion. The backend is the source of truth for what time
/// an order was placed, and shifting it in the app only creates a second
/// opinion — one that reads differently depending on which country the phone
/// is in.
///
/// Pass [withTime] false for the board cards, where the day is enough and the
/// line has to stay short.
String formatPlacedAt(DateTime? at, BuildContext context,
    {bool withTime = true}) {
  if (at == null) return '';
  final iso = '${at.year}-${at.month.toString().padLeft(2, '0')}'
      '-${at.day.toString().padLeft(2, '0')}';
  final day = formatIsoDate(iso, context);
  if (!withTime) return day;
  final time = '${at.hour.toString().padLeft(2, '0')}'
      ':${at.minute.toString().padLeft(2, '0')}';
  return '$day  \u00b7  $time';
}
