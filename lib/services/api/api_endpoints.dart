/// Single registry of every backend URL. Services never inline path strings.
///
/// `base` is a placeholder — point it at the real API host once available.
class ApiEndpoints {
  ApiEndpoints._();

  static const String base = 'https://api.santra.ae';

  // ── Auth ──────────────────────────────────────────────────────────
  static const String requestOtp = '/api/seller/auth/request-otp';
  static const String verifyOtp = '/api/seller/auth/verify-otp';
  static const String forgotPassword = '/api/seller/auth/forgot-password';
  static const String resetPassword = '/api/seller/auth/reset-password';

  // ── Orders ────────────────────────────────────────────────────────
  static const String orders = '/api/seller/orders';
  static String order(Object id) => '/api/seller/orders/$id';
  static String acceptOrder(Object id) => '/api/seller/orders/$id/accept';
  static String rejectOrder(Object id) => '/api/seller/orders/$id/reject';
  static String advanceOrder(Object id) => '/api/seller/orders/$id/advance';

  // ── Notifications ────────────────────────────────────────────────
  static const String notifications = '/api/seller/notifications';
  static String markNotificationRead(Object id) => '/api/seller/notifications/$id/read';
  static const String markAllNotificationsRead = '/api/seller/notifications/read-all';

  // ── Profile ───────────────────────────────────────────────────────
  static const String profile = '/api/seller/profile';
  static const String logout = '/api/seller/auth/logout';

  // ── Assistant (AI chat) ──────────────────────────────────────────
  static const String assistant = '/api/seller/assistant/complete';
}
