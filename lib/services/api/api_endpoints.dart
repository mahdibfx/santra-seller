/// Single registry of every backend URL. Services never inline path strings.
///
/// Real Santra **partner** API. Base already includes the `/api/v1/partner`
/// prefix, so paths below are relative to it.
class ApiEndpoints {
  ApiEndpoints._();

  static const String base = 'https://api-staging.santra.ae/api/v1/partner';

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
  static String order(Object id) => '/orders/$id';
  static String orderStatus(Object id) => '/orders/$id/status';

  // ── Notifications ────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static const String unreadCount = '/notifications/unread-count';
  static String markNotificationRead(Object id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/read-all';

  // ── Profile ───────────────────────────────────────────────────────
  static const String profile = '/me';

  // ── Promotion (campaign) requests ─────────────────────────────────
  static const String promotionRequests = '/promotion-requests';
  static String promotionRequest(Object id) => '/promotion-requests/$id';
  static String respondPromotionRequest(Object id) => '/promotion-requests/$id/respond';

  // ── Assistant (AI chat) — not part of the partner API; left as-is ─
  static const String assistant = '/assistant/complete';
}
