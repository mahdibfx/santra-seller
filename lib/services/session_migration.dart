import 'package:shared_preferences/shared_preferences.dart';

/// Signs every shop out, once, on the first launch after the backend switch.
///
/// A shop that simply updates keeps the tokens the legacy server issued, and
/// the new API does not know them: the app looks signed in while every call
/// 401s, so the order board sits empty instead of asking them to sign in —
/// and an empty board reads as "no orders", which is the worst possible lie
/// to tell a shop.
///
/// Runs before [TokenService.init] reads anything, so it needs no locator and
/// no service: SharedPreferences only. The keys are repeated here rather than
/// imported from TokenService because this has to keep clearing them even if
/// TokenService later renames or drops one.
class SessionMigration {
  SessionMigration._();

  /// Bump the number to sign everyone out again.
  static const _marker = 'session_reset_v2';

  static const _authKeys = <String>[
    'access_token',
    'refresh_token',
    'partner_name',
    'partner_name_ar',
  ];

  static Future<void> run() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_marker) == true) return;
    for (final key in _authKeys) {
      await prefs.remove(key);
    }
    // Written last: an app killed mid-migration just runs it again.
    await prefs.setBool(_marker, true);
  }
}
