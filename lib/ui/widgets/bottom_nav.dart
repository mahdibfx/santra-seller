import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import 'app_icon.dart';
import 'app_text.dart';

/// Floating pill navigation: Profile · Orders · Assistant.
class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.active, required this.onNavigate});

  /// One of: 'profile', 'orders', 'chat'.
  final String active;
  final ValueChanged<String> onNavigate;

  static const _items = [
    ('profile', 'user'),
    ('orders', 'bag'),
    ('chat', 'sparkle'),
  ];

  /// Tabs that are built but not released yet — shown greyed with a "Soon" tag.
  static const _comingSoon = {'chat'};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [AppColors.cream, AppColors.cream, Color(0x00FBFAF8)],
          stops: [0, 0.74, 1],
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.line),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x57143232),
                  blurRadius: 32,
                  offset: Offset(0, 14))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (key, icon) in _items)
                _NavButton(
                  icon: icon,
                  active: key == active,
                  disabled: _comingSoon.contains(key),
                  onTap: () => onNavigate(key),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.active,
    required this.onTap,
    this.disabled = false,
  });

  final String icon;
  final bool active;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (disabled) return _SoonButton(icon: icon);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 62,
          height: 50,
          decoration: BoxDecoration(
            color: active ? AppColors.brand : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: active
                ? const [
                    BoxShadow(
                        color: AppColors.brandShadow,
                        blurRadius: 18,
                        offset: Offset(0, 8))
                  ]
                : null,
          ),
          child: Center(
            child: AppIcon(icon,
                size: 24, color: active ? Colors.white : AppColors.muted),
          ),
        ),
      ),
    );
  }
}

/// A tab that isn't live yet: greyed out, inert, tagged "Soon".
class _SoonButton extends StatelessWidget {
  const _SoonButton({required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: SizedBox(
        width: 62,
        height: 50,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.45,
              child: AppIcon(icon, size: 24, color: AppColors.faint),
            ),
            PositionedDirectional(
              top: 1,
              end: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.brandSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: AppText('soon'.tr(),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brand),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
