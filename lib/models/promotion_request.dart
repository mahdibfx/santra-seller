/// A Santra campaign request sent to this partner: confirm stock and, when the
/// partner co-funds the discount, sign the cost-share terms. See the
/// 2026-08-03 Promotions API update.
class PromotionRequest {
  final int id;
  final int promotionId;
  final String stockStatus; // pending | confirmed | declined
  final String signatureStatus; // not_required | pending | signed | declined
  final String nameEn;
  final String nameAr;
  final String type; // free_delivery | markdown | multibuy | gwp
  final String startsAt;
  final String expiresAt;
  final String appliesToDelivery; // all | standard | express | scheduled | vip | pickup | gift
  final String fundedBy; // santra | partner | shared
  final int santraSharePct;

  // Detail-only:
  final int? partnerSharePct; // from terms_json.funding
  final num? minCartAmount;
  final List<RequestProduct> products;

  const PromotionRequest({
    required this.id,
    required this.promotionId,
    required this.stockStatus,
    required this.signatureStatus,
    required this.nameEn,
    required this.nameAr,
    required this.type,
    required this.startsAt,
    required this.expiresAt,
    required this.appliesToDelivery,
    required this.fundedBy,
    required this.santraSharePct,
    this.partnerSharePct,
    this.minCartAmount,
    this.products = const [],
  });

  String localizedName(String lang) => lang == 'ar' && nameAr.isNotEmpty ? nameAr : nameEn;

  bool get needsStock => stockStatus == 'pending';
  bool get needsSignature => signatureStatus == 'pending';
  bool get needsAction => needsStock || needsSignature;

  /// The partner's share of every discount — the number they're signing.
  /// Prefers the frozen terms snapshot; falls back to 100 − santraShare.
  int get partnerShare => partnerSharePct ?? (fundedBy == 'santra' ? 0 : 100 - santraSharePct);

  static int _int(Object? v, int fallback) => int.tryParse(v.toString()) ?? fallback;

  factory PromotionRequest.fromJson(Map<String, dynamic> json) {
    final terms = json['terms_json'] as Map<String, dynamic>?;
    final funding = terms?['funding'] as Map<String, dynamic>?;
    return PromotionRequest(
      id: _int(json['id'], 0),
      promotionId: _int(json['promotion_id'], 0),
      stockStatus: json['stock_status'] as String? ?? 'pending',
      signatureStatus: json['signature_status'] as String? ?? 'not_required',
      nameEn: json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      type: json['type'] as String? ?? '',
      startsAt: json['starts_at'] as String? ?? '',
      expiresAt: json['expires_at'] as String? ?? '',
      appliesToDelivery: json['applies_to_delivery'] as String? ?? 'all',
      fundedBy: json['funded_by'] as String? ?? 'santra',
      santraSharePct: _int(json['santra_share_pct'], 0),
      partnerSharePct: funding == null ? null : _int(funding['partnerSharePct'], 0),
      minCartAmount: num.tryParse((json['min_cart_amount'] ?? '').toString()),
      products: (json['products'] as List? ?? [])
          .map((e) => RequestProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// A product in the offer, with its live stock (read now, not from the snapshot).
class RequestProduct {
  final int id;
  final String nameEn;
  final String nameAr;
  final bool trackInventory;
  final int stockQuantity;
  final String availabilityStatus; // online | offline | out_of_stock

  const RequestProduct({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.trackInventory,
    required this.stockQuantity,
    required this.availabilityStatus,
  });

  String localizedName(String lang) => lang == 'ar' && nameAr.isNotEmpty ? nameAr : nameEn;

  factory RequestProduct.fromJson(Map<String, dynamic> json) => RequestProduct(
        id: int.tryParse(json['id'].toString()) ?? 0,
        nameEn: json['name_en'] as String? ?? '',
        nameAr: json['name_ar'] as String? ?? '',
        trackInventory: (json['track_inventory'] ?? 0).toString() == '1',
        stockQuantity: int.tryParse((json['stock_quantity'] ?? 0).toString()) ?? 0,
        availabilityStatus: json['availability_status'] as String? ?? 'online',
      );
}
