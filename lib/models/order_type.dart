import 'package:flutter/material.dart';

/// Order tags (badges on the card). `wire` matches the backend's tag string.
enum OrderType {
  vip('vip', 'crown', Color(0xFF9A6B05), Color(0xFFFBF0D2)),
  express('express', 'bolt', Color(0xFFC2410C), Color(0xFFFBE6DA)),
  gift('gift', 'gift', Color(0xFFA4458F), Color(0xFFF6E5F2)),
  scheduled('scheduled', 'calendar', Color(0xFF3F57B0), Color(0xFFE4E8FB)),
  pickup('pickup', 'store', Color(0xFF0E6F62), Color(0xFFD7F0EC));

  final String wire;
  final String iconName;
  final Color fg;
  final Color bg;
  const OrderType(this.wire, this.iconName, this.fg, this.bg);

  /// i18n keys: `type_vip`, `type_express`, … (added to translations).
  String get labelKey => 'type_$wire';

  static OrderType? fromWire(String? value) {
    for (final t in OrderType.values) {
      if (t.wire == value) return t;
    }
    return null;
  }
}

/// Payment method chip.
enum PaymentMethod {
  cod('cod', 'wallet', Color(0xFF9A6B05), Color(0xFFFBF0D2)),
  paid('paid', 'checkCircle', Color(0xFF1B7A43), Color(0xFFDBF3E4));

  final String wire;
  final String iconName;
  final Color fg;
  final Color bg;
  const PaymentMethod(this.wire, this.iconName, this.fg, this.bg);

  String get labelKey => 'pay_$wire';

  static PaymentMethod fromWire(String? value) {
    return PaymentMethod.values.firstWhere(
      (p) => p.wire == value,
      orElse: () => PaymentMethod.cod,
    );
  }
}
