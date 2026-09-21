/// A single line item within an order.
class OrderItem {
  final String name;
  final String nameAr;
  final int qty;
  final String image;

  /// What the customer typed for this line ("no sugar, extra mint").
  final String note;

  /// Reference photos the customer attached to this line.
  final List<String> images;

  const OrderItem({
    required this.name,
    required this.nameAr,
    required this.qty,
    required this.image,
    this.note = '',
    this.images = const [],
  });

  bool get hasRequest => note.isNotEmpty || images.isNotEmpty;

  /// Localized display name for the given language code.
  String displayName(String lang) =>
      lang == 'ar' && nameAr.isNotEmpty ? nameAr : name;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        name: (json['product_name_en'] ?? json['name']) as String? ?? '',
        nameAr: (json['product_name_ar'] ?? json['ar']) as String? ?? '',
        qty: int.tryParse((json['quantity'] ?? json['qty']).toString()) ?? 1,
        // `image_url` is the catalogue photo; `media_url` is legacy and null.
        image: (json['image_url'] ?? json['media_url'] ?? json['img'])
                as String? ??
            '',
        note: json['note'] as String? ?? '',
        images: (json['media'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .where((m) => m['media_type'] != 'pdf')
            .map((m) => m['url']?.toString() ?? '')
            .where((u) => u.isNotEmpty)
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'product_name_en': name,
        'product_name_ar': nameAr,
        'quantity': qty,
        'image_url': image,
        'note': note,
        'media': [
          for (final u in images) {'media_type': 'image', 'url': u}
        ],
      };
}
