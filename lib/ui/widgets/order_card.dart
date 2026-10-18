import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../models/order_addon.dart';
import '../../models/order_status.dart';
import '../common/format.dart';
import '../common/app_colors.dart';
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
    final lang = context.locale.languageCode;
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
                // The two facts a shop plans around, one per line. Side by
                // side they ran out of width in Arabic, where both labels are
                // longer than their English counterparts.
                if (o.deliveryDate.isNotEmpty) ...[
                  const SizedBox(height: 11),
                  _CardDate(
                    icon: 'calendar',
                    label: 'delivery_on'.tr(),
                    value: formatIsoDate(o.deliveryDate, context),
                  ),
                ],
                // Date only: the waiting timer above already carries the
                // minutes, and the card has no room for a clock too.
                if (o.createdAt != null) ...[
                  const SizedBox(height: 6),
                  _CardDate(
                    icon: 'clock',
                    label: 'placed_on'.tr(),
                    value:
                        formatPlacedAt(o.createdAt, context, withTime: false),
                  ),
                ],
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
          if (o.addons.isNotEmpty) _AddonLines(addons: o.addons, lang: lang),
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
          // No total on the card: `total` is what the CUSTOMER pays — items
          // plus delivery, cash and service fees, none of which reach the
          // shop — so a shop read it as what they earn. The order page keeps
          // the full breakdown.
          // Which buttons exist is the server's call (`allowed_transitions`).
          if (o.can(OrderStatus.confirmed) || o.can(OrderStatus.cancelled)) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                if (o.can(OrderStatus.confirmed))
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
                if (o.can(OrderStatus.confirmed) &&
                    o.can(OrderStatus.cancelled))
                  const SizedBox(width: 10),
                if (o.can(OrderStatus.cancelled))
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

/// Extras the customer paid for that the shop has to put in the box.
class _AddonLines extends StatelessWidget {
  const _AddonLines({required this.addons, required this.lang});

  final List<OrderAddon> addons;
  final String lang;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.label('addons_title'.tr()),
          const SizedBox(height: 7),
          for (final a in addons)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const AppIcon('gift', size: 15, color: AppColors.brand),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppText('${a.quantity} × ${a.displayName(lang)}',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


/// One "label: value" date on a board card.
class _CardDate extends StatelessWidget {
  const _CardDate(
      {required this.icon, required this.label, required this.value});

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(icon, size: 14, color: AppColors.muted),
        const SizedBox(width: 5),
        AppText('$label: $value',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: AppColors.muted),
      ],
    );
  }
}
