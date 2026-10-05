import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/primary_button.dart';

/// Shown instead of the app when this build is below the server's
/// `minVersion`. No way back — the old build is no longer allowed to run.
///
/// Pushed with a plain route from [WelcomeViewModel], so it needs no entry in
/// the generated router.
class UpdateRequiredView extends StatelessWidget {
  const UpdateRequiredView({super.key, required this.storeUrl});

  /// Empty when the server sent no link and there is no fallback (iOS).
  final String storeUrl;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.system_update_rounded,
                    size: 64, color: AppColors.brand),
                const SizedBox(height: 20),
                AppText('update_required_title'.tr(),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                AppText('update_required_body'.tr(),
                    color: AppColors.muted, textAlign: TextAlign.center),
                if (storeUrl.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: 'update_now'.tr(),
                    onPressed: () => launchUrl(Uri.parse(storeUrl),
                        mode: LaunchMode.externalApplication),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
