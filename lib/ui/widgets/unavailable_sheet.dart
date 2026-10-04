import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../models/order_item.dart';
import '../common/app_colors.dart';
import 'app_icon.dart';
import 'app_text.dart';
import 'app_text_field.dart';
import 'primary_button.dart';
import 'thumb_image.dart';

/// The units the shop cannot supply, keyed by `order_item_id`, plus a note.
typedef UnavailableReport = ({Map<int, int> quantities, String note});

/// Names the units of an order the shop cannot supply. Each line steps from 0
/// up to what is left to report; lines already fully reported are not offered.
Future<UnavailableReport?> showUnavailableSheet(
    BuildContext context, Order order) {
  return showModalBottomSheet<UnavailableReport>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x80143232),
    isScrollControlled: true,
    builder: (context) => _UnavailableSheet(order: order),
  );
}

class _UnavailableSheet extends StatefulWidget {
  const _UnavailableSheet({required this.order});

  final Order order;

  @override
  State<_UnavailableSheet> createState() => _UnavailableSheetState();
}

class _UnavailableSheetState extends State<_UnavailableSheet> {
  final _noteController = TextEditingController();
  final Map<int, int> _picked = {};

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  List<OrderItem> get _lines =>
      widget.order.items.where((i) => i.reportableQuantity > 0).toList();

  bool get _canSend => _picked.values.any((q) => q > 0);

  void _step(OrderItem item, int delta) {
    final max = item.reportableQuantity;
    final next = ((_picked[item.id] ?? 0) + delta).clamp(0, max);
    setState(() {
      if (next == 0) {
        _picked.remove(item.id);
      } else {
        _picked[item.id] = next;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85),
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
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
            AppText.display('report_unavailable_title'.tr(),
                fontSize: 22, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            AppText.body('report_unavailable_sub'.tr(),
                fontSize: 14.5,
                color: AppColors.muted,
                textAlign: TextAlign.center),
            const SizedBox(height: 18),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final item in _lines) ...[
                      _LineStepper(
                        item: item,
                        lang: lang,
                        value: _picked[item.id] ?? 0,
                        onStep: (delta) => _step(item, delta),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 4),
                    AppTextField(
                      controller: _noteController,
                      label: 'report_note_label'.tr(),
                      hintText: 'report_note_hint'.tr(),
                      maxLength: 300,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'report_send'.tr(),
              variant: ButtonVariant.danger,
              disabled: !_canSend,
              onPressed: _canSend
                  ? () => Navigator.of(context).pop((
                        quantities: Map<int, int>.from(_picked),
                        note: _noteController.text.trim(),
                      ))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _LineStepper extends StatelessWidget {
  const _LineStepper({
    required this.item,
    required this.lang,
    required this.value,
    required this.onStep,
  });

  final OrderItem item;
  final String lang;
  final int value;
  final ValueChanged<int> onStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: value > 0 ? AppColors.danger : AppColors.line,
            width: value > 0 ? 1.8 : 1.5),
      ),
      child: Row(
        children: [
          ThumbImage(path: item.image, size: 40, radius: 11),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(item.displayName(lang),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                AppText('${item.reportableQuantity}×',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted),
              ],
            ),
          ),
          _StepButton(icon: 'x', onTap: value > 0 ? () => onStep(-1) : null),
          SizedBox(
            width: 34,
            child: Center(
              child: AppText('$value',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: value > 0 ? AppColors.danger : AppColors.faint),
            ),
          ),
          _StepButton(
            icon: 'plus',
            onTap: value < item.reportableQuantity ? () => onStep(1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, this.onTap});

  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? AppColors.brandSofter : AppColors.cream,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: AppIcon(icon,
              size: 14, color: enabled ? AppColors.brand : AppColors.faint),
        ),
      ),
    );
  }
}
