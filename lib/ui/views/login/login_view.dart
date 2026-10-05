import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/otp_sheet.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/top_bar.dart';
import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    final arabic = context.locale.languageCode == 'ar';
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          SafeArea(
            child: FadeSlideIn(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(26, 14, 26, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopBar(onBack: viewModel.onBack),
                    const SizedBox(height: 22),
                    AppText.displayLarge('seller_login'.tr(),
                        fontSize: arabic ? 36 : 40),
                    const SizedBox(height: 12),
                    AppText.body('login_sub'.tr(),
                        fontSize: 16.5, color: AppColors.muted),
                    const SizedBox(height: 30),
                    AppTextField(
                      controller: viewModel.phoneController,
                      label: 'phone'.tr(),
                      iconName: 'phone',
                      prefix: viewModel.prefixLabel,
                      // UAE only — nothing to pick, so nothing to tap.
                      hintText: '50 123 4567',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d ]'))
                      ],
                      errorText: viewModel.phoneError,
                      onChanged: viewModel.onPhoneChanged,
                      autofocus: true,
                      forceLtr: true,
                    ),
                    const Spacer(),
                    PrimaryButton(
                        label: 'send_code'.tr(),
                        onPressed: viewModel.onSendCode),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.center,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '${'no_account'.tr()} '),
                            TextSpan(
                              text: 'apply'.tr(),
                              style: const TextStyle(
                                  color: AppColors.brand,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 14.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (viewModel.otpVisible)
            OtpSheet(
              phone: viewModel.fullPhone,
              busy: viewModel.isBusy,
              onVerify: viewModel.onVerifyOtp,
              onClose: viewModel.closeOtp,
            ),
        ],
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
