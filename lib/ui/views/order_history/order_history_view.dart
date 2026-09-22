import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/order.dart';
import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../common/app_text_styles.dart';
import '../../common/format.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text.dart';
import '../../widgets/icon_square_button.dart';
import '../../widgets/status_pill.dart';
import '../../widgets/thumb_image.dart';
import 'order_history_viewmodel.dart';

class OrderHistoryView extends StackedView<OrderHistoryViewModel> {
  const OrderHistoryView({super.key});

  @override
  Widget builder(
      BuildContext context, OrderHistoryViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
              child: Row(
                children: [
                  IconSquareButton(
                      iconName: 'chevronLeft',
                      onTap: viewModel.onBack,
                      flipForRtl: true,
                      radius: 13,
                      size: 42),
                  const SizedBox(width: 10),
                  AppText.displayLarge('order_history'.tr(), fontSize: 25),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: _SearchField(viewModel: viewModel),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
              child: Row(
                children: [
                  Expanded(
                      child: _DateField(
                          label: 'date_from'.tr(),
                          value: viewModel.from,
                          onPick: viewModel.setFrom,
                          context: context,
                          lastDate: viewModel.to)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _DateField(
                          label: 'date_to'.tr(),
                          value: viewModel.to,
                          onPick: viewModel.setTo,
                          context: context,
                          firstDate: viewModel.from)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText('${viewModel.resultsCount} ${'results'.tr()}',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted),
                  if (viewModel.hasFilters)
                    GestureDetector(
                      onTap: viewModel.clearFilters,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppIcon('x', size: 15, color: AppColors.brand),
                          const SizedBox(width: 5),
                          AppText('clear_filters'.tr(),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.brand),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: viewModel.isBusy
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.brand))
                  : viewModel.orders.isEmpty
                      ? _empty()
                      : NotificationListener<ScrollNotification>(
                          onNotification: (n) {
                            if (n.metrics.pixels >=
                                n.metrics.maxScrollExtent - 300)
                              viewModel.loadMore();
                            return false;
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(18, 4, 18, 40),
                            itemCount: viewModel.orders.length +
                                (viewModel.hasMore ? 1 : 0),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 11),
                            itemBuilder: (_, i) {
                              if (i >= viewModel.orders.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          color: AppColors.brand)),
                                );
                              }
                              final o = viewModel.orders[i];
                              return _HistoryRow(
                                  order: o, onTap: () => viewModel.onOpen(o));
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                  color: AppColors.brandSofter,
                  borderRadius: BorderRadius.circular(20)),
              child: const Center(
                  child: AppIcon('search', size: 28, color: AppColors.brand)),
            ),
            const SizedBox(height: 12),
            AppText.display('no_history'.tr(), fontSize: 19),
            const SizedBox(height: 6),
            AppText.body('no_history_sub'.tr(),
                color: AppColors.muted,
                fontSize: 14,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(OrderHistoryViewModel viewModel) => viewModel.init();

  @override
  OrderHistoryViewModel viewModelBuilder(BuildContext context) =>
      OrderHistoryViewModel();
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.viewModel});
  final OrderHistoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lineStrong, width: 1.5),
      ),
      child: Row(
        children: [
          const AppIcon('search', size: 19, color: AppColors.faint),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              onChanged: viewModel.onQueryChanged,
              controller: viewModel.searchController,
              cursorColor: AppColors.brand,
              style: AppTextStyles.body(context,
                  fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'search_orders'.tr(),
                hintStyle: AppTextStyles.body(context,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.faint),
              ),
            ),
          ),
          if (viewModel.query.isNotEmpty)
            GestureDetector(
                onTap: viewModel.clearQuery,
                child: const AppIcon('x', size: 17, color: AppColors.faint)),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onPick,
    required this.context,
    this.firstDate,
    this.lastDate,
  });
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onPick;
  final BuildContext context;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 2, bottom: 6),
          child: AppText.label(label, fontSize: 12.5),
        ),
        GestureDetector(
          onTap: () async {
            final first = firstDate ?? DateTime(2024);
            final last = lastDate ?? DateTime(2027);
            final initial = (value ?? DateTime(2026, 6, 23));
            final picked = await showDatePicker(
              context: context,
              initialDate: initial.isBefore(first)
                  ? first
                  : (initial.isAfter(last) ? last : initial),
              firstDate: first,
              lastDate: last,
            );
            if (picked != null) onPick(picked);
          },
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.lineStrong, width: 1.5),
            ),
            child: Row(
              children: [
                const AppIcon('calendar', size: 17, color: AppColors.faint),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText(
                    value == null
                        ? label
                        : formatIsoDate(_iso(value!), context),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: value == null ? AppColors.faint : AppColors.ink,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.order, required this.onTap});
  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: Color(0x30143232), blurRadius: 26, offset: Offset(0, 12))
          ],
        ),
        child: Row(
          children: [
            ThumbImage(
                path: order.items.isNotEmpty ? order.items.first.image : '',
                size: 48,
                radius: 13),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '#${order.orderNumber.isNotEmpty ? order.orderNumber : order.id}',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    '${'shipped_at'.tr()} ${formatIsoDate(order.date, context)}',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Price over status: a long order number used to push the pill off
            // the row.
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText.display(money(order.total, context), fontSize: 17),
                const SizedBox(height: 5),
                StatusPill(status: order.status, small: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
