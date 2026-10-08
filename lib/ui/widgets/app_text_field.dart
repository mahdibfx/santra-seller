import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/app_colors.dart';
import '../common/app_spacing.dart';
import '../common/app_text_styles.dart';
import 'app_icon.dart';
import 'app_text.dart';

/// The project's single text-input primitive. Controllers are owned and
/// disposed by the ViewModel — pass one in.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.iconName,
    this.prefix,
    this.onPrefixTap,
    this.hintText,
    this.errorText,
    this.trailing,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
    this.autofocus = false,
    this.forceLtr = false,
    this.readOnly = false,
  });

  /// Locks the field without greying it out — used while the OTP sheet is up,
  /// so the number the code was sent to cannot change underneath it.
  final bool readOnly;

  final TextEditingController? controller;
  final String? label;
  final String? iconName;
  final String? prefix;

  /// When set, the prefix becomes a tappable chip (e.g. country-code picker).
  final VoidCallback? onPrefixTap;
  final String? hintText;
  final String? errorText;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool autofocus;

  /// Pin the input row + typed text to left-to-right (e.g. phone numbers in RTL).
  final bool forceLtr;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _node = FocusNode()..addListener(_onFocus);
  bool _focused = false;

  void _onFocus() => setState(() => _focused = _node.hasFocus);

  @override
  void dispose() {
    _node.removeListener(_onFocus);
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final Color borderColor = hasError
        ? const Color(0xFFE8868B)
        : _focused
            ? AppColors.brand
            : AppColors.lineStrong;
    final double borderWidth = _focused && !hasError ? 2 : 1.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AppText.caption(widget.label!, color: AppColors.muted, fontSize: 13),
          const SizedBox(height: 8),
        ],
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.input),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Directionality(
            textDirection: widget.forceLtr
                ? TextDirection.ltr
                : Directionality.of(context),
            child: Row(
              children: [
                if (widget.iconName != null) ...[
                  AppIcon(widget.iconName!,
                      size: 20,
                      color: _focused ? AppColors.brand : AppColors.faint),
                  const SizedBox(width: 10),
                ],
                if (widget.prefix != null) ...[
                  GestureDetector(
                    onTap: widget.onPrefixTap,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        AppText(widget.prefix!,
                            fontSize: 17, fontWeight: FontWeight.w500),
                        if (widget.onPrefixTap != null)
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              size: 20, color: AppColors.faint),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: TextField(
                    readOnly: widget.readOnly,
                    controller: widget.controller,
                    focusNode: _node,
                    autofocus: widget.autofocus,
                    obscureText: widget.obscureText,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    maxLength: widget.maxLength,
                    onChanged: widget.onChanged,
                    textDirection: widget.forceLtr ? TextDirection.ltr : null,
                    textAlign:
                        widget.forceLtr ? TextAlign.left : TextAlign.start,
                    cursorColor: AppColors.brand,
                    style: AppTextStyles.body(context,
                        fontSize: 17, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      counterText: '',
                      hintText: widget.hintText,
                      hintStyle: AppTextStyles.body(context,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.faint),
                    ),
                  ),
                ),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          AppText.caption(widget.errorText!,
              color: const Color(0xFFC03B41), fontSize: 13),
        ],
      ],
    );
  }
}
