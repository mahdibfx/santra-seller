import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/services/session_migration.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shops updating from the legacy backend keep tokens the new API will not
/// accept: the app would look signed in while every call 401s, and an order
/// board that silently fails reads as "no orders".
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the first launch after the switch clears the old session', () async {
    SharedPreferences.setMockInitialValues({
      'access_token': 'legacy-access',
      'refresh_token': 'legacy-refresh',
      'partner_name': 'Old Shop',
      'locale': 'ar',
    });

    await SessionMigration.run();
    final prefs = await SharedPreferences.getInstance();

    expect(prefs.getString('access_token'), isNull);
    expect(prefs.getString('refresh_token'), isNull);
    expect(prefs.getString('partner_name'), isNull);
    // Anything not tied to the account survives, or the update looks like a
    // fresh install.
    expect(prefs.getString('locale'), 'ar');
  });

  test('it runs once, so the next sign-in is not wiped too', () async {
    SharedPreferences.setMockInitialValues({});
    await SessionMigration.run();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', 'signed-in-after-the-migration');
    await SessionMigration.run();

    expect(prefs.getString('access_token'), 'signed-in-after-the-migration');
  });
}
