import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// `screenIn` — fade + slide-up wrapper for screen entrances.
class FadeSlideIn extends HookWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.offset = 12,
    this.duration = const Duration(milliseconds: 340),
  });

  final Widget child;
  final double offset;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: duration);
    final t = useAnimation(
      CurvedAnimation(parent: controller, curve: const Cubic(0.22, 0.61, 0.36, 1)),
    );
    useEffect(() {
      controller.forward();
      return null;
    }, const []);

    return Opacity(
      opacity: t.clamp(0.0, 1.0),
      child: Transform.translate(offset: Offset(0, (1 - t) * offset), child: child),
    );
  }
}

/// `pop` — scale-in from .94 with a soft overshoot. Used for success ticks.
class PopIn extends HookWidget {
  const PopIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: duration);
    final t = useAnimation(
      CurvedAnimation(parent: controller, curve: const Cubic(0.2, 0.8, 0.3, 1.2)),
    );
    useEffect(() {
      controller.forward();
      return null;
    }, const []);

    return Transform.scale(scale: 0.94 + 0.06 * t, child: Opacity(opacity: t.clamp(0.0, 1.0), child: child));
  }
}
