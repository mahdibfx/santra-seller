import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/trading.dart';
import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text.dart';
import '../../widgets/pause_sheet.dart' show formatClock;
import '../../widgets/thumb_image.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(
      BuildContext context, ProfileViewModel viewModel, Widget? child) {
    final lang = context.locale.languageCode;
    final profile = viewModel.profile;

    return FadeSlideIn(
      child: RefreshIndicator(
        color: AppColors.brand,
        onRefresh: viewModel.onRefresh,
        child: SingleChildScrollView(
        // The screen usually fits, and without this it cannot be pulled.
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
            22, MediaQuery.of(context).padding.top + 16, 22, 130),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.displayLarge('profile'.tr(), fontSize: 32),
            const SizedBox(height: 18),
            _Hero(
                name: viewModel.displayName(lang),
                trading: profile?.trading ?? const Trading()),
            _Group(label: 'history_section'.tr(), rows: [
              _Row(
                  icon: 'history',
                  label: 'order_history'.tr(),
                  onTap: viewModel.onOpenHistory),
              _Row(
                  icon: 'sparkle',
                  label: 'promo_title'.tr(),
                  onTap: viewModel.onOpenPromotions),
            ]),
            _Group(label: 'prefs_section'.tr(), rows: [
              _Row(
                  icon: 'globe',
                  label: 'language_row'.tr(),
                  value: lang == 'ar' ? 'العربية' : 'English',
                  onTap: viewModel.onToggleLang),
            ]),
            _Group(label: 'support_section'.tr(), rows: [
              _Row(
                  icon: 'help',
                  label: 'help_center'.tr(),
                  onTap: viewModel.onOpenHelp),
              _Row(
                  icon: 'shield',
                  label: 'privacy_terms'.tr(),
                  onTap: viewModel.onOpenLegal),
            ]),
            const SizedBox(height: 22),
            _GroupContainer(
              child: _Row(
                  icon: 'logout',
                  label: 'log_out'.tr(),
                  danger: true,
                  onTap: viewModel.onLogout),
            ),
          ],
        ),
      ),
      ),
    );
  }

  @override
  void onViewModelReady(ProfileViewModel viewModel) => viewModel.init();

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}

class _Hero extends StatelessWidget {
  const _Hero({required this.name, required this.trading});
  final String name;
  final Trading trading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
              color: Color(0x3D143232), blurRadius: 34, offset: Offset(0, 16))
        ],
      ),
      child: Row(
        children: [
          const ThumbImage(path: '', size: 64, radius: 20, iconName: 'store'),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.display(name,
                    fontSize: 22, fontWeight: FontWeight.w600),
                const SizedBox(height: 8),
                _TradingPill(trading: trading),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.label, required this.rows});
  final String label;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 9),
            child: AppText.label(label),
          ),
          _GroupContainer(
            child: Column(
              children: [
                for (int i = 0; i < rows.length; i++) ...[
                  if (i > 0)
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(height: 1, color: AppColors.line)),
                  rows[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupContainer extends StatelessWidget {
  const _GroupContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x30143232), blurRadius: 30, offset: Offset(0, 14))
        ],
      ),
      child: child,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(
      {required this.icon,
      required this.label,
      this.value,
      this.danger = false,
      required this.onTap});
  final String icon;
  final String label;
  final String? value;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.ink;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: danger ? AppColors.dangerBg : AppColors.brandSofter,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: AppIcon(icon,
                      size: 20,
                      color: danger ? AppColors.danger : AppColors.brand)),
            ),
            const SizedBox(width: 13),
            Expanded(
                child: AppText(label,
                    fontSize: 15.5, fontWeight: FontWeight.w600, color: color)),
            if (value != null)
              AppText(value!,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.faint),
            if (!danger) ...[
              const SizedBox(width: 8),
              const AppIcon('chevronRight',
                  size: 18, color: AppColors.faint, flipForRtl: true),
            ],
          ],
        ),
      ),
    );
  }
}

/// Open / Busy / Closed, straight from `/me`'s `trading.status`.
///
/// The orders board already shows this; the profile claimed "Open now"
/// unconditionally, so the two screens contradicted each other.
class _TradingPill extends StatelessWidget {
  const _TradingPill({required this.trading});

  final Trading trading;

  @override
  Widget build(BuildContext context) {
    final until = trading.busyUntil;
    final (bg, dot, fg, label) = switch (trading.status) {
      'busy' => (
          const Color(0xFFFDF1D8),
          AppColors.warnFg,
          AppColors.warnFg,
          until == null
              ? 'pause'.tr()
              : 'busy_until'.tr(args: [formatClock(until, context)]),
        ),
      'closed' => (
          const Color(0xFFF1EFE8),
          AppColors.muted,
          AppColors.muted,
          'closed_now'.tr(),
        ),
      _ => (
          const Color(0xFFDBF3E4),
          AppColors.online,
          const Color(0xFF1B7A43),
          'open_now'.tr(),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Flexible(
            child: AppText(label,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: fg),
          ),
        ],
      ),
    );
  }
}
