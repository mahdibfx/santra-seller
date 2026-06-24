import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

import '../ui/common/app_colors.dart';

enum ToastType { success, danger, info }

/// Lightweight top-anchored toast. ViewModels call
/// `showUpperToast(message, type: ToastType.danger)` on every failure path.
class ToastService {
  OverlayEntry? _entry;

  void showUpperToast(String message, {ToastType type = ToastType.info}) {
    // Use the navigator's own overlay — its context sits *above* the Overlay,
    // so Overlay.of() on it would throw "No Overlay found".
    final overlay = StackedService.navigatorKey?.currentState?.overlay;
    if (overlay == null) return;

    _entry?.remove();
    _entry = null;

    final (Color bg, Color fg, IconData icon) = switch (type) {
      ToastType.success => (AppColors.successBg, AppColors.successFg, Icons.check_circle_outline),
      ToastType.danger => (AppColors.dangerBg, AppColors.dangerFg, Icons.error_outline),
      ToastType.info => (AppColors.brandSoft, AppColors.brand, Icons.info_outline),
    };

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Color(0x22143C3C), blurRadius: 24, offset: Offset(0, 8)),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: fg, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    _entry = entry;
    Future.delayed(const Duration(seconds: 3), () {
      if (_entry == entry) {
        entry.remove();
        _entry = null;
      }
    });
  }
}
