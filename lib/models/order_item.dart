/// A single line item within an order.
class OrderItem {
  final String name;
  final String nameAr;
  final int qty;
  final String image;

  const OrderItem({
    required this.name,
    required this.nameAr,
    required this.qty,
    required this.image,
  });

  /// Localized display name for the given language code.
  String displayName(String lang) => lang == 'ar' && nameAr.isNotEmpty ? nameAr : name;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        name: json['name'] as String? ?? '',
        nameAr: json['ar'] as String? ?? '',
        qty: int.tryParse(json['qty'].toString()) ?? 1,
        image: json['img'] as String? ?? '',
      );
}
