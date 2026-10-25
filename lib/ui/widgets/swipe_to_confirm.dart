import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';

/// A slider that has to be dragged end to end before it fires, like answering
/// a call on a phone.
///
/// Why this exists: the forward action on an order is one tap in a screen a
/// shop scrolls with flour on their hands, and it is not undoable — a mis-tap
/// on "Mark ready" tells the courier to come for a box nobody has packed. A
/// confirm dialog would cost the same tap twice and gets dismissed on reflex;
/// a gesture nothing else in the app uses cannot happen by accident.
///
/// Only for a single, destructive-by-timing action. Where the shop still has
/// a real choice to make — accept or cancel, side by side — plain buttons
/// stay: an accidental tap there lands on a screen that explains itself, and
/// cancelling asks for a reason anyway.
class SwipeToConfirm extends StatefulWidget {
  const SwipeToConfirm({
    super.key,
    required this.label,
    required this.onConfirmed,
    this.height = 56,
    this.borderRadius = 18,
    this.fontSize = 17,
    this.enabled = true,
  });

  /// What the swipe will do, in the imperative — "Mark ready", not "Ready".
  final String label;

  /// Fired once, when the thumb reaches the end. Never fired by a tap.
  final VoidCallback onConfirmed;

  final double height;
  final double borderRadius;
  final double fontSize;
  final bool enabled;

  @override
  State<SwipeToConfirm> createState() => _SwipeToConfirmState();
}

class _SwipeToConfirmState extends State<SwipeToConfirm>
    with SingleTickerProviderStateMixin {
  /// 0 = at rest, 1 = all the way across.
  double _t = 0;
  bool _fired = false;

  /// Held so disposal can cancel it: the reset outlives a screen that pops
  /// the moment the action succeeds, which is the normal case here.
  Timer? _reset;

  // Built in initState, NOT as a lazy `late final`: most cards on the board
  // are never swiped, so a lazy controller was first touched inside dispose()
  // — constructing a ticker on an element already being torn down.
  late final AnimationController _spring;

  @override
  void initState() {
    super.initState();
    _spring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
        if (mounted) setState(() => _t = _spring.value);
      });
  }

  /// Past this much of the track the swipe counts as deliberate. Short of the
  /// very end so a fast flick still lands — the thumb does not have to be
  /// placed precisely, it has to travel.
  static const double _commitAt = 0.82;

  @override
  void dispose() {
    _reset?.cancel();
    _spring.dispose();
    super.dispose();
  }

  void _settleBack() {
    _spring.value = _t;
    _spring.animateTo(0, curve: Curves.easeOutCubic);
  }

  void _fire() {
    if (_fired) return;
    _fired = true;
    HapticFeedback.mediumImpact();
    setState(() => _t = 1);
    widget.onConfirmed();
    // Back to rest, so a screen that stays put (a failed call, say) is ready
    // to be swiped again rather than stuck looking complete.
    _reset?.cancel();
    _reset = Timer(const Duration(milliseconds: 550), () {
      if (!mounted) return;
      _fired = false;
      _settleBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final knobH = widget.height - 8;
    // A rectangle, not a square: wider reads as "grab and pull".
    final knobW = knobH * 1.3;

    return Opacity(
      opacity: widget.enabled ? 1 : 0.45,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final travel =
              (constraints.maxWidth - knobW - 8).clamp(1.0, 4000.0);

          void onUpdate(DragUpdateDetails d) {
            if (!widget.enabled || _fired) return;
            final delta = (rtl ? -d.delta.dx : d.delta.dx) / travel;
            setState(() => _t = (_t + delta).clamp(0.0, 1.0));
          }

          void onEnd(DragEndDetails d) {
            if (!widget.enabled || _fired) return;
            if (_t >= _commitAt) {
              _fire();
            } else {
              _settleBack();
            }
          }

          return GestureDetector(
            onHorizontalDragStart:
                widget.enabled ? (_) => _spring.stop() : null,
            onHorizontalDragUpdate: widget.enabled ? onUpdate : null,
            onHorizontalDragEnd: widget.enabled ? onEnd : null,
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: AppColors.brand,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.brandShadow,
                    blurRadius: 22,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Label, centred in the space the knob is not in, fading as
                  // the knob passes over it.
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: knobW + 8, end: 12),
                      child: Center(
                        child: Opacity(
                          opacity: (1 - _t * 1.6).clamp(0.0, 1.0),
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body(
                              context,
                              fontSize: widget.fontSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // The knob: white rectangle, gray arrow.
                  Align(
                    alignment: Alignment((rtl ? -1 : 1) * (2 * _t - 1), 0),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        width: knobW,
                        height: knobH,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius - 4),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x29000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        // Never picked by direction here: this icon has
                        // matchTextDirection, so Flutter already mirrors it
                        // in Arabic. Flipping it as well pointed the arrow
                        // into the wall the knob starts against.
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 24,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
