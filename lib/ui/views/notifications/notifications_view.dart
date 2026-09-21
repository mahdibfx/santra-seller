import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/app_notification.dart';
import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../common/app_text_styles.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text.dart';
import '../../widgets/top_bar.dart';
import 'notifications_viewmodel.dart';

class NotificationsView extends StackedView<NotificationsViewModel> {
  const NotificationsView({super.key});

  @override
  Widget builder(BuildContext context, NotificationsViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(22, MediaQuery.of(context).padding.top + 8, 22, 0),
              child: TopBar(
                onBack: viewModel.onBack,
                right: viewModel.hasUnread
                    ? GestureDetector(
                        onTap: viewModel.markAll,
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.line, width: 1.5),
                          ),
                          child: Text('mark_all_read'.tr(),
                              style: AppTextStyles.body(context, fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.brand)),
                        ),
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 4),
              child: AppText.displayLarge('notifications'.tr(), fontSize: 32),
            ),
            Expanded(
              child: viewModel.isBusy
                  ? const Center(child: CircularProgressIndicator(color: AppColors.brand))
                  : viewModel.items.isEmpty
                      ? _empty()
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 40),
                          children: [
                            _group(context, 'notif_today'.tr(), viewModel.groupItems(NotifGroup.today), viewModel),
                            _group(context, 'notif_earlier'.tr(), viewModel.groupItems(NotifGroup.earlier), viewModel),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _group(BuildContext context, String label, List<AppNotification> rows, NotificationsViewModel vm) {
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
          child: AppText.label(label),
        ),
        for (final n in rows) _NotifRow(notification: n, onTap: () => vm.onTap(n)),
        const SizedBox(height: 8),
      ],
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
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: AppColors.brandSofter, borderRadius: BorderRadius.circular(22)),
              child: const Center(child: AppIcon('bell', size: 30, color: AppColors.brand)),
            ),
            const SizedBox(height: 14),
            AppText.display('no_notifs'.tr(), fontSize: 20),
            const SizedBox(height: 6),
            AppText.body('no_notifs_sub'.tr(), color: AppColors.muted, fontSize: 14.5, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(NotificationsViewModel viewModel) => viewModel.init();

  @override
  NotificationsViewModel viewModelBuilder(BuildContext context) => NotificationsViewModel();
}

class _NotifRow extends StatelessWidget {
  const _NotifRow({required this.notification, required this.onTap});
  final AppNotification notification;
  final VoidCallback onTap;

  ({Color bg, Color fg}) get _tone => switch (notification.tone) {
        NotifTone.green => (bg: const Color(0xFFDBF3E4), fg: const Color(0xFF1B7A43)),
        NotifTone.amber => (bg: const Color(0xFFFBF0D2), fg: const Color(0xFF9A6B05)),
        NotifTone.brand => (bg: AppColors.brandSoft, fg: AppColors.brand),
      };

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final tone = _tone;
    final unread = notification.unread;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: unread ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: unread ? const [BoxShadow(color: Color(0x30143232), blurRadius: 30, offset: Offset(0, 14))] : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: tone.bg, borderRadius: BorderRadius.circular(13)),
              child: Center(child: AppIcon(notification.icon, size: 21, color: tone.fg)),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppText(notification.localizedTitle(lang),
                            fontSize: 15.5, fontWeight: unread ? FontWeight.w700 : FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      AppText(notification.localizedTime(lang), fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.faint),
                      if (unread) ...[
                        const SizedBox(width: 6),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: AppColors.brandBright, shape: BoxShape.circle),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppText.body(notification.localizedBody(lang), fontSize: 14, color: AppColors.muted, height: 1.45),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
