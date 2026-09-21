import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/promotion_request.dart';
import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../common/format.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/icon_square_button.dart';
import '../../widgets/primary_button.dart';
import '../promotion_requests/promotion_requests_view.dart' show StatusChip;
import 'promotion_request_detail_viewmodel.dart';

class PromotionRequestDetailView extends StackedView<PromotionRequestDetailViewModel> {
  const PromotionRequestDetailView({super.key, required this.requestId});
  final int requestId;

  @override
  Widget builder(BuildContext context, PromotionRequestDetailViewModel viewModel, Widget? child) {
    final lang = context.locale.languageCode;
    final r = viewModel.request;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
              child: Row(
                children: [
                  IconSquareButton(iconName: 'chevronLeft', onTap: viewModel.onBack, flipForRtl: true, radius: 13, size: 42),
                  const SizedBox(width: 10),
                  Expanded(child: AppText.displayLarge('promo_title'.tr(), fontSize: 22)),
                ],
              ),
            ),
            Expanded(
              child: (viewModel.isBusy && r == null)
                  ? const Center(child: CircularProgressIndicator(color: AppColors.brand))
                  : r == null
                      ? Center(child: AppText('promo_none'.tr(), color: AppColors.muted))
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(18, 6, 18, 40),
                          children: [
                            _OfferCard(request: r, lang: lang),
                            const SizedBox(height: 14),
                            _CostShareCard(partnerShare: r.partnerShare),
                            if (r.products.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              _ProductsCard(products: r.products, lang: lang),
                            ],
                            const SizedBox(height: 18),
                            _Actions(viewModel: viewModel, request: r),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(PromotionRequestDetailViewModel viewModel) => viewModel.init();

  @override
  PromotionRequestDetailViewModel viewModelBuilder(BuildContext context) =>
      PromotionRequestDetailViewModel(requestId: requestId);
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Color(0x30143232), blurRadius: 26, offset: Offset(0, 12))],
        ),
        child: child,
      );
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.request, required this.lang});
  final PromotionRequest request;
  final String lang;

  String _day(String iso) => iso.length >= 10 ? iso.substring(0, 10) : iso;

  @override
  Widget build(BuildContext context) {
    final r = request;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title(r.localizedName(lang), fontSize: 19, fontWeight: FontWeight.w700),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            StatusChip(label: 'promo_type'.tr(), value: 'pt_${r.type}'.tr()),
            StatusChip(label: 'promo_applies_to'.tr(), value: 'ad_${r.appliesToDelivery}'.tr()),
            if (r.minCartAmount != null && r.minCartAmount! > 0)
              StatusChip(label: 'promo_min_cart'.tr(), value: money(r.minCartAmount!, context)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            const AppIcon('calendar', size: 16, color: AppColors.faint),
            const SizedBox(width: 8),
            AppText(
              '${formatIsoDate(_day(r.startsAt), context)} – ${formatIsoDate(_day(r.expiresAt), context)}',
              fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.muted,
            ),
          ]),
        ],
      ),
    );
  }
}

class _CostShareCard extends StatelessWidget {
  const _CostShareCard({required this.partnerShare});
  final int partnerShare;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.label('promo_your_cost'.tr()),
          const SizedBox(height: 6),
          AppText.display('$partnerShare%', fontSize: 40, color: AppColors.brand),
          const SizedBox(height: 2),
          AppText.body('promo_you_pay'.tr(namedArgs: {'n': '$partnerShare'}),
              fontSize: 14.5, color: AppColors.muted),
        ],
      ),
    );
  }
}

class _ProductsCard extends StatelessWidget {
  const _ProductsCard({required this.products, required this.lang});
  final List<RequestProduct> products;
  final String lang;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.label('promo_products'.tr()),
          const SizedBox(height: 8),
          for (int i = 0; i < products.length; i++) ...[
            if (i > 0) const Divider(height: 18, color: AppColors.line),
            Row(
              children: [
                Expanded(child: AppText(products[i].localizedName(lang), fontSize: 15, fontWeight: FontWeight.w600, maxLines: 2)),
                const SizedBox(width: 8),
                if (products[i].trackInventory)
                  AppText('${products[i].stockQuantity}', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.muted),
                const SizedBox(width: 8),
                StatusChip(
                  label: 'av_${products[i].availabilityStatus}'.tr(),
                  value: '',
                  attention: products[i].availabilityStatus != 'online',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.viewModel, required this.request});
  final PromotionRequestDetailViewModel viewModel;
  final PromotionRequest request;

  @override
  Widget build(BuildContext context) {
    final r = request;
    final children = <Widget>[];

    if (r.needsStock) {
      children.add(AppText.label('promo_stock_q'.tr()));
      children.add(const SizedBox(height: 8));
      children.add(Row(
        children: [
          Expanded(
            child: PrimaryButton(
              label: 'promo_confirm_stock'.tr(),
              leadingIcon: 'check',
              height: 50,
              borderRadius: 15,
              fontSize: 15,
              onPressed: viewModel.confirmStock,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PrimaryButton(
              label: 'promo_cannot_supply'.tr(),
              variant: ButtonVariant.dangerOutline,
              height: 50,
              borderRadius: 15,
              fontSize: 15,
              onPressed: viewModel.declineStock,
            ),
          ),
        ],
      ));
    }

    if (r.needsSignature) {
      if (children.isNotEmpty) children.add(const SizedBox(height: 20));
      children.add(AppText.label('promo_signature_q'.tr()));
      children.add(const SizedBox(height: 8));
      children.add(AppTextField(
        controller: viewModel.nameController,
        label: 'promo_full_name'.tr(),
        iconName: 'user',
        hintText: 'promo_full_name'.tr(),
      ));
      children.add(const SizedBox(height: 10));
      children.add(Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.brandSofter, borderRadius: BorderRadius.circular(12)),
        child: AppText.body('promo_sign_hint'.tr(namedArgs: {'n': '${r.partnerShare}'}),
            fontSize: 13, color: AppColors.brand),
      ));
      children.add(const SizedBox(height: 12));
      children.add(PrimaryButton(label: 'promo_sign_accept'.tr(), leadingIcon: 'checkCircle', onPressed: viewModel.signAccept));
      children.add(const SizedBox(height: 10));
      children.add(PrimaryButton(label: 'promo_decline'.tr(), variant: ButtonVariant.dangerOutline, onPressed: viewModel.signDecline));
    }

    if (!r.needsAction) {
      children.add(_Card(
        child: Row(
          children: [
            const AppIcon('checkCircle', size: 20, color: AppColors.successFg),
            const SizedBox(width: 10),
            Expanded(child: AppText('promo_answered'.tr(), fontSize: 14.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ));
      children.add(const SizedBox(height: 12));
      children.add(Wrap(spacing: 8, runSpacing: 8, children: [
        StatusChip(label: 'lbl_stock'.tr(), value: 'pst_${r.stockStatus}'.tr()),
        if (r.signatureStatus != 'not_required')
          StatusChip(label: 'lbl_signature'.tr(), value: 'pst_${r.signatureStatus}'.tr()),
      ]));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
