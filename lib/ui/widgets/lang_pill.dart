import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import 'app_icon.dart';

/// Pill that toggles the app language (globe · current language · chevron).
class LangPill extends StatelessWidget {
  const LangPill({super.key, required this.onToggle, this.onCream = false});

  final VoidCallback onToggle;
  final bool onCream;

  @override
  Widget build(BuildContext context) {
    final arabic = Localizations.localeOf(context).languageCode == 'ar';
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: onCream ? Colors.white : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.line),
          boxShadow: const [BoxShadow(color: Color(0x40143232), blurRadius: 10, offset: Offset(0, 2))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon('globe', size: 18, color: AppColors.brand),
            const SizedBox(width: 8),
            Text(arabic ? 'العربية' : 'English',
                style: AppTextStyles.body(context, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            const AppIcon('chevronDown', size: 16, color: AppColors.faint),
          ],
        ),
      ),
    );
  }
}
