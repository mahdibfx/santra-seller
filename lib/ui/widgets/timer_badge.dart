import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../common/app_colors.dart';
import 'app_icon.dart';
import 'app_text.dart';

/// Live fulfilment countdown. The deadline is pinned once per order id for the
/// session so the countdown is stable across rebuilds. Color escalates as the
/// SLA window runs down: <20% or overdue → red, <50% → orange, else brand.
class TimerBadge extends StatefulWidget {
  const TimerBadge({super.key, required this.order, this.small = false, this.showBar = false});

  final Order order;
  final bool small;
  final bool showBar;

  static final Map<int, DateTime> _deadlines = {};

  static DateTime _deadlineFor(Order o) {
    return _deadlines.putIfAbsent(
      o.id,
      () => DateTime.now().add(Duration(minutes: o.due ?? 0)),
    );
  }

  @override
  State<TimerBadge> createState() => _TimerBadgeState();
}

class _TimerBadgeState extends State<TimerBadge> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final neg = d.isNegative;
    final s = d.abs();
    final h = s.inHours;
    final m = s.inMinutes % 60;
    final sec = s.inSeconds % 60;
    String two(int n) => n.toString().padLeft(2, '0');
    final body = h > 0 ? '$h:${two(m)}:${two(sec)}' : '$m:${two(sec)}';
    return (neg ? '−' : '') + body;
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final deadline = TimerBadge._deadlineFor(order);
    final remaining = deadline.difference(DateTime.now());
    final slaMs = (order.sla ?? 1) * 60000;
    final frac = remaining.inMilliseconds / slaMs;
    final overdue = remaining.isNegative;

    final (Color fg, Color bg) = (overdue || frac < 0.2)
        ? (AppColors.danger, AppColors.dangerBg)
        : frac < 0.5
            ? (AppColors.warnFg, AppColors.warnBg)
            : (AppColors.brand, AppColors.brandSoft);

    final chip = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(overdue ? 'hourglass' : 'clock', size: widget.small ? 14 : 16, color: fg),
        const SizedBox(width: 6),
        Directionality(
          textDirection: TextDirection.ltr,
          child: AppText(_fmt(remaining), fontSize: widget.small ? 13 : 14.5, fontWeight: FontWeight.w700, color: fg),
        ),
      ],
    );

    if (!widget.showBar) return Align(alignment: AlignmentDirectional.centerEnd, child: chip);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(alignment: AlignmentDirectional.centerEnd, child: chip),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: frac.clamp(0.0, 1.0),
            minHeight: 4,
            backgroundColor: AppColors.line,
            valueColor: AlwaysStoppedAnimation(fg),
          ),
        ),
      ],
    );
  }
}
