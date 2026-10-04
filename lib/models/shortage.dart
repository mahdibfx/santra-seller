/// One line's worth of units the shop reported it cannot supply. The money is
/// entirely the server's business — the app only names the units.
class Shortage {
  final int orderItemId;
  final String name;
  final String nameAr;
  final int quantity;

  const Shortage({
    required this.orderItemId,
    required this.name,
    required this.nameAr,
    required this.quantity,
  });

  String displayName(String lang) =>
      lang == 'ar' && nameAr.isNotEmpty ? nameAr : name;

  factory Shortage.fromJson(Map<String, dynamic> json) => Shortage(
        orderItemId: int.tryParse(json['order_item_id']?.toString() ?? '') ?? 0,
        name: json['name_en'] as String? ?? '',
        nameAr: json['name_ar'] as String? ?? '',
        quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      );
}
