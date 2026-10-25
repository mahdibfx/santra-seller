import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/app_colors.dart';

/// The Flutter half of the splash. The native splash (flutter_native_splash,
/// see pubspec.yaml) can only be a still image — iOS allows nothing else on a
/// launch screen — so this takes over on the first frame looking EXACTLY like
/// it: same purple, same white mark, same 100pt, dead centre. The swap is
/// invisible, and only then does the mark start to move.
///
/// Keep [_markWidth] in step with the native image: assets/splash/splash.png
/// is a 600px canvas holding the 400px-wide mark (the official mono logo,
/// assets/splash/logo_white.png), generated as @4x, i.e. 100pt.
class SplashMark extends StatefulWidget {
  const SplashMark({super.key});

  @override
  State<SplashMark> createState() => _SplashMarkState();
}

class _SplashMarkState extends State<SplashMark>
    with SingleTickerProviderStateMixin {
  static const double _markWidth = 100;

  late final AnimationController _c;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    // A slow breath rather than a spin or a bounce: it says "working" without
    // pulling the eye, and it loops cleanly if startup takes longer than one
    // cycle (cold storage, a slow device).
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1, end: 1.08)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_c);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Light status-bar icons on the purple, as on the native splash.
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.brand,
        body: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Image.asset(
              'assets/splash/logo_white.png',
              width: _markWidth,
            ),
          ),
        ),
      ),
    );
  }
}
