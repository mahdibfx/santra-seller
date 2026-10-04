/// One entry of `GET /orders/cancel-reasons`. The partner picks a label; the
/// app sends back [code], which the API validates against this same list.
class CancelReason {
  final String code;
  final String labelEn;
  final String labelAr;

  const CancelReason({
    required this.code,
    required this.labelEn,
    required this.labelAr,
  });

  String label(String lang) =>
      lang == 'ar' && labelAr.isNotEmpty ? labelAr : labelEn;

  /// The one code that needs the partner's own words to mean anything.
  bool get needsComment => code == 'other';

  factory CancelReason.fromJson(Map<String, dynamic> json) => CancelReason(
        code: json['code'] as String? ?? '',
        labelEn: json['label_en'] as String? ?? '',
        labelAr: json['label_ar'] as String? ?? '',
      );
}
