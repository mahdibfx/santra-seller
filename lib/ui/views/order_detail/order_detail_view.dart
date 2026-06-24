import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/order.dart';
import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../common/format.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text.dart';
import '../../widgets/image_viewer.dart';
import '../../widgets/meta_chips.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/reject_sheet.dart';
import '../../widgets/status_pill.dart';
import '../../widgets/swipe_accept.dart';
import '../../widgets/thumb_image.dart';
import '../../widgets/timer_badge.dart';
import '../../widgets/top_bar.dart';
import 'order_detail_viewmodel.dart';

class OrderDetailView extends StackedView<OrderDetailViewModel> {
  const OrderDetailView({super.key, required this.orderId});

  final int orderId;

  @override
  Widget builder(BuildContext context, OrderDetailViewModel viewModel, Widget? child) {
    final order = viewModel.order;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: viewModel.isBusy || order == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.brand))
          : FadeSlideIn(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(22, MediaQuery.of(context).padding.top + 8, 22, 0),
                        child: TopBar(onBack: viewModel.onBack, right: StatusPill(status: order.status)),
                      ),
                      Expanded(child: _Body(order: order, viewModel: viewModel)),
                    ],
                  ),
                  _ActionBar(order: order, viewModel: viewModel),
                ],
              ),
            ),
    );
  }

  @override
  void onViewModelReady(OrderDetailViewModel viewModel) => viewModel.init();

  @override
  OrderDetailViewModel viewModelBuilder(BuildContext context) => OrderDetailViewModel(orderId: orderId);
}

class _Body extends StatelessWidget {
  const _Body({required this.order, required this.viewModel});
  final Order order;
  final OrderDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 130),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.displayLarge('${'order'.tr()} #${order.id}', fontSize: 32),
          const SizedBox(height: 7),
          Row(
            children: [
              const AppIcon('calendar', size: 15, color: AppColors.muted),
              const SizedBox(width: 6),
              AppText(order.deliver, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.muted),
            ],
          ),
          if (order.hasTimer) ...[
            const SizedBox(height: 16),
            TimerBadge(order: order),
          ],
          const SizedBox(height: 14),
          MetaChips(order: order),
          const SizedBox(height: 20),
          _CustomerCard(name: order.customer),
          _SectionLabel('order_items'.tr()),
          _ItemsCard(order: order),
          _SectionLabel('note_title'.tr()),
          _NoteBlock(order: order, lang: lang),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppColors.brandSoft, borderRadius: BorderRadius.circular(13)),
            child: const Center(child: AppIcon('user', size: 22, color: AppColors.brand)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.label('customer'.tr()),
              const SizedBox(height: 2),
              AppText(name, fontSize: 16.5, fontWeight: FontWeight.w600),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          for (int i = 0; i < order.items.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                border: Border(
                  bottom: i < order.items.length - 1
                      ? const BorderSide(color: AppColors.line)
                      : BorderSide.none,
                ),
              ),
              child: Row(
                children: [
                  ThumbImage(path: order.items[i].image, size: 50, radius: 13),
                  const SizedBox(width: 13),
                  Expanded(child: AppText(order.items[i].displayName(lang), fontSize: 15.5, fontWeight: FontWeight.w500)),
                  Container(
                    constraints: const BoxConstraints(minWidth: 32),
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.brandSoft, borderRadius: BorderRadius.circular(9)),
                    child: AppText('${order.items[i].qty}×', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.brand),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.line, width: 1.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText('total'.tr(), fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.muted),
                AppText.display(money(order.total, context), fontSize: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteBlock extends StatelessWidget {
  const _NoteBlock({required this.order, required this.lang});
  final Order order;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final note = order.localizedNote(lang);
    if (note.isEmpty && order.images.isEmpty) {
      return AppText.body('no_note'.tr(), fontSize: 15, color: AppColors.faint);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (note.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: AppColors.brandSofter, borderRadius: BorderRadius.circular(16)),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 3,
                    decoration: BoxDecoration(color: AppColors.brandBright, borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(width: 11),
                  Expanded(child: AppText.body(note, fontSize: 15.5, height: 1.55)),
                ],
              ),
            ),
          ),
        if (order.images.isNotEmpty) ...[
          const SizedBox(height: 14),
          Row(
            children: [
              AppText.label('photos'.tr()),
              const SizedBox(width: 6),
              Flexible(child: AppText('· ${'tap_hint'.tr()}', fontSize: 12.5, color: AppColors.faint, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (int i = 0; i < order.images.length; i++)
                GestureDetector(
                  onTap: () => showImageViewer(context, order.images, i),
                  child: ThumbImage(path: order.images[i], size: 96, radius: 16),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 24, 0, 11),
      child: AppText.label(text, color: AppColors.muted),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.order, required this.viewModel});
  final Order order;
  final OrderDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final advance = viewModel.advanceAction;
    if (!order.isPending && advance == null) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [AppColors.cream, AppColors.cream, Color(0x00FBFAF8)],
            stops: [0, 0.72, 1],
          ),
        ),
        child: order.isPending
            ? SwipeAccept(
                onAccept: viewModel.accept,
                onDelete: () async {
                  final confirmed = await showRejectSheet(context);
                  if (confirmed) await viewModel.reject();
                },
              )
            : PrimaryButton(
                label: advance!.labelKey.tr(),
                leadingIcon: advance.icon,
                onPressed: viewModel.advance,
              ),
      ),
    );
  }
}
