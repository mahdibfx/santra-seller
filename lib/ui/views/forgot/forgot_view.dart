import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/otp_sheet.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/top_bar.dart';
import 'forgot_viewmodel.dart';

class ForgotView extends StackedView<ForgotViewModel> {
  const ForgotView({super.key});

  @override
  Widget builder(
      BuildContext context, ForgotViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          SafeArea(
            child: viewModel.step == ForgotStep.done
                ? _DoneStep(onDone: viewModel.onDone)
                : _FormStep(viewModel: viewModel),
          ),
          if (viewModel.step == ForgotStep.code)
            OtpSheet(
              phone:
                  '+971 ${viewModel.phone}', // ponytail: forgot flow is UAE-only
              busy: viewModel.isBusy,
              onVerify: viewModel.onVerifyOtp,
              onClose: viewModel.closeOtp,
            ),
        ],
      ),
    );
  }

  @override
  ForgotViewModel viewModelBuilder(BuildContext context) => ForgotViewModel();
}

class _FormStep extends StatelessWidget {
  const _FormStep({required this.viewModel});
  final ForgotViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final arabic = context.locale.languageCode == 'ar';
    final newPass = viewModel.step == ForgotStep.newPassword;
    return FadeSlideIn(
      key: ValueKey(viewModel.step),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 14, 26, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(onBack: viewModel.onBack),
            const SizedBox(height: 22),
            AppText.displayLarge(
              newPass ? 'new_pass_title'.tr() : 'reset_title'.tr(),
              fontSize: arabic ? 34 : 38,
            ),
            const SizedBox(height: 12),
            AppText.body(
              newPass ? 'new_pass_sub'.tr() : 'reset_sub'.tr(),
              fontSize: 16.5,
              color: AppColors.muted,
            ),
            const SizedBox(height: 28),
            if (newPass) ..._passwordFields(context) else _phoneField(),
            const Spacer(),
            PrimaryButton(
              label: newPass ? 'save_pass'.tr() : 'send_code'.tr(),
              disabled: !newPass && !viewModel.phoneValid,
              onPressed:
                  newPass ? viewModel.onSavePassword : viewModel.onSendCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _phoneField() => AppTextField(
        controller: viewModel.phoneController,
        label: 'phone'.tr(),
        iconName: 'phone',
        prefix: '+971',
        hintText: '50 123 4567',
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d ]'))],
        onChanged: viewModel.onPhoneChanged,
        autofocus: true,
      );

  List<Widget> _passwordFields(BuildContext context) => [
        AppTextField(
          controller: viewModel.passwordController,
          label: 'new_pass'.tr(),
          iconName: 'lock',
          hintText: '••••••••',
          obscureText: !viewModel.showPassword,
          errorText: viewModel.passwordError,
          trailing: GestureDetector(
            onTap: viewModel.toggleShowPassword,
            child: AppIcon(viewModel.showPassword ? 'eyeOff' : 'eye',
                size: 20, color: AppColors.faint),
          ),
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: viewModel.confirmController,
          label: 'confirm_pass'.tr(),
          iconName: 'lock',
          hintText: '••••••••',
          obscureText: !viewModel.showPassword,
          errorText: viewModel.confirmError,
        ),
      ];
}

class _DoneStep extends StatelessWidget {
  const _DoneStep({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 14, 26, 28),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PopIn(
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: const BoxDecoration(
                          color: AppColors.brandSoft, shape: BoxShape.circle),
                      child: const Center(
                          child: AppIcon('checkCircle',
                              size: 48, color: AppColors.brand)),
                    ),
                  ),
                  const SizedBox(height: 26),
                  AppText.displayLarge('done_title'.tr(),
                      fontSize: 36, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  AppText.body('done_sub'.tr(),
                      fontSize: 16.5,
                      color: AppColors.muted,
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          PrimaryButton(label: 'back_to_login'.tr(), onPressed: onDone),
        ],
      ),
    );
  }
}
