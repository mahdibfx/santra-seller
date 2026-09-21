/// Seller / store profile shown on the Profile screen.
class SellerProfile {
  final String storeName;
  final String storeNameAr;
  final String avatar;
  final bool openNow;

  const SellerProfile({
    required this.storeName,
    required this.storeNameAr,
    required this.avatar,
    required this.openNow,
  });

  String displayName(String lang) => lang == 'ar' && storeNameAr.isNotEmpty ? storeNameAr : storeName;

  /// `GET /me` is snake_case, unlike the camelCase auth endpoints — the
  /// camelCase keys are kept as a fallback for that inconsistency.
  factory SellerProfile.fromJson(Map<String, dynamic> json) => SellerProfile(
        storeName: (json['name_en'] ?? json['nameEn']) as String? ?? '',
        storeNameAr: (json['name_ar'] ?? json['nameAr']) as String? ?? '',
        avatar: (json['logo_url'] ?? json['logo']) as String? ?? '',
        // ponytail: /me has no open/closed flag — operating hours are admin-only
        // (FULL-REFERENCE §17). Always open until that endpoint ships.
        openNow: true,
      );
}
