import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/services/api/api_endpoints.dart';
import 'package:santra_seller/ui/views/login/login_viewmodel.dart';

/// The app is UAE-only, but Santra's own test shop is Algerian. A trailing
/// `111` marks a number as Algerian; the marker is stripped before sending.
void main() {
  test('a plain number is UAE and goes out untouched', () {
    expect(resolveDial('501234567'), (dial: '+971', phone: '501234567'));
    // A valid UAE mobile that happens to be the test shop's digits must NOT
    // be rerouted — this is why the marker exists.
    expect(resolveDial('553522128'), (dial: '+971', phone: '553522128'));
  });

  test('a trailing 111 means Algeria, and never reaches the API', () {
    expect(resolveDial('553522128111'), (dial: '+213', phone: '553522128'));
    expect(resolveDial(' 553522128111 '), (dial: '+213', phone: '553522128'));
    // Any Algerian number, not just one hardcoded shop.
    expect(resolveDial('770123456111'), (dial: '+213', phone: '770123456'));
  });

  test('the marker alone is not a number', () {
    expect(resolveDial('111'), (dial: '+971', phone: '111'));
    expect(resolveDial(''), (dial: '+971', phone: ''));
  });

  test('a UAE number ending in 1 is untouched', () {
    expect(resolveDial('501234511'), (dial: '+971', phone: '501234511'));
  });

  test('the shipped build talks to production', () {
    expect(ApiEndpoints.isProduction, isTrue);
  });
}
