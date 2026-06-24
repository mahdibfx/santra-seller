import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import 'app_icon.dart';
import 'app_text.dart';
import 'primary_button.dart';

/// Bottom-sheet confirmation before rejecting an order.
/// Returns `true` when the seller confirms the rejection.
Future<bool> showRejectSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x80143232),
    isScrollControlled: true,
    builder: (context) => const _RejectSheet(),
  );
  return result ?? false;
}

class _RejectSheet extends StatelessWidget {
  const _RejectSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 36),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 5, decoration: BoxDecoration(color: AppColors.lineStrong, borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 20),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: AppColors.dangerBg, borderRadius: BorderRadius.circular(18)),
            child: const Center(child: AppIcon('x', size: 30, color: AppColors.danger)),
          ),
          const SizedBox(height: 16),
          AppText.display('confirm_reject'.tr(), fontSize: 24, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          AppText.body('confirm_reject_sub'.tr(), color: AppColors.muted, fontSize: 15.5, textAlign: TextAlign.center),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'cancel'.tr(),
                  variant: ButtonVariant.ghost,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'reject_order'.tr(),
                  variant: ButtonVariant.danger,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
