import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/services/dio_service.dart';

/// Backend, 6 Oct 2026: a 503 on /auth/refresh means Santra could not CHECK
/// the session — the token was not spent. Signing the shop out over that is
/// how an order board goes blank in the middle of service.
void main() {
  test('only a refusal ends the session', () {
    expect(const RefreshResult.rejected().rejected, isTrue);
    expect(const RefreshResult.unavailable().rejected, isFalse);
    expect(const RefreshResult.refreshed('t').rejected, isFalse);
    expect(const RefreshResult.refreshed('t').token, 't');
    expect(const RefreshResult.unavailable().token, isNull);
  });

  test('Retry-After is honoured, and clamped against a silly value', () {
    expect(DioService.retryAfter('15'), const Duration(seconds: 15));
    expect(DioService.retryAfter(' 5 '), const Duration(seconds: 5));
    // Missing or unparseable: the backend's documented default.
    expect(DioService.retryAfter(null), const Duration(seconds: 15));
    expect(DioService.retryAfter('soon'), const Duration(seconds: 15));
    // A header must never park the app for an hour, or drop to zero.
    expect(DioService.retryAfter('86400'), const Duration(seconds: 60));
    expect(DioService.retryAfter('0'), const Duration(seconds: 1));
  });
}
