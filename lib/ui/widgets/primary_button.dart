import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import 'app_icon.dart';

enum ButtonVariant { solid, soft, ghost, danger }

/// Primary CTA. Variants mirror the design (solid / soft / ghost / danger),
/// with a subtle scale-down on press, an optional leading icon, and an optional
/// trailing arrow (auto-flips in RTL).
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.solid,
    this.arrow = false,
    this.leadingIcon,
    this.disabled = false,
    this.height = 56,
    this.borderRadius = 18,
    this.fontSize = 17,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool arrow;
  final String? leadingIcon;
  final bool disabled;
  final double height;
  final double borderRadius;
  final double fontSize;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  ({Color bg, Color fg, List<BoxShadow> shadow, BoxBorder? border}) get _style {
    switch (widget.variant) {
      case ButtonVariant.solid:
        return (
          bg: AppColors.brand,
          fg: Colors.white,
          shadow: const [BoxShadow(color: AppColors.brandShadow, blurRadius: 22, offset: Offset(0, 8))],
          border: null,
        );
      case ButtonVariant.soft:
        return (bg: AppColors.brandSoft, fg: AppColors.brand, shadow: const [], border: null);
      case ButtonVariant.ghost:
        return (bg: Colors.transparent, fg: AppColors.ink, shadow: const [], border: Border.all(color: AppColors.lineStrong, width: 1.5));
      case ButtonVariant.danger:
        return (bg: AppColors.dangerBg, fg: AppColors.dangerFg, shadow: const [], border: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;
    final enabled = !widget.disabled && widget.onPressed != null;

    return Opacity(
      opacity: widget.disabled ? 0.45 : 1,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: enabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _pressed ? 0.978 : 1,
          duration: const Duration(milliseconds: 120),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: s.bg,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: s.shadow,
              border: s.border,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.leadingIcon != null) ...[
                  AppIcon(widget.leadingIcon!, size: 20, color: s.fg),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      context,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w700,
                      color: s.fg,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                if (widget.arrow) ...[
                  const SizedBox(width: 10),
                  AppIcon('arrowRight', size: 20, color: s.fg, flipForRtl: true),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
