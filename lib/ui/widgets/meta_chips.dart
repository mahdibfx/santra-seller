import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/order.dart';
import 'app_icon.dart';
import 'app_text.dart';

/// Wrap of order-type tag chips followed by the payment chip.
class MetaChips extends StatelessWidget {
  const MetaChips({super.key, required this.order, this.small = false});

  final Order order;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      for (final tag in order.tags)
        _Chip(icon: tag.iconName, label: tag.labelKey.tr(), fg: tag.fg, bg: tag.bg, small: small),
      _Chip(
        icon: order.payment.iconName,
        label: order.payment.labelKey.tr(),
        fg: order.payment.fg,
        bg: order.payment.bg,
        small: small,
      ),
    ];
    return Wrap(spacing: 7, runSpacing: 7, children: chips);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, required this.fg, required this.bg, required this.small});

  final String icon;
  final String label;
  final Color fg;
  final Color bg;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 9 : 11, vertical: small ? 4 : 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(icon, size: small ? 13 : 14, color: fg),
          const SizedBox(width: 5),
          AppText(label, fontSize: small ? 12 : 13, fontWeight: FontWeight.w700, color: fg),
        ],
      ),
    );
  }
}
