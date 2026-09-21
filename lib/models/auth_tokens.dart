/// OTP-verify / refresh response. The partner auth endpoints are NOT wrapped
/// in the `{ "data": ... }` envelope — tokens sit at the top level.
class AuthTokens {
  final String accessToken;
  final String refreshToken;

  /// Business name from the `partner` object. Present on OTP-verify, empty on
  /// refresh (that response carries tokens only).
  final String nameEn;
  final String nameAr;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.nameEn = '',
    this.nameAr = '',
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    final partner = json['partner'] as Map<String, dynamic>? ?? const {};
    return AuthTokens(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      nameEn: partner['nameEn'] as String? ?? '',
      nameAr: partner['nameAr'] as String? ?? '',
    );
  }
}
