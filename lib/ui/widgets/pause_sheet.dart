import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/trading.dart';
import '../common/app_colors.dart';
import 'app_icon.dart';
import 'app_text.dart';
import 'primary_button.dart';

/// What the partner asked for: `busy` + a length, `extend` + minutes, or
/// `open`. Mirrors `PATCH /me/trading`.
typedef TradingAction = ({String action, Object? minutes});

/// Pause the shop, extend a running pause, or resume.
///
/// Every length comes from `trading.choices` — nothing here is hard-coded, so
/// Santra can change the options without an app release.
Future<TradingAction?> showPauseSheet(BuildContext context, Trading trading) {
  return showModalBottomSheet<TradingAction>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x80143232),
    isScrollControlled: true,
    builder: (context) => _PauseSheet(trading: trading),
  );
}

/// `30` → "30 min", `"day"` → "Rest of today". An unknown length still gets a
/// sensible label rather than disappearing.
String pauseChoiceLabel(Object choice) {
  if (choice is String) return 'pause_day'.tr();
  final key = 'pause_$choice';
  final label = key.tr();
  return label == key ? '$choice ${'minutes_short'.tr()}' : label;
}

String extendChoiceLabel(int minutes) {
  final key = 'extend_$minutes';
  final label = key.tr();
  return label == key ? '+$minutes' : label;
}

/// `14:30` in the viewer's locale.
String formatClock(DateTime time, BuildContext context) {
  final t = time.toLocal();
  final h = t.hour.toString().padLeft(2, '0');
  final m = t.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

class _PauseSheet extends StatelessWidget {
  const _PauseSheet({required this.trading});

  final Trading trading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                  color: AppColors.lineStrong,
                  borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 18),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
                color: AppColors.warnBg,
                borderRadius: BorderRadius.circular(18)),
            child: const Center(
                child: AppIcon('clock', size: 28, color: AppColors.warnFg)),
          ),
          const SizedBox(height: 14),
          if (trading.isBusy) ..._busy(context) else ..._idle(context),
          const SizedBox(height: 18),
          AppText.body('portal_hours_line'.tr(),
              fontSize: 13,
              color: AppColors.faint,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  List<Widget> _idle(BuildContext context) => [
        AppText.display('pause_question'.tr(),
            fontSize: 23, textAlign: TextAlign.center),
        const SizedBox(height: 9),
        AppText.body('pause_explainer'.tr(),
            fontSize: 14.5,
            color: AppColors.muted,
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        for (final choice in trading.busyChoices) ...[
          PrimaryButton(
            label: pauseChoiceLabel(choice),
            variant: ButtonVariant.ghost,
            onPressed: () =>
                Navigator.of(context).pop((action: 'busy', minutes: choice)),
          ),
          const SizedBox(height: 10),
        ],
      ];

  List<Widget> _busy(BuildContext context) {
    final until = trading.busyUntil;
    return [
      AppText.display(
        until == null
            ? 'pause'.tr()
            : 'busy_until'.tr(args: [formatClock(until, context)]),
        fontSize: 20,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      if (trading.canExtend)
        for (final minutes in trading.extendChoices) ...[
          PrimaryButton(
            label: extendChoiceLabel(minutes),
            variant: ButtonVariant.ghost,
            onPressed: () =>
                Navigator.of(context).pop((action: 'extend', minutes: minutes)),
          ),
          const SizedBox(height: 10),
        ],
      PrimaryButton(
        label: 'resume_now'.tr(),
        leadingIcon: 'check',
        onPressed: () =>
            Navigator.of(context).pop((action: 'open', minutes: null)),
      ),
    ];
  }
}
