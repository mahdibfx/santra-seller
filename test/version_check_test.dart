import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/services/version_check.dart';

void main() {
  test('isBelow compares dotted versions numerically', () {
    expect(VersionCheck.isBelow('4.6.2', '5.0.0'), isTrue);
    expect(VersionCheck.isBelow('5.0.0', '5.0.0'), isFalse);
    expect(VersionCheck.isBelow('5.0.1', '5.0.0'), isFalse);
    // Numeric, not string: 4.10 is newer than 4.9.
    expect(VersionCheck.isBelow('4.10.0', '4.9.9'), isFalse);
    // Missing parts are 0; build/pre-release suffixes are ignored.
    expect(VersionCheck.isBelow('5', '5.0.0'), isFalse);
    expect(VersionCheck.isBelow('5.0.0+7', '5.0.1'), isTrue);
  });
}
