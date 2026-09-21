import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/promotion_request.dart';
import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../common/format.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text.dart';
import '../../widgets/icon_square_button.dart';
import 'promotion_requests_viewmodel.dart';

class PromotionRequestsView extends StackedView<PromotionRequestsViewModel> {
  const PromotionRequestsView({super.key});

  @override
  Widget builder(BuildContext context, PromotionRequestsViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
              child: Row(
                children: [
                  IconSquareButton(iconName: 'chevronLeft', onTap: viewModel.onBack, flipForRtl: true, radius: 13, size: 42),
                  const SizedBox(width: 10),
                  AppText.displayLarge('promo_title'.tr(), fontSize: 25),
                ],
              ),
            ),
            Expanded(
              child: viewModel.isBusy
                  ? const Center(child: CircularProgressIndicator(color: AppColors.brand))
                  : viewModel.requests.isEmpty
                      ? _empty()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(18, 6, 18, 40),
                          itemCount: viewModel.requests.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final r = viewModel.requests[i];
                            return _RequestCard(request: r, onTap: () => viewModel.onOpen(r));
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty() => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(color: AppColors.brandSofter, borderRadius: BorderRadius.circular(20)),
                child: const Center(child: AppIcon('sparkle', size: 28, color: AppColors.brand)),
              ),
              const SizedBox(height: 12),
              AppText.display('promo_none'.tr(), fontSize: 19),
              const SizedBox(height: 6),
              AppText.body('promo_none_sub'.tr(), color: AppColors.muted, fontSize: 14, textAlign: TextAlign.center),
            ],
          ),
        ),
      );

  @override
  void onViewModelReady(PromotionRequestsViewModel viewModel) => viewModel.init();

  @override
  PromotionRequestsViewModel viewModelBuilder(BuildContext context) => PromotionRequestsViewModel();
}

/// Stock / signature status chip.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.value, this.attention = false});
  final String label;
  final String value;
  final bool attention;

  @override
  Widget build(BuildContext context) {
    final bg = attention ? const Color(0xFFFBF0D2) : AppColors.brandSofter;
    final fg = attention ? const Color(0xFF9A6B05) : AppColors.brand;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: AppText(value.isEmpty ? label : '$label · $value', fontSize: 12.5, fontWeight: FontWeight.w700, color: fg),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.onTap});
  final PromotionRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final r = request;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Color(0x30143232), blurRadius: 26, offset: Offset(0, 12))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: AppText.title(r.localizedName(lang), fontSize: 16, fontWeight: FontWeight.w700, maxLines: 2)),
                if (r.needsAction) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFFBE6DA), borderRadius: BorderRadius.circular(999)),
                    child: AppText('promo_action'.tr(), fontSize: 11.5, fontWeight: FontWeight.w800, color: const Color(0xFFC2410C)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const AppIcon('calendar', size: 15, color: AppColors.faint),
                const SizedBox(width: 6),
                AppText(
                  '${formatIsoDate(_day(r.startsAt), context)} – ${formatIsoDate(_day(r.expiresAt), context)}',
                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusChip(label: 'lbl_stock'.tr(), value: 'pst_${r.stockStatus}'.tr(), attention: r.needsStock),
                if (r.signatureStatus != 'not_required')
                  StatusChip(label: 'lbl_signature'.tr(), value: 'pst_${r.signatureStatus}'.tr(), attention: r.needsSignature),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _day(String iso) => iso.length >= 10 ? iso.substring(0, 10) : iso;
}
