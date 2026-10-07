import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/services/api/api_endpoints.dart';

/// The staging test shop is an Algerian number, and the dial-code picker is
/// gone. The exception that lets it sign in must never reach production:
/// 553522128 is a valid UAE mobile too.
void main() {
  test('the production flag follows the host this build talks to', () {
    // This suite runs with no --dart-define, so it sees the shipped default.
    expect(ApiEndpoints.host, 'https://app-api.santra.ae');
    expect(ApiEndpoints.isProduction, isTrue);
    expect(ApiEndpoints.base, 'https://app-api.santra.ae/api/v1/partner');
  });
}
