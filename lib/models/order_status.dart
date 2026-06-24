import 'package:flutter/material.dart';

import '../ui/common/app_colors.dart';

/// Order lifecycle states. Wire key matches the backend's `status` string.
enum OrderStatus {
  pending('pending'),
  accepted('accepted'),
  onWay('on_way'),
  delivered('delivered'),
  cancelled('cancelled'),
  rejected('rejected');

  final String wire;
  const OrderStatus(this.wire);

  static OrderStatus fromWire(String? value) {
    return OrderStatus.values.firstWhere(
      (s) => s.wire == value,
      orElse: () => OrderStatus.pending,
    );
  }

  /// i18n key for the filter/pill label (e.g. `filt_pending`).
  String get labelKey => 'filt_$wire';

  ColorTriplet get colors => switch (this) {
        OrderStatus.pending =>
          const ColorTriplet(fg: Color(0xFF9A6B05), bg: Color(0xFFFBF0D2), dot: Color(0xFFE0A100)),
        OrderStatus.accepted =>
          const ColorTriplet(fg: Color(0xFF0E5F62), bg: Color(0xFFD6F0F1), dot: Color(0xFF18848E)),
        OrderStatus.onWay =>
          const ColorTriplet(fg: Color(0xFF0B6E86), bg: Color(0xFFD8F1F8), dot: Color(0xFF1AA6C4)),
        OrderStatus.delivered =>
          const ColorTriplet(fg: Color(0xFF1B7A43), bg: Color(0xFFDBF3E4), dot: Color(0xFF1FAE5B)),
        OrderStatus.cancelled =>
          const ColorTriplet(fg: Color(0xFF4B5563), bg: Color(0xFFE9ECEF), dot: Color(0xFF8A94A1)),
        OrderStatus.rejected =>
          const ColorTriplet(fg: Color(0xFFB4242B), bg: Color(0xFFFBE2E2), dot: Color(0xFFDC3A41)),
      };
}

/// Display order for the filter rail.
const List<OrderStatus> kStatusOrder = [
  OrderStatus.pending,
  OrderStatus.accepted,
  OrderStatus.onWay,
  OrderStatus.delivered,
  OrderStatus.cancelled,
  OrderStatus.rejected,
];
