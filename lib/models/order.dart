import 'delivery_emirate.dart';
import 'order_addon.dart';
import 'order_item.dart';
import 'shortage.dart';
import 'order_status.dart';
import 'order_type.dart';
import 'refund_bank_details.dart';

/// A seller order. Field names map to the partner API's order payload
/// (see `ApiOrdersService`); UI-only fields fall back to sensible defaults.
class Order {
  final int id;
  final String orderNumber; // e.g. "STEST08" — the human order reference
  final String customer;
  final OrderStatus status;
  final double total; // grand total, AED (may have decimals)
  /// When the shop was given this order. For a card order that is when the
  /// payment landed, not when the checkout began — so a customer who took ten
  /// minutes to pay doesn't land on the board already late.
  final DateTime? receivedAt;

  /// Minutes the shop has had it, at the time the payload was parsed.
  int get placed => receivedAt == null
      ? 0
      : DateTime.now().difference(receivedAt!.toLocal()).inMinutes;
  final String deliver; // human delivery window, e.g. "Today · 6:00 PM"
  final String date; // ISO yyyy-MM-dd
  final PaymentMethod payment;
  final List<OrderType> tags;

  final List<OrderItem> items;
  final String note;
  final String noteAr;
  final List<String> images;

  /// Status moves the server says this partner may make on this order right
  /// now (`allowed_transitions`). `null` = the field wasn't in the payload, so
  /// [can] falls back to the transitions the API documented.
  final List<OrderStatus>? allowedTransitions;

  /// Set while Santra is waiting for the customer's bank account to refund
  /// this order into (manual orders only). Detail endpoint only.
  final RefundBankDetails? refundBankDetails;

  /// Extras the shop must pack. `[]` when there is nothing; their prices are
  /// already inside the total, so never re-sum them.
  final List<OrderAddon> addons;

  /// Emirate the order goes to — null on a pickup, and on orders old enough
  /// to predate the field.
  final DeliveryEmirate? deliveryEmirate;

  /// Raw `delivery_type` (`standard` | `express` | `pickup` | …).
  final String deliveryType;

  /// `product` (something to prepare) or `delivery_service` — a parcel Santra
  /// delivers for the shop, which is only ever cancelled, never prepared.
  final String orderKind;

  /// How far the courier has got: `before_assignment`, `after_assignment`,
  /// `after_collection`, or null once the order has ended. Drives the charge
  /// wording on the cancel sheet.
  final String? courierStage;

  bool get isParcel => orderKind == 'delivery_service';

  /// The server's answer to "may this shop report a missing item right now?" —
  /// true only while pending/confirmed/preparing, and never on a parcel.
  final bool canReportUnavailable;

  /// Units already reported missing, as the server summarised them.
  final List<Shortage> shortages;

  /// What the courier collects on a cash order once units were removed.
  /// Equals the total on a paid order; null when nothing was reported.
  final num? amountDue;

  /// Contact and address the shop typed itself on a manual order. An order
  /// from the Santra app carries none of this — the customer's details are
  /// masked down to a first name and the emirate.
  final String customerPhone;
  final String addressLine;
  final String building;
  final String unit;
  final String deliveryInstructions;

  /// Who created the order: `partner` (the shop typed it) or `customer`.
  final String placedBy;

  /// True when the shop entered this order (phone/WhatsApp), so it may see the
  /// contact and destination it typed itself.
  bool get isManual => placedBy == 'partner';

  /// Building / unit / street, as much as the shop filled in.
  String get fullAddress => [
        if (building.isNotEmpty) building,
        if (unit.isNotEmpty) unit,
        if (addressLine.isNotEmpty) addressLine,
      ].join(' · ');

  bool get isPickup => deliveryType == 'pickup';

  const Order({
    required this.id,
    required this.orderNumber,
    required this.customer,
    required this.status,
    required this.total,
    required this.deliver,
    required this.date,
    required this.payment,
    required this.tags,
    required this.items,
    required this.note,
    required this.noteAr,
    required this.images,
    this.allowedTransitions,
    this.refundBankDetails,
    this.receivedAt,
    this.deliveryType = '',
    this.orderKind = 'product',
    this.canReportUnavailable = false,
    this.shortages = const [],
    this.amountDue,
    this.courierStage,
    this.placedBy = '',
    this.customerPhone = '',
    this.addressLine = '',
    this.building = '',
    this.unit = '',
    this.deliveryInstructions = '',
    this.addons = const [],
    this.deliveryEmirate,
  });

  bool get isPending => status == OrderStatus.pending;

  /// May this order be moved to [target]? Server-driven when the payload says
  /// so, otherwise the documented ladder: pending → confirmed → preparing →
  /// ready, cancellable while pending.
  bool can(OrderStatus target) =>
      allowedTransitions?.contains(target) ??
      switch (target) {
        OrderStatus.confirmed => status == OrderStatus.pending,
        OrderStatus.cancelled => status == OrderStatus.pending,
        OrderStatus.preparing => status == OrderStatus.confirmed,
        OrderStatus.ready => status == OrderStatus.preparing,
        _ => false,
      };

  /// The single forward step to offer, if any (cancel is handled separately).
  OrderStatus? get nextStep => can(OrderStatus.preparing)
      ? OrderStatus.preparing
      : can(OrderStatus.ready)
          ? OrderStatus.ready
          : null;

  /// A live "waiting" clock is worth showing while the shop still owes this
  /// order an action — the server decides that via `allowed_transitions`.
  bool get hasTimer =>
      receivedAt != null && (can(OrderStatus.confirmed) || nextStep != null);
  // ponytail: the list endpoint's items carry no `note`/`media`, so the board's
  // request badge only lights up on orders with an order-level note. Drop the
  // items clause if the backend ever includes them in the list payload.
  bool get hasRequest =>
      note.isNotEmpty || images.isNotEmpty || items.any((i) => i.hasRequest);

  String localizedNote(String lang) =>
      lang == 'ar' && noteAr.isNotEmpty ? noteAr : note;

  Order copyWith({
    OrderStatus? status,
    List<OrderItem>? items,
    String? note,
    List<String>? images,
    List<OrderStatus>? allowedTransitions,
  }) =>
      Order(
        id: id,
        orderNumber: orderNumber,
        customer: customer,
        status: status ?? this.status,
        total: total,
        receivedAt: receivedAt,
        deliver: deliver,
        date: date,
        payment: payment,
        tags: tags,
        items: items ?? this.items,
        note: note ?? this.note,
        noteAr: noteAr,
        images: images ?? this.images,
        allowedTransitions: allowedTransitions ?? this.allowedTransitions,
        refundBankDetails: refundBankDetails,
        deliveryType: deliveryType,
        orderKind: orderKind,
        courierStage: courierStage,
        canReportUnavailable: canReportUnavailable,
        shortages: shortages,
        amountDue: amountDue,
        placedBy: placedBy,
        customerPhone: customerPhone,
        addressLine: addressLine,
        building: building,
        unit: unit,
        deliveryInstructions: deliveryInstructions,
        addons: addons,
        deliveryEmirate: deliveryEmirate,
      );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: int.tryParse(json['id'].toString()) ?? 0,
        orderNumber: json['order_number'] as String? ?? '',
        customer: (json['customer_name'] ?? json['customer']) as String? ?? '',
        status: OrderStatus.fromWire(json['status'] as String?),
        total: double.tryParse(json['total'].toString()) ?? 0,
        receivedAt: DateTime.tryParse(
            (json['received_at'] ?? json['created_at'])?.toString() ?? ''),
        deliver: (json['scheduled_slot_label'] ?? json['delivery_type'])
                as String? ??
            '',
        date: _isoDay(json['delivery_date'] ?? json['created_at']),
        payment: PaymentMethod.fromWire(
            json['payment_status'] == 'paid' ? 'paid' : 'cod'),
        tags: _tags(json),
        items: (json['items'] as List? ?? [])
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        note: (json['order_notes'] ??
                json['special_message'] ??
                json['gift_message']) as String? ??
            '',
        noteAr: '',
        images:
            (json['images'] as List? ?? []).map((e) => e.toString()).toList(),
        allowedTransitions: _transitions(json),
        deliveryType: json['delivery_type'] as String? ?? '',
        orderKind: json['order_kind'] as String? ?? 'product',
        canReportUnavailable: json['can_report_unavailable'] == true,
        shortages: _shortages(json['shortages']),
        amountDue: json['amount_due'] == null
            ? null
            : num.tryParse(json['amount_due'].toString()),
        courierStage: json['courier_stage'] as String?,
        placedBy: json['placed_by'] as String? ?? '',
        customerPhone: _phone(json),
        addressLine: json['delivery_address_line'] as String? ?? '',
        building: json['delivery_building'] as String? ?? '',
        unit: json['delivery_unit'] as String? ?? '',
        deliveryInstructions: json['delivery_instructions'] as String? ?? '',
        addons: (json['addons'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(OrderAddon.fromJson)
            .toList(),
        deliveryEmirate: json['delivery_emirate'] is Map<String, dynamic>
            ? DeliveryEmirate.fromJson(
                json['delivery_emirate'] as Map<String, dynamic>)
            : null,
        refundBankDetails: json['refund_bank_details'] is Map<String, dynamic>
            ? RefundBankDetails.fromJson(
                json['refund_bank_details'] as Map<String, dynamic>)
            : null,
      );

  /// `shortages` is the summary object, or null when nothing was reported.
  static List<Shortage> _shortages(Object? raw) {
    final units = raw is Map ? raw['units'] : raw;
    if (units is! List) return const [];
    return units
        .whereType<Map<String, dynamic>>()
        .map(Shortage.fromJson)
        .toList();
  }

  /// Dial code + number, as the shop typed them on a manual order.
  static String _phone(Map<String, dynamic> json) {
    final number =
        (json['customer_phone'] ?? json['recipient_phone']) as String? ?? '';
    if (number.isEmpty || number.startsWith('+')) return number;
    final cc = json['customer_country_code'] as String? ?? '';
    return cc.isEmpty ? number : '$cc $number';
  }

  /// `allowed_transitions` (the earlier draft called it `next`). Absent stays
  /// null so [can] knows to fall back rather than reading it as "no actions".
  static List<OrderStatus>? _transitions(Map<String, dynamic> json) {
    final raw = json['allowed_transitions'] ?? json['next'];
    if (raw is! List) return null;
    // Unknown values are dropped, not coerced — `fromWire` defaults to pending,
    // which would switch on the Accept button by accident.
    return [
      for (final e in raw)
        if (OrderStatus.values.any((s) => s.wire == e.toString()))
          OrderStatus.fromWire(e.toString()),
    ];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_number': orderNumber,
        'customer_name': customer,
        'status': status.wire,
        'total': total,
        'created_at': null,
        'scheduled_slot_label': deliver,
        'delivery_date': date,
        'payment_status': payment == PaymentMethod.paid ? 'paid' : 'unpaid',
        'is_gift': tags.contains(OrderType.gift) ? 1 : 0,
        'items': items.map((e) => e.toJson()).toList(),
        'gift_message': note,
        'images': images,
      };

  /// Whole minutes between `created_at` (ISO) and now; 0 if unparseable.

  /// First 10 chars of an ISO timestamp → yyyy-MM-dd.
  static String _isoDay(Object? v) {
    final s = v?.toString() ?? '';
    return s.length >= 10 ? s.substring(0, 10) : s;
  }

  static List<OrderType> _tags(Map<String, dynamic> json) {
    final t = OrderType.fromWire(json['delivery_type'] as String?);
    return [
      if (t != null) t,
      if (int.tryParse((json['is_gift'] ?? 0).toString()) == 1) OrderType.gift,
    ];
  }
}
