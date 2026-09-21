import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';

/// 4-digit OTP entry. Auto-advances on input, backspaces to the previous box,
/// and reports the joined code via [onChanged].
class OtpInput extends StatefulWidget {
  const OtpInput({super.key, this.length = 4, required this.onChanged});

  final int length;
  final ValueChanged<String> onChanged;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers =
      List.generate(widget.length, (_) => TextEditingController());
  late final List<FocusNode> _nodes =
      List.generate(widget.length, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int i, String v) {
    if (v.isNotEmpty && i < widget.length - 1) {
      _nodes[i + 1].requestFocus();
    }
    widget.onChanged(_controllers.map((c) => c.text).join());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < widget.length; i++)
            Padding(
              padding: EdgeInsets.only(right: i < widget.length - 1 ? 12 : 0),
              child: _box(context, i),
            ),
        ],
      ),
    );
  }

  Widget _box(BuildContext context, int i) {
    final filled = _controllers[i].text.isNotEmpty;
    return SizedBox(
      width: 40,
      height: 48,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (e) {
          if (e is KeyDownEvent &&
              e.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[i].text.isEmpty &&
              i > 0) {
            _controllers[i - 1].clear();
            _nodes[i - 1].requestFocus();
            widget.onChanged(_controllers.map((c) => c.text).join());
          }
        },
        child: TextField(
          controller: _controllers[i],
          focusNode: _nodes[i],
          autofocus: i == 0,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) => _onChanged(i, v),
          cursorColor: AppColors.brand,
          style: AppTextStyles.display(context,
              fontSize: 24, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            counterText: '',
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            filled: true,
            fillColor: AppColors.surface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: filled ? AppColors.brand : AppColors.lineStrong,
                  width: filled ? 2 : 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.brand, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
