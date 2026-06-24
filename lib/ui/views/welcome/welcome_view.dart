import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/lang_pill.dart';
import '../../widgets/primary_button.dart';
import 'welcome_viewmodel.dart';

class WelcomeView extends StackedView<WelcomeViewModel> {
  const WelcomeView({super.key});

  @override
  Widget builder(BuildContext context, WelcomeViewModel viewModel, Widget? child) {
    final arabic = context.locale.languageCode == 'ar';
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: FadeSlideIn(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: LangPill(onToggle: viewModel.onToggleLang, onCream: true),
                ),
                const SizedBox(height: 34),
                AppText('welcome_eyebrow'.tr(),
                    fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brand, letterSpacing: 2.5),
                const SizedBox(height: 14),
                AppText.displayLarge('welcome_title'.tr(), fontSize: arabic ? 44 : 52, height: 1.04),
                const SizedBox(height: 18),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: AppText.body('welcome_sub'.tr(), fontSize: 18, color: AppColors.muted, height: 1.5),
                ),
                const Spacer(),
                PrimaryButton(label: 'get_started'.tr(), arrow: true, onPressed: viewModel.onStart),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: AppText.body('terms'.tr(), fontSize: 13, color: AppColors.faint, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  WelcomeViewModel viewModelBuilder(BuildContext context) => WelcomeViewModel();
}
