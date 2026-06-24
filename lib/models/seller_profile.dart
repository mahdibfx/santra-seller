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

  factory SellerProfile.fromJson(Map<String, dynamic> json) => SellerProfile(
        storeName: json['store_name'] as String? ?? '',
        storeNameAr: json['store_name_ar'] as String? ?? '',
        avatar: json['avatar'] as String? ?? '',
        openNow: (json['open_now'] as bool?) ?? true,
      );
}
