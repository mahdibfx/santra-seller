/// An add-on the customer bought with the order (candle, card, knife). The
/// shop has to pack it; its price is already inside the order's subtotal.
class OrderAddon {
  final String name;
  final String nameAr;
  final int quantity;
  final num totalPrice;

  const OrderAddon({
    required this.name,
    required this.nameAr,
    required this.quantity,
    required this.totalPrice,
  });

  String displayName(String lang) =>
      lang == 'ar' && nameAr.isNotEmpty ? nameAr : name;

  factory OrderAddon.fromJson(Map<String, dynamic> json) => OrderAddon(
        name: json['name_en'] as String? ?? '',
        nameAr: json['name_ar'] as String? ?? '',
        quantity: int.tryParse(json['quantity'].toString()) ?? 1,
        totalPrice: num.tryParse(json['total_price'].toString()) ?? 0,
      );
}
