import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../common/app_colors.dart';
import 'app_icon.dart';
import 'app_text.dart';

/// How long the shop has kept an order waiting, counted from `received_at`.
///
/// It counts up, not down: the partner API sends no per-order deadline, so
/// there is nothing to count towards. The thresholds below are ours, not
/// Santra's — change these two constants when a real SLA arrives.
const Duration kWaitWarn = Duration(minutes: 5);
const Duration kWaitLate = Duration(minutes: 10);

class TimerBadge extends StatefulWidget {
  const TimerBadge({
    super.key,
    required this.order,
    this.small = false,
    this.showBar = false,
  });

  final Order order;
  final bool small;
  final bool showBar;

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
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    String two(int n) => n.toString().padLeft(2, '0');
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '$m:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final received = widget.order.receivedAt;
    if (received == null) return const SizedBox.shrink();

    final waited = DateTime.now().difference(received.toLocal());
    final late = waited >= kWaitLate;

    final (Color fg, Color bg) = late
        ? (AppColors.danger, AppColors.dangerBg)
        : waited >= kWaitWarn
            ? (AppColors.warnFg, AppColors.warnBg)
            : (AppColors.brand, AppColors.brandSoft);

    final chip = Container(
      padding: EdgeInsets.symmetric(
          horizontal: widget.small ? 8 : 10, vertical: widget.small ? 4 : 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(late ? 'hourglass' : 'clock',
              size: widget.small ? 14 : 16, color: fg),
          const SizedBox(width: 6),
          AppText('${'waiting'.tr()} ',
              fontSize: widget.small ? 12.5 : 13.5,
              fontWeight: FontWeight.w600,
              color: fg),
          Directionality(
            textDirection: TextDirection.ltr,
            child: AppText(_fmt(waited),
                fontSize: widget.small ? 13 : 14.5,
                fontWeight: FontWeight.w700,
                color: fg),
          ),
        ],
      ),
    );

    if (!widget.showBar) {
      return Align(alignment: AlignmentDirectional.centerEnd, child: chip);
    }

    // The bar fills as the wait approaches "late", then stays full.
    final frac =
        (waited.inMilliseconds / kWaitLate.inMilliseconds).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(alignment: AlignmentDirectional.centerEnd, child: chip),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: frac,
            minHeight: 4,
            backgroundColor: AppColors.line,
            valueColor: AlwaysStoppedAnimation(fg),
          ),
        ),
      ],
    );
  }
}
