/// Single registry of every backend URL. Services never inline path strings.
///
/// Real Santra **partner** API. Base already includes the `/api/v1/partner`
/// prefix, so paths below are relative to it.
class ApiEndpoints {
  ApiEndpoints._();

  /// PRODUCTION by default. Flipped 6 Oct 2026 so a plain `flutter run` and
  /// any build without flags go to the live API — the app is shipping, and a
  /// build that quietly talked to staging was the worse accident to leave
  /// available.
  ///
  /// For staging, pass it explicitly:
  /// `--dart-define=SANTRA_API_HOST=https://api-staging.santra.ae`
  ///
  /// `api.santra.ae` is the OLD system — never point here at it.
  static const String host = String.fromEnvironment('SANTRA_API_HOST',
      defaultValue: 'https://app-api.santra.ae');
  static const String base = '$host/api/v1/partner';

  /// True when this build talks to the live API. Used to keep test-only
  /// affordances out of production rather than guessing from kDebugMode,
  /// which is wrong for a staging TestFlight build.
  static const bool isProduction = host == 'https://app-api.santra.ae';

  // ── Auth (phone + OTP) ────────────────────────────────────────────
  static const String requestOtp = '/auth/otp/request';
  static const String verifyOtp = '/auth/otp/verify';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  // ponytail: partner API is OTP-only — no password reset. These 404 today;
  // remove the Forgot screen (view/viewmodel/route) in a follow-up.
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // ── Orders ────────────────────────────────────────────────────────
  static const String orders = '/orders';
  static const String cancelReasons = '/orders/cancel-reasons';
  static String order(Object id) => '/orders/$id';
  static String orderStatus(Object id) => '/orders/$id/status';
  static String unavailableItems(Object id) => '/orders/$id/items/unavailable';
  static String refundBankDetails(Object id) =>
      '/orders/$id/refund-bank-details';

  // ── Notifications ────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static const String unreadCount = '/notifications/unread-count';
  static String markNotificationRead(Object id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/read-all';

  /// Push token registration — one row per device, keyed by the token.
  static const String devices = '/devices';

  // ── Profile ───────────────────────────────────────────────────────
  static const String profile = '/me';

  // ── Content ───────────────────────────────────────────────────────
  /// `?platform=android|ios` → `{minVersion, latestVersion, storeUrl}`.
  static const String appVersion = '/content/app-version';

  /// `{privacy_policy_url, terms_conditions_url, seller_contract_url}` — any
  /// of them null until Santra publishes that document.
  static const String legal = '/content/legal';
  static const String trading = '/me/trading';

  // ── Promotion (campaign) requests ─────────────────────────────────
  static const String promotionRequests = '/promotion-requests';
  static String promotionRequest(Object id) => '/promotion-requests/$id';
  static String respondPromotionRequest(Object id) =>
      '/promotion-requests/$id/respond';

  // ── Assistant (AI chat) — not part of the partner API; left as-is ─
  static const String assistant = '/assistant/complete';
}
