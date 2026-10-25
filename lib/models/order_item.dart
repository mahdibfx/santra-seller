/// One option the customer picked on a line — a size, a sponge, an add-on.
///
/// The server has always sent these; the app never read them, so a cake
/// ordered "10 inch, chocolate sponge" reached the shop as just "Cake ×1" and
/// somebody had to phone the customer.
class OrderModifier {
  final String groupEn;
  final String groupAr;
  final String nameEn;
  final String nameAr;

  /// What this option added to the line price. 0 for a free choice.
  final num priceAddition;

  final int quantity;

  /// The product option this was, so the product page can tick it by id.
  final int? modifierId;

  const OrderModifier({
    this.groupEn = '',
    this.groupAr = '',
    this.nameEn = '',
    this.nameAr = '',
    this.priceAddition = 0,
    this.quantity = 1,
    this.modifierId,
  });

  String displayGroup(String lang) =>
      lang == 'ar' && groupAr.isNotEmpty ? groupAr : groupEn;

  String displayName(String lang) =>
      lang == 'ar' && nameAr.isNotEmpty ? nameAr : nameEn;

  factory OrderModifier.fromJson(Map<String, dynamic> json) => OrderModifier(
        groupEn: json['group_name_en'] as String? ?? '',
        groupAr: json['group_name_ar'] as String? ?? '',
        nameEn: json['modifier_name_en'] as String? ?? '',
        nameAr: json['modifier_name_ar'] as String? ?? '',
        priceAddition:
            num.tryParse(json['price_addition']?.toString() ?? '') ?? 0,
        quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 1,
        modifierId: int.tryParse(json['modifier_id']?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'group_name_en': groupEn,
        'group_name_ar': groupAr,
        'modifier_name_en': nameEn,
        'modifier_name_ar': nameAr,
        'price_addition': priceAddition,
        'quantity': quantity,
      };
}

/// A single line item within an order.
class OrderItem {
  /// `order_item_id` — what a shortage report names.
  final int id;

  /// The catalogue product behind this line, for the read-only product page.
  /// Null when the server leaves it out — the page then shows the line alone.
  final int? productId;

  final String name;
  final String nameAr;
  final int qty;
  final String image;

  /// What the customer typed for this line ("no sugar, extra mint").
  final String note;

  /// Reference photos the customer attached to this line.
  final List<String> images;

  /// PDFs the customer attached to this line — a design brief, a printed
  /// message. These used to be dropped, so the shop never saw them.
  final List<String> files;

  /// Units of this line the shop has already reported as unavailable.
  final int unavailableQuantity;

  /// What the customer chose on this line. The shop has to make exactly this.
  final List<OrderModifier> modifiers;

  /// What is still left to report.
  int get reportableQuantity => qty - unavailableQuantity;

  const OrderItem({
    this.id = 0,
    this.productId,
    required this.name,
    required this.nameAr,
    required this.qty,
    required this.image,
    this.note = '',
    this.images = const [],
    this.files = const [],
    this.unavailableQuantity = 0,
    this.modifiers = const [],
  });

  bool get hasRequest =>
      note.isNotEmpty || images.isNotEmpty || files.isNotEmpty;

  /// The chosen options collapsed by the group they came from, in the order
  /// the server sent them.
  ///
  /// A pick-many group ("Add-ons: nuts, sprinkles") arrives as one entry per
  /// option, and listing each on its own line repeats the group label down the
  /// card. Groups stay separate — a cake's size and its sponge are two
  /// different questions and must not read as one answer.
  ///
  /// An option whose group the server left unnamed is keyed on the empty
  /// string, which the UI renders as the bare option name.
  List<MapEntry<String, List<OrderModifier>>> groupedModifiers(String lang) {
    final byGroup = <String, List<OrderModifier>>{};
    for (final m in modifiers) {
      byGroup.putIfAbsent(m.displayGroup(lang), () => []).add(m);
    }
    return byGroup.entries.toList();
  }

  /// Localized display name for the given language code.
  String displayName(String lang) =>
      lang == 'ar' && nameAr.isNotEmpty ? nameAr : name;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
        productId: int.tryParse(
            (json['product_id'] ?? json['productId'])?.toString() ?? ''),
        unavailableQuantity:
            int.tryParse(json['unavailable_quantity']?.toString() ?? '') ?? 0,
        name: (json['product_name_en'] ?? json['name']) as String? ?? '',
        nameAr: (json['product_name_ar'] ?? json['ar']) as String? ?? '',
        qty: int.tryParse((json['quantity'] ?? json['qty']).toString()) ?? 1,
        // `image_url` is the catalogue photo; `media_url` is legacy and null.
        image: (json['image_url'] ?? json['media_url'] ?? json['img'])
                as String? ??
            '',
        note: json['note'] as String? ?? '',
        modifiers: (json['modifiers'] as List? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(OrderModifier.fromJson)
            .toList(),
        // Detail sends `media[]`; the list sends a single `media_url`.
        images: [
          ...(json['media'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .where((m) => m['media_type'] != 'pdf')
              .map((m) => m['url']?.toString() ?? ''),
          if (json['media'] == null) json['media_url']?.toString() ?? '',
        ].where((u) => u.isNotEmpty).toList(),
        files: [
          for (final m in (json['media'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .where((m) => m['media_type'] == 'pdf'))
            m['url']?.toString() ?? '',
        ].where((u) => u.isNotEmpty).toList(),
      );

  Map<String, dynamic> toJson() => {
        'product_name_en': name,
        'product_name_ar': nameAr,
        'quantity': qty,
        'image_url': image,
        'note': note,
        'modifiers': [for (final m in modifiers) m.toJson()],
        'media': [
          for (final u in images) {'media_type': 'image', 'url': u},
          for (final u in files) {'media_type': 'pdf', 'url': u},
        ],
      };
}
