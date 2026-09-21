import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/order_item.dart';
import '../common/app_colors.dart';
import 'app_icon.dart';
import 'app_text.dart';
import 'thumb_image.dart';

/// Collapsible product list: stacked thumbnails + count, expands to rows.
class FoldableItems extends StatefulWidget {
  const FoldableItems({super.key, required this.items, this.onExpand});

  final List<OrderItem> items;

  /// Fired the first time the list is opened — the card uses it to fetch the
  /// notes and photos that `GET /orders` leaves out.
  final VoidCallback? onExpand;

  @override
  State<FoldableItems> createState() => _FoldableItemsState();
}

class _FoldableItemsState extends State<FoldableItems> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final count = widget.items.fold<int>(0, (s, i) => s + i.qty);
    final preview = widget.items.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 13),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() => _open = !_open);
            if (_open) widget.onExpand?.call();
          },
          child: Row(
            children: [
              SizedBox(
                height: 30,
                width: preview.isEmpty ? 0 : 30.0 + (preview.length - 1) * 20,
                child: Stack(
                  children: [
                    for (int i = 0; i < preview.length; i++)
                      PositionedDirectional(
                        start: i * 20.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            border:
                                Border.all(color: AppColors.surface, width: 2),
                          ),
                          child: ThumbImage(
                              path: preview[i].image, size: 30, radius: 9),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: AppText(
                    '$count ${count == 1 ? 'item'.tr() : 'items'.tr()}',
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              AppText(_open ? 'hide_items'.tr() : 'show_items'.tr(),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brand),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const AppIcon('chevronDown',
                    size: 18, color: AppColors.brand),
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  for (final it in widget.items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.5),
                      child: Row(
                        children: [
                          ThumbImage(path: it.image, size: 40, radius: 11),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(it.displayName(lang),
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                if (it.hasRequest) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      if (it.note.isNotEmpty) ...[
                                        _Pill(
                                            label: 'note_pill'.tr(),
                                            iconName: 'note'),
                                        const SizedBox(width: 6),
                                      ],
                                      if (it.images.isNotEmpty)
                                        _Pill(
                                            label: '×${it.images.length}',
                                            iconName: 'image'),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          _QtyBadge(qty: it.qty),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          crossFadeState:
              _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

/// Marks what the customer attached to a line: their note, and how many
/// reference photos. The words themselves live on the detail screen.
class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.iconName});

  final String label;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          AppIcon(iconName, size: 13, color: AppColors.infoFg),
          const SizedBox(width: 4),
          AppText(label,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.infoFg),
        ],
      ),
    );
  }
}

class _QtyBadge extends StatelessWidget {
  const _QtyBadge({required this.qty});
  final int qty;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 30),
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: AppColors.brandSoft, borderRadius: BorderRadius.circular(8)),
      child: AppText('$qty×',
          fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brand),
    );
  }
}
