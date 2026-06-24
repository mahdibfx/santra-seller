import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/order_status.dart';
import 'app_text.dart';

/// Rounded status chip: colored dot + localized label, tinted per status.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status, this.small = false});

  final OrderStatus status;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final c = status.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 9 : 11, vertical: small ? 4 : 5),
      decoration: BoxDecoration(color: c.bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: c.dot, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          AppText(status.labelKey.tr(), fontSize: small ? 12 : 13, fontWeight: FontWeight.w700, color: c.fg),
        ],
      ),
    );
  }
}
