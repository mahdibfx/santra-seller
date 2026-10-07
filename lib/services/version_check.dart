import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

import '../app/app.locator.dart';
import 'api/api_endpoints.dart';
import 'dio_service.dart';

/// Store version gate (backend, 4 Oct 2026): every call carries
/// `x-app-version`, and launch asks `GET /content/app-version` whether this
/// build is still allowed. `minVersion: null` means no forced update.
class VersionCheck {
  VersionCheck._();

  /// This build's `pubspec` version (e.g. `5.0.0`), read once in `main`.
  static String current = '0.0.0';

  static Future<void> load() async =>
      current = (await PackageInfo.fromPlatform()).version;

  /// The store link when this build is below `minVersion`, `''` when it is
  /// below but the server gave no link, or null when it may run.
  ///
  /// Fails open: a slow or broken check never locks shops out of the app.
  static Future<String?> forcedUpdateUrl() async {
    try {
      final res = await locator<DioService>().dio.get(ApiEndpoints.appVersion,
          queryParameters: {
            'platform': Platform.isIOS ? 'ios' : 'android'
          }).timeout(const Duration(seconds: 5));
      final data = (res.data as Map)['data'] as Map? ?? const {};
      final min = data['minVersion'] as String?;
      if (min == null || !isBelow(current, min)) return null;
      return data['storeUrl'] as String? ?? _fallbackStoreUrl;
    } catch (_) {
      return null;
    }
  }

  // ponytail: Play link only — no App Store id in the repo; iOS relies on the
  // server's storeUrl and shows the screen without a button otherwise.
  static String get _fallbackStoreUrl => Platform.isAndroid
      ? 'https://play.google.com/store/apps/details?id=com.hihome.seller'
      : '';

  /// Numeric dotted compare: `4.10.0` is above `4.9.9`. Missing parts are 0,
  /// and anything after `+`/`-` (build number, pre-release) is ignored.
  static bool isBelow(String version, String min) {
    List<int> parts(String v) => v
        .split(RegExp('[+-]'))
        .first
        .split('.')
        .map((p) => int.tryParse(p) ?? 0)
        .toList();
    final a = parts(version), b = parts(min);
    for (var i = 0; i < 3; i++) {
      final x = i < a.length ? a[i] : 0, y = i < b.length ? b[i] : 0;
      if (x != y) return x < y;
    }
    return false;
  }
}
