import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/order.dart';
import '../../../models/order_item.dart';
import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../common/app_text_styles.dart';
import '../../common/format.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/image_viewer.dart';
import '../../widgets/meta_chips.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/swipe_to_confirm.dart';
import '../../widgets/cancel_order_sheet.dart';
import '../../widgets/unavailable_sheet.dart';
import '../../widgets/status_pill.dart';
import '../../widgets/thumb_image.dart';
import '../../widgets/timer_badge.dart';
import '../../widgets/top_bar.dart';
import '../product_preview/product_preview_view.dart';
import 'order_detail_viewmodel.dart';

class OrderDetailView extends StackedView<OrderDetailViewModel> {
  const OrderDetailView({super.key, required this.orderId});

  final int orderId;

  @override
  Widget builder(
      BuildContext context, OrderDetailViewModel viewModel, Widget? child) {
    final order = viewModel.order;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: viewModel.isBusy || order == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.brand))
          : FadeSlideIn(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            22, MediaQuery.of(context).padding.top + 8, 22, 0),
                        child: TopBar(
                            onBack: viewModel.onBack,
                            right: StatusPill(status: order.status)),
                      ),
                      Expanded(
                          child: _Body(order: order, viewModel: viewModel)),
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
  OrderDetailViewModel viewModelBuilder(BuildContext context) =>
      OrderDetailViewModel(orderId: orderId);
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
          AppText.displayLarge(
              '${'order'.tr()} #${order.orderNumber.isNotEmpty ? order.orderNumber : order.id}',
              fontSize: 32),
          const SizedBox(height: 7),
          // Three separate facts that all used to be one line showing only
          // `deliver` — which is the slot LABEL ("standard", "express"), not a
          // date. Shops were asking when the order is due and when it came in,
          // and neither was on the screen.
          _DateLine(
            icon: 'calendar',
            label: 'delivery_on'.tr(),
            value: order.deliveryDate.isEmpty
                ? ''
                : formatIsoDate(order.deliveryDate, context),
            trailing: order.deliver,
          ),
          _DateLine(
            icon: 'clock',
            label: 'placed_on'.tr(),
            value: formatPlacedAt(order.createdAt, context),
          ),
          const SizedBox(height: 16),
          // One row: what kind of order on the start side, how long it has
          // waited on the end. Two rows left the timer floating on its own.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: MetaChips(order: order)),
              if (order.hasTimer) ...[
                const SizedBox(width: 8),
                TimerBadge(order: order, inline: true),
              ],
            ],
          ),
          const SizedBox(height: 20),
          _CustomerCard(order: order, lang: lang),
          if (viewModel.needsRefundDetails)
            _RefundBankCard(viewModel: viewModel),
          _SectionLabel('order_items'.tr()),
          _ItemsCard(order: order),
          if (order.shortages.isNotEmpty)
            _ShortageLine(order: order, lang: lang),
          if (order.canReportUnavailable)
            _ReportUnavailableLink(order: order, viewModel: viewModel),
          if (order.addons.isNotEmpty) ...[
            _SectionLabel('addons_title'.tr()),
            _AddonsCard(order: order, lang: lang),
          ],
          // Order-level note only — per-item requests render with their item.
          if (order.localizedNote(lang).isNotEmpty ||
              order.images.isNotEmpty) ...[
            _SectionLabel('note_title'.tr()),
            _NoteBlock(order: order, lang: lang),
          ],
        ],
      ),
    );
  }
}

/// Santra is refunding this (shop-entered) order and needs the customer's
/// account. Write-only — the IBAN is never shown back.
/// Where the order goes. Santra only tells a shop the emirate — never the
/// address — so a missing one is spelled out rather than left blank.
String destinationOf(Order o, String lang) {
  final emirate = o.deliveryEmirate?.displayName(lang) ?? '';
  if (emirate.isNotEmpty) return emirate;
  return o.isPickup ? 'emirate_pickup'.tr() : 'emirate_unknown'.tr();
}

class _RefundBankCard extends StatelessWidget {
  const _RefundBankCard({required this.viewModel});
  final OrderDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brandSoft, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    color: AppColors.brandSofter,
                    borderRadius: BorderRadius.circular(11)),
                child: const Center(
                    child: AppIcon('wallet', size: 18, color: AppColors.brand)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppText('refund_bank_title'.tr(),
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppText.body(
            'refund_bank_hint'
                .tr(args: [money(viewModel.refundAmount, context)]),
            fontSize: 14.5,
            color: AppColors.muted,
            height: 1.45,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: viewModel.accountNameController,
            label: 'refund_account_name'.tr(),
            iconName: 'user',
            onChanged: viewModel.onRefundFieldChanged,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: viewModel.ibanController,
            label: 'refund_iban'.tr(),
            iconName: 'wallet',
            hintText: 'AE07 0331 2345 6789 0123 456',
            forceLtr: true,
            errorText: viewModel.refundError,
            onChanged: viewModel.onRefundFieldChanged,
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'refund_send'.tr(),
            disabled: !viewModel.canSendRefund,
            onPressed: viewModel.canSendRefund
                ? viewModel.sendRefundBankDetails
                : null,
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.order, required this.lang});
  final Order order;
  final String lang;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: AppColors.brandSoft,
                    borderRadius: BorderRadius.circular(13)),
                child: const Center(
                    child: AppIcon('user', size: 22, color: AppColors.brand)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.label('customer'.tr()),
                    const SizedBox(height: 2),
                    AppText(order.customer,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    // Only on the shop's own orders: on an app order Santra
                    // keeps the destination to itself.
                    if (order.isManual) ...[
                      const SizedBox(height: 3),
                      // No leading icon: it pushed the city an icon's width in
                      // from the name directly above it, which read as centred
                      // rather than aligned. The address row below carries the
                      // location icon already.
                      AppText(destinationOf(order, lang),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.muted,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // Only a manual order carries these: they are the details the shop
          // typed itself. App orders are masked to a first name + emirate.
          if (order.customerPhone.isNotEmpty) ...[
            const _CardDivider(),
            _DetailRow(
              icon: 'phone',
              label: 'phone'.tr(),
              value: order.customerPhone,
              ltrValue: true,
              onTap: () => launchUrl(Uri(
                  scheme: 'tel',
                  path: order.customerPhone.replaceAll(' ', ''))),
            ),
          ],
          if (order.fullAddress.isNotEmpty) ...[
            const _CardDivider(),
            _DetailRow(
                icon: 'location',
                label: 'address_label'.tr(),
                value: order.fullAddress),
          ],
          if (order.deliveryInstructions.isNotEmpty) ...[
            const _CardDivider(),
            _DetailRow(
                icon: 'note',
                label: 'instructions_label'.tr(),
                value: order.deliveryInstructions),
          ],
        ],
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(height: 1, color: AppColors.line),
      );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.ltrValue = false,
    this.onTap,
  });

  final String icon;
  final String label;
  final String value;

  final bool ltrValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppText(value,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: onTap == null ? AppColors.ink : AppColors.brand);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: AppIcon(icon, size: 17, color: AppColors.faint),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.label(label),
                const SizedBox(height: 3),
                // A phone number always READS left-to-right (+213 553…), but
                // it still belongs on the side the rest of the card sits on.
                // `AlignmentDirectional.centerStart` was resolved INSIDE the
                // forced-LTR scope, so "start" meant left even in Arabic and
                // the number sat alone against the far edge.
                ltrValue
                    ? Align(
                        alignment:
                            Directionality.of(context) == TextDirection.rtl
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Directionality(
                            textDirection: TextDirection.ltr, child: text),
                      )
                    : text,
              ],
            ),
          ),
          if (onTap != null)
            const AppIcon('chevronRight',
                size: 16, color: AppColors.faint, flipForRtl: true),
        ],
      ),
    );
  }
}

/// Deliberately a quiet text link, not a button among the actions: it is a
/// rare, awkward thing to do, and the server decides when it is offered.
class _ReportUnavailableLink extends StatelessWidget {
  const _ReportUnavailableLink({required this.order, required this.viewModel});
  final Order order;
  final OrderDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: GestureDetector(
        onTap: () async {
          final report = await showUnavailableSheet(context, order);
          if (report != null) await viewModel.reportUnavailable(report);
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            const AppIcon('message', size: 15, color: AppColors.brand),
            const SizedBox(width: 7),
            // The question in grey, the action in brand purple: it reads as
            // the link it is.
            Flexible(
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: '${'report_unavailable_question'.tr()} '),
                  TextSpan(
                    text: 'report_unavailable_action'.tr(),
                    style: const TextStyle(color: AppColors.brand),
                  ),
                ]),
                style: AppTextStyles.body(context,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// What the shop already reported, and that Santra passed it on.
class _ShortageLine extends StatelessWidget {
  const _ShortageLine({required this.order, required this.lang});
  final Order order;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final units = order.shortages
        .map((s) => '${s.quantity}× ${s.displayName(lang)}')
        .join(', ');
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const AppIcon('x', size: 16, color: AppColors.dangerFg),
          const SizedBox(width: 9),
          Expanded(
            // On the shop's OWN order Santra only reaches the customer if
            // they use the Santra app, and does not say which — so never
            // promise that the customer has been told.
            child: AppText(
                (order.isManual ? 'shortage_line_manual' : 'shortage_line')
                    .tr(args: [units]),
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.dangerFg),
          ),
        ],
      ),
    );
  }
}

/// Extras the customer paid for. Their prices are inside the order total
/// already, so this card shows them without adding anything up.
class _AddonsCard extends StatelessWidget {
  const _AddonsCard({required this.order, required this.lang});
  final Order order;
  final String lang;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          for (int i = 0; i < order.addons.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: i < order.addons.length - 1
                      ? const BorderSide(color: AppColors.line)
                      : BorderSide.none,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: AppColors.brandSofter,
                        borderRadius: BorderRadius.circular(11)),
                    child: const Center(
                        child:
                            AppIcon('gift', size: 18, color: AppColors.brand)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText(order.addons[i].displayName(lang),
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  AppText(money(order.addons[i].totalPrice, context),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted),
                  const SizedBox(width: 10),
                  Container(
                    constraints: const BoxConstraints(minWidth: 32),
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.brandSoft,
                        borderRadius: BorderRadius.circular(9)),
                    child: AppText('${order.addons[i].quantity}×',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brand),
                  ),
                ],
              ),
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
      decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          _ItemsSummary(order: order),
          for (int i = 0; i < order.items.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.line))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kitchen-ticket order: HOW MANY first, then what, then how.
                  // The whole row opens the product, read-only; the request
                  // block below stays outside so its photos keep their own tap.
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        ProductPreviewView.open(context, order.items[i]),
                    child: Row(
                      // A name with options under it reads top-down; a lone
                      // name sat at the top of the photo with a gap below.
                      crossAxisAlignment: order.items[i].modifiers.isEmpty &&
                              order.items[i].unavailableQuantity == 0
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: _qtyWidth,
                          child: AppText('${order.items[i].qty}×',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.brand),
                        ),
                        ThumbImage(
                            path: order.items[i].image, size: 40, radius: 10),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(order.items[i].displayName(lang),
                                  fontSize: 15.5, fontWeight: FontWeight.w600),
                              // What the customer actually chose. Without this
                              // the shop reads "Cake ×1" and has to phone them
                              // to find out which cake.
                              for (final g
                                  in order.items[i].groupedModifiers(lang)) ...[
                                const SizedBox(height: 3),
                                _ModifierLine(
                                    group: g.key, options: g.value, lang: lang),
                              ],
                              if (order.items[i].unavailableQuantity > 0) ...[
                                const SizedBox(height: 3),
                                AppText(
                                  'not_available_count'.tr(args: [
                                    '${order.items[i].unavailableQuantity}×'
                                  ]),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.dangerFg,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Same cue as every other row that opens something, in brand purple
                        // so it reads as tappable.
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: AppIcon('chevronRight',
                              size: 16,
                              color: AppColors.brand,
                              flipForRtl: true),
                        ),
                      ],
                    ),
                  ),
                  if (order.items[i].hasRequest)
                    _ItemRequest(item: order.items[i]),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: AppColors.line, width: 1.5))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText('total'.tr(),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted),
                    AppText.display(money(order.total, context), fontSize: 24),
                  ],
                ),
                // What the courier actually collects once units came off a
                // cash order. The server works it out; never recompute it.
                if (order.amountDue != null &&
                    order.amountDue != order.total) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText('amount_due_label'.tr(),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted),
                      AppText(money(order.amountDue!, context),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brand),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Width of the quantity column, so names and notes line up down the card.
const double _qtyWidth = 40;

/// "3 items · 7 units", plus how many lines carry a special request — read
/// before scrolling, so a long order does not hide one.
class _ItemsSummary extends StatelessWidget {
  const _ItemsSummary({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final lines = order.items.length;
    final units = order.items.fold<int>(0, (n, it) => n + it.qty);
    final requests = order.items.where((it) => it.hasRequest).length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              '$lines ${lines == 1 ? 'item'.tr() : 'items'.tr()} · '
              '$units ${units == 1 ? 'unit'.tr() : 'units'.tr()}',
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.muted,
            ),
          ),
          if (requests > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                  color: AppColors.warnBg,
                  borderRadius: BorderRadius.circular(8)),
              child: AppText('with_requests_count'.tr(args: ['$requests']),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warnFg),
            ),
        ],
      ),
    );
  }
}

/// The customer's request for one line — their words plus any reference
/// photos they attached to it.
class _ItemRequest extends StatelessWidget {
  const _ItemRequest({required this.item});
  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    // From the item photo's edge (past the quantity), on the START side so
    // Arabic lines up too: wide enough for a long request, still inside the
    // item's row. Amber, not brand purple: the line a kitchen must not miss.
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8, start: _qtyWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.note.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.warnBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(top: 2, end: 6),
                    child: AppIcon('note', size: 14, color: AppColors.warnFg),
                  ),
                  Expanded(
                    child: AppText.body(item.note, fontSize: 13.5, height: 1.4),
                  ),
                ],
              ),
            ),
          if (item.images.isNotEmpty || item.files.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (int i = 0; i < item.images.length; i++)
                  GestureDetector(
                    onTap: () => showImageViewer(context, item.images, i),
                    child:
                        ThumbImage(path: item.images[i], size: 52, radius: 10),
                  ),
                // A PDF has no thumbnail. It opens in an in-app browser sheet
                // (Done returns to the order) rather than leaving for Safari.
                for (final url in item.files)
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse(url),
                        mode: LaunchMode.inAppBrowserView),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.brandSofter,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.brandSoft),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppIcon('note', size: 18, color: AppColors.brand),
                          SizedBox(height: 2),
                          AppText('PDF',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.brand),
                        ],
                      ),
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

class _NoteBlock extends StatelessWidget {
  const _NoteBlock({required this.order, required this.lang});
  final Order order;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final note = order.localizedNote(lang);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (note.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: AppColors.brandSofter,
                borderRadius: BorderRadius.circular(16)),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 3,
                    decoration: BoxDecoration(
                        color: AppColors.brandBright,
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                      child: AppText.body(note, fontSize: 15.5, height: 1.55)),
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
              Flexible(
                  child: AppText('· ${'tap_hint'.tr()}',
                      fontSize: 12.5,
                      color: AppColors.faint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
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
                  child:
                      ThumbImage(path: order.images[i], size: 96, radius: 16),
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
    final accept = viewModel.canAccept;
    final cancel = viewModel.canCancel;
    final state = viewModel.stateLine;
    if (!accept && !cancel && advance == null && state == null) {
      return const SizedBox.shrink();
    }

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // A forward step standing alone is swiped, not tapped: it is one
            // careless touch away and it cannot be undone — "mark ready"
            // sends a driver for a box nobody packed. Accept/cancel keep
            // plain buttons; there the shop is choosing, not confirming.
            if (!accept && !cancel && advance == null && state != null)
              _StateLine(textKey: state.key, icon: state.icon)
            else if (!accept && advance != null && !cancel)
              SwipeToConfirm(
                label: advance.labelKey.tr(),
                onConfirmed: viewModel.advance,
              )
            else
              Row(
                children: [
                  if (accept)
                    Expanded(
                      child: PrimaryButton(
                        label: 'accept'.tr(),
                        leadingIcon: 'check',
                        onPressed: viewModel.accept,
                      ),
                    )
                  else if (advance != null)
                    Expanded(
                      child: PrimaryButton(
                        label: advance.labelKey.tr(),
                        leadingIcon: advance.icon,
                        onPressed: viewModel.advance,
                      ),
                    ),
                  if (cancel) ...[
                    if (accept || advance != null) const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        label: 'cancel'.tr(),
                        variant: ButtonVariant.dangerOutline,
                        onPressed: () =>
                            runCancelFlow(context, order, viewModel.cancel),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// One "label: value" line under the order number. Renders nothing when the
/// server sent no value, so a missing field is a missing row rather than a
/// label with a blank beside it.
class _DateLine extends StatelessWidget {
  const _DateLine({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing = '',
  });

  final String icon;
  final String label;
  final String value;

  /// `scheduled_slot_label` — the delivery WINDOW, shown after the date.
  ///
  /// The backend currently puts other things in this field: an interim that
  /// writes the dates into it, and a cancellation note on cancelled orders
  /// ("Cancelled 12 Oct 16:02"). Both are temporary and get reverted, so the
  /// row keeps rendering it rather than being rebuilt twice.
  final String trailing;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    // The backend's interim "Deliver 21 Sept" repeats the date just shown.
    // ponytail: drop this check when the field is back to slot labels only.
    final repeatsDate = trailing.toLowerCase().startsWith('deliver');
    final suffix = trailing.isEmpty || repeatsDate ? '' : '  \u00b7  $trailing';
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        children: [
          AppIcon(icon, size: 15, color: AppColors.muted),
          const SizedBox(width: 6),
          Flexible(
            child: AppText('$label: $value$suffix',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

/// One chosen option under its item: "Size: 10 inch ×2".
///
/// The group is named as well as the option — "Chocolate" alone does not say
/// whether it is the sponge, the filling or the drip.
class _ModifierLine extends StatelessWidget {
  const _ModifierLine(
      {required this.group, required this.options, required this.lang});

  final String group;
  final List<OrderModifier> options;
  final String lang;

  @override
  Widget build(BuildContext context) {
    // Arabic uses its own comma; a Latin one reads as a typo mid-sentence.
    final separator = lang == 'ar' ? '\u060c ' : ', ';
    final name = [
      for (final o in options)
        o.displayName(lang) + (o.quantity > 1 ? ' \u00d7${o.quantity}' : '')
    ].join(separator);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.only(top: 5, end: 7),
          child: SizedBox(
            width: 4,
            height: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.muted,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        // The group is the label, the choice is the answer: a shop scanning
        // the card reads "10 inch, Chocolate, Nuts" without the labels.
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                if (group.isNotEmpty) TextSpan(text: '$group: '),
                TextSpan(
                  text: name,
                  style: const TextStyle(
                      color: AppColors.ink, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            style: AppTextStyles.body(context,
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: AppColors.muted),
          ),
        ),
      ],
    );
  }
}

/// Where the order is now, in the spot the action button occupies — so the
/// bottom of the page always answers "what happens next", whether or not the
/// shop is the one who has to do it.
class _StateLine extends StatelessWidget {
  const _StateLine({required this.textKey, required this.icon});
  final String textKey;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lineStrong, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(icon, size: 20, color: AppColors.muted),
          const SizedBox(width: 10),
          Flexible(
            child: AppText(
              textKey.tr(),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
