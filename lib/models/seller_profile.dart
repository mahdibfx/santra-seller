import 'trading.dart';

/// Seller / store profile shown on the Profile screen.
class SellerProfile {
  final String storeName;
  final String storeNameAr;
  final String avatar;
  final bool openNow;

  /// Open / busy / closed, plus the pause lengths the server offers.
  final Trading trading;

  const SellerProfile({
    required this.storeName,
    required this.storeNameAr,
    required this.avatar,
    required this.openNow,
    this.trading = const Trading(),
  });

  String displayName(String lang) =>
      lang == 'ar' && storeNameAr.isNotEmpty ? storeNameAr : storeName;

  /// `GET /me` is snake_case, unlike the camelCase auth endpoints — the
  /// camelCase keys are kept as a fallback for that inconsistency.
  factory SellerProfile.fromJson(Map<String, dynamic> json) => SellerProfile(
        storeName: (json['name_en'] ?? json['nameEn']) as String? ?? '',
        storeNameAr: (json['name_ar'] ?? json['nameAr']) as String? ?? '',
        avatar: (json['logo_url'] ?? json['logo']) as String? ?? '',
        // `/me` does carry the state after all — the `trading` block below.
        // This used to be hardcoded true, so a paused shop's profile claimed
        // "Open now" while the orders board showed the amber busy banner one
        // tab away.
        openNow: json['trading'] is Map<String, dynamic>
            ? Trading.fromJson(json['trading'] as Map<String, dynamic>).isOpen
            : true,
        trading: json['trading'] is Map<String, dynamic>
            ? Trading.fromJson(json['trading'] as Map<String, dynamic>)
            : const Trading(),
      );
}
