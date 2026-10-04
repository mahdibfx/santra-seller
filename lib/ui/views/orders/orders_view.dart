import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text.dart';
import '../../widgets/filter_rail.dart';
import '../../widgets/icon_square_button.dart';
import '../../widgets/cancel_order_sheet.dart';
import '../../widgets/pause_sheet.dart';
import '../../widgets/order_card.dart';
import '../../widgets/primary_button.dart';
import 'orders_viewmodel.dart';

class OrdersView extends StackedView<OrdersViewModel> {
  const OrdersView({super.key});

  @override
  Widget builder(
      BuildContext context, OrdersViewModel viewModel, Widget? child) {
    final topInset = MediaQuery.of(context).padding.top;

    return FadeSlideIn(
      child: Column(
        children: [
          SizedBox(height: topInset + 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.displayLarge('orders'.tr(), fontSize: 28),
                const Spacer(),
                _PauseButton(viewModel: viewModel),
                const SizedBox(width: 10),
                Row(
                  children: [
                    // IconSquareButton(
                    //   iconName: 'globe',
                    //   label: arabic ? 'EN' : 'ع',
                    //   onTap: viewModel.onToggleLang,
                    // ),
                    // const SizedBox(width: 10),
                    IconSquareButton(
                      iconName: 'bell',
                      onTap: viewModel.onOpenNotifications,
                      showDot: viewModel.hasUnread,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!viewModel.trading.isOpen) _TradingBanner(viewModel: viewModel),
          if (viewModel.isBusy)
            const Expanded(
                child: Center(
                    child: CircularProgressIndicator(color: AppColors.brand)))
          else if (viewModel.isEmptyStore)
            Expanded(
                child: _WebPortalEmpty(onOpenPortal: viewModel.onOpenPortal))
          else ...[
            const SizedBox(height: 14),
            FilterRail(
              selected: viewModel.filter,
              totalCount: viewModel.totalCount,
              onSelect: viewModel.setFilter,
            ),
            const SizedBox(height: 8),
            // Cards scroll under the chips. Fading the pixels (rather than
            // painting cream over them) is what keeps the card's soft shadow
            // from ending in a straight line.
            Expanded(
              child: ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [Colors.transparent, Colors.black],
                  stops: [0, 44 / rect.height],
                ).createShader(rect),
                child: _OrderList(viewModel: viewModel),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void onViewModelReady(OrdersViewModel viewModel) => viewModel.init();

  @override
  OrdersViewModel viewModelBuilder(BuildContext context) => OrdersViewModel();
}

/// Quick action: pause the shop, or resume it.
class _PauseButton extends StatelessWidget {
  const _PauseButton({required this.viewModel});
  final OrdersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final paused = !viewModel.trading.isOpen;
    return GestureDetector(
      onTap: () async {
        final action = await showPauseSheet(context, viewModel.trading);
        if (action != null) await viewModel.applyTrading(action);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: paused ? AppColors.warnBg : AppColors.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
              color: paused ? AppColors.warnFg : AppColors.line, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon('clock',
                size: 17, color: paused ? AppColors.warnFg : AppColors.muted),
            const SizedBox(width: 7),
            AppText('pause'.tr(),
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: paused ? AppColors.warnFg : AppColors.ink),
          ],
        ),
      ),
    );
  }
}

/// A shop must not forget it paused itself, so the state stays on the board.
class _TradingBanner extends StatelessWidget {
  const _TradingBanner({required this.viewModel});
  final OrdersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final trading = viewModel.trading;
    final until = trading.busyUntil;
    final text = trading.isClosed
        ? 'closed_now'.tr()
        : until == null
            ? 'pause'.tr()
            : 'busy_until'.tr(args: [formatClock(until, context)]);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.warnBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const AppIcon('hourglass', size: 18, color: AppColors.warnFg),
            const SizedBox(width: 10),
            Expanded(
              child: AppText(text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warnFg),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () =>
                  viewModel.applyTrading((action: 'open', minutes: null)),
              child: AppText(
                  trading.isClosed ? 'reopen'.tr() : 'resume_now'.tr(),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brand),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.viewModel});
  final OrdersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final list = viewModel.visibleOrders;
    if (list.isEmpty) {
      return _EmptyState(
        icon: 'bag',
        title: 'no_orders'.tr(),
        subtitle: 'no_orders_sub'.tr(),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.pixels >= n.metrics.maxScrollExtent - 300)
          viewModel.loadMore();
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(22, 40, 22, 120),
        itemCount: list.length + (viewModel.hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, i) {
          if (i >= list.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                  child: CircularProgressIndicator(color: AppColors.brand)),
            );
          }
          final o = list[i];
          return OrderCard(
            order: o,
            onOpen: () => viewModel.onOpen(o),
            onOpenNote: () => viewModel.onOpen(o),
            onAccept: () => viewModel.onAccept(o),
            onDelete: () => runCancelFlow(
                context, o, (choice) => viewModel.onCancel(o, choice)),
            onExpandItems: () => viewModel.hydrateItems(o),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState(
      {required this.icon, required this.title, required this.subtitle});
  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                  color: AppColors.brandSofter,
                  borderRadius: BorderRadius.circular(22)),
              child: Center(
                  child: AppIcon(icon, size: 32, color: AppColors.brand)),
            ),
            const SizedBox(height: 14),
            AppText.display(title, fontSize: 20),
            const SizedBox(height: 6),
            AppText.body(subtitle,
                color: AppColors.muted,
                fontSize: 14.5,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _WebPortalEmpty extends StatelessWidget {
  const _WebPortalEmpty({required this.onOpenPortal});
  final VoidCallback onOpenPortal;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(34, 40, 34, 130),
        child: Column(
          children: [
            SizedBox(
              width: 116,
              height: 116,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.brandSoft,
                        borderRadius: BorderRadius.circular(34)),
                  ),
                  const Center(
                      child:
                          AppIcon('monitor', size: 52, color: AppColors.brand)),
                  PositionedDirectional(
                    end: -6,
                    bottom: -2,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.brand,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.brandShadow,
                              blurRadius: 22,
                              offset: Offset(0, 10))
                        ],
                      ),
                      child: const Center(
                          child:
                              AppIcon('plus', size: 22, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            AppText.display('portal_title'.tr(),
                fontSize: 26, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 290),
              child: AppText.body('portal_sub'.tr(),
                  fontSize: 15.5,
                  color: AppColors.muted,
                  height: 1.6,
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 28),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: PrimaryButton(
                  label: 'portal_cta'.tr(),
                  leadingIcon: 'external',
                  onPressed: onOpenPortal),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.line, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppIcon('globe', size: 15, color: AppColors.faint),
                  const SizedBox(width: 7),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: AppText('portal_url'.tr(),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: AppText.body('portal_or'.tr(),
                  fontSize: 13.5,
                  color: AppColors.faint,
                  height: 1.5,
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
