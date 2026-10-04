import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import 'app_icon.dart';
import 'app_text.dart';
import 'otp_input.dart';
import 'primary_button.dart';

/// OTP verification bottom-sheet overlay (used by login + password reset).
/// Rendered inside a screen's Stack via [Positioned.fill]; dim tap closes it.
class OtpSheet extends StatefulWidget {
  const OtpSheet(
      {super.key,
      required this.phone,
      required this.onVerify,
      required this.onClose,
      this.busy = false});

  final String phone;
  final void Function(String code) onVerify;
  final VoidCallback onClose;
  final bool busy;

  @override
  State<OtpSheet> createState() => _OtpSheetState();
}

class _OtpSheetState extends State<OtpSheet> {
  String _code = '';
  int _secs = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secs = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secs <= 1) {
        t.cancel();
        setState(() => _secs = 0);
      } else {
        setState(() => _secs--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = _code.length == 6;
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onClose,
        child: Container(
          color: const Color(0x80143232),
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
              decoration: const BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                          color: AppColors.lineStrong,
                          borderRadius: BorderRadius.circular(999))),
                  const SizedBox(height: 18),
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                        color: AppColors.brandSoft,
                        borderRadius: BorderRadius.circular(18)),
                    child: const Center(
                        child: AppIcon('message',
                            size: 28, color: AppColors.brand)),
                  ),
                  const SizedBox(height: 14),
                  AppText.display('verify_title'.tr(),
                      fontSize: 25, textAlign: TextAlign.center),
                  const SizedBox(height: 9),
                  AppText.body('verify_sub'.tr(),
                      fontSize: 15,
                      color: AppColors.muted,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: AppText(widget.phone,
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 22),
                  OtpInput(
                      length: 6, onChanged: (c) => setState(() => _code = c)),
                  const SizedBox(height: 18),
                  _secs > 0
                      ? AppText.body(
                          '${'resend_in'.tr()} 0:${_secs.toString().padLeft(2, '0')}',
                          fontSize: 14.5,
                          color: AppColors.muted)
                      : GestureDetector(
                          onTap: _startCountdown,
                          child: Text('resend'.tr(),
                              style: AppTextStyles.body(context,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brand)),
                        ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'verify'.tr(),
                    disabled: !done || widget.busy,
                    onPressed: done && !widget.busy
                        ? () => widget.onVerify(_code)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
