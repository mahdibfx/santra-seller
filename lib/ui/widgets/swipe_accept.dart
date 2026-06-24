import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import 'app_icon.dart';
import 'primary_button.dart';

/// Accept button that reveals a Delete action when swiped sideways.
/// Tap = accept; swipe toward the leading edge = reveal Delete.
class SwipeAccept extends StatefulWidget {
  const SwipeAccept({super.key, required this.onAccept, required this.onDelete});

  final VoidCallback onAccept;
  final VoidCallback onDelete;

  @override
  State<SwipeAccept> createState() => _SwipeAcceptState();
}

class _SwipeAcceptState extends State<SwipeAccept> {
  static const double _reveal = 108;
  double _offset = 0; // positive reveal amount
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final dirSign = rtl ? 1.0 : -1.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          // Delete action behind the accept button (trailing edge).
          PositionedDirectional(
            top: 0,
            bottom: 0,
            end: 0,
            width: _reveal,
            child: GestureDetector(
              onTap: widget.onDelete,
              child: Container(
                color: AppColors.danger,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppIcon('trash', size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('delete'.tr(),
                        style: AppTextStyles.body(context, fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (d) {
              setState(() {
                _offset = (_offset + dirSign * d.delta.dx).clamp(0.0, _reveal + 16);
              });
            },
            onHorizontalDragEnd: (_) {
              setState(() {
                _open = _offset >= _reveal * 0.5;
                _offset = _open ? _reveal : 0;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: const Cubic(0.2, 0.7, 0.3, 1),
              transform: Matrix4.translationValues(dirSign * _offset, 0, 0),
              child: PrimaryButton(
                label: 'accept'.tr(),
                leadingIcon: 'check',
                height: 50,
                borderRadius: 15,
                fontSize: 16,
                onPressed: () {
                  if (_open) {
                    setState(() {
                      _open = false;
                      _offset = 0;
                    });
                  } else {
                    widget.onAccept();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
