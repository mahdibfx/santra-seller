import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/order_status.dart';
import '../common/app_colors.dart';
import '../common/app_text_styles.dart';

/// Horizontal scrolling status filter with per-status counts.
/// `selected` is null for "All".
class FilterRail extends StatelessWidget {
  const FilterRail({
    super.key,
    required this.selected,
    this.counts = const {},
    required this.totalCount,
    required this.onSelect,
  });

  final OrderStatus? selected;
  final Map<OrderStatus, int> counts;
  final int totalCount;
  final ValueChanged<OrderStatus?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        children: [
          _Chip(
              label: 'all'.tr(),
              count: totalCount,
              active: selected == null,
              onTap: () => onSelect(null)),
          for (final s in kStatusOrder)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 9),
              child: _Chip(
                label: s.labelKey.tr(),
                count: counts[s] ?? 0,
                active: selected == s,
                onTap: () => onSelect(s),
              ),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(
      {required this.label,
      required this.count,
      required this.active,
      required this.onTap});

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.brand : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: active ? null : Border.all(color: AppColors.line, width: 1.5),
          boxShadow: active
              ? const [
                  BoxShadow(
                      color: AppColors.brandShadow,
                      blurRadius: 18,
                      offset: Offset(0, 8))
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: AppTextStyles.body(context,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : AppColors.ink)),
            if (count > 0) ...[
              const SizedBox(width: 7),
              Container(
                constraints: const BoxConstraints(minWidth: 20),
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white.withValues(alpha: 0.22)
                      : AppColors.brandSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('$count',
                    style: AppTextStyles.body(context,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : AppColors.brand)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
