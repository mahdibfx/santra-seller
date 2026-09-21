import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../common/app_colors.dart';
import '../common/format.dart';
import 'app_icon.dart';
import 'app_text.dart';
import 'foldable_items.dart';
import 'meta_chips.dart';
import 'primary_button.dart';
import 'status_pill.dart';
import 'timer_badge.dart';

/// Order summary card for the Orders list.
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onOpen,
    required this.onAccept,
    required this.onOpenNote,
    required this.onDelete,
    this.onExpandItems,
  });

  final Order order;
  final VoidCallback onOpen;
  final VoidCallback onAccept;
  final VoidCallback onOpenNote;
  final VoidCallback onDelete;
  final VoidCallback? onExpandItems;

  @override
  Widget build(BuildContext context) {
    final o = order;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
              color: Color(0x38143232), blurRadius: 30, offset: Offset(0, 14))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onOpen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.title(
                        '${'order'.tr()} #${o.orderNumber.isNotEmpty ? o.orderNumber : o.id}',
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                    StatusPill(status: o.status),
                  ],
                ),
                const SizedBox(height: 12),
                MetaChips(order: o),
                if (o.hasTimer) ...[
                  const SizedBox(height: 13),
                  TimerBadge(order: o, showBar: true),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                          color: AppColors.brandSofter,
                          borderRadius: BorderRadius.circular(9)),
                      child: const Center(
                          child: AppIcon('user',
                              size: 16, color: AppColors.brand)),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                        child: AppText(o.customer,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          FoldableItems(items: o.items, onExpand: onExpandItems),
          if (o.hasRequest) ...[
            const SizedBox(height: 13),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onOpenNote,
              child: Row(
                children: [
                  const AppIcon('note', size: 18, color: AppColors.brand),
                  const SizedBox(width: 9),
                  Expanded(
                      child: AppText('special_request'.tr(),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brand)),
                  if (o.images.isNotEmpty) ...[
                    const AppIcon('image', size: 15, color: AppColors.brand),
                    const SizedBox(width: 4),
                    AppText('${o.images.length}',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brand),
                    const SizedBox(width: 6),
                  ],
                  const AppIcon('chevronRight',
                      size: 16, color: AppColors.brand, flipForRtl: true),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('total'.tr(),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted),
              AppText.display(money(o.total, context), fontSize: 22),
            ],
          ),
          if (o.isPending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'accept'.tr(),
                    leadingIcon: 'check',
                    height: 50,
                    borderRadius: 15,
                    fontSize: 16,
                    onPressed: onAccept,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    label: 'cancel'.tr(),
                    variant: ButtonVariant.dangerOutline,
                    height: 50,
                    borderRadius: 15,
                    fontSize: 16,
                    onPressed: onDelete,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
