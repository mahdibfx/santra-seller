import 'order_item.dart';
import 'order_status.dart';
import 'order_type.dart';

/// A seller order. Field names map to the partner API's order payload
/// (see `ApiOrdersService`); UI-only fields fall back to sensible defaults.
class Order {
  final int id;
  final String orderNumber; // e.g. "STEST08" — the human order reference
  final String customer;
  final OrderStatus status;
  final double total; // grand total, AED (may have decimals)
  final int placed; // minutes since placed (derived from created_at)
  final String deliver; // human delivery window, e.g. "Today · 6:00 PM"
  final String date; // ISO yyyy-MM-dd
  final PaymentMethod payment;
  final List<OrderType> tags;

  /// Minutes left to fulfil (negative = overdue). Null when not time-bound.
  final int? due;

  /// Full SLA window in minutes (denominator for the countdown bar).
  final int? sla;

  final List<OrderItem> items;
  final String note;
  final String noteAr;
  final List<String> images;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.customer,
    required this.status,
    required this.total,
    required this.placed,
    required this.deliver,
    required this.date,
    required this.payment,
    required this.tags,
    required this.items,
    required this.note,
    required this.noteAr,
    required this.images,
    this.due,
    this.sla,
  });

  bool get isPending => status == OrderStatus.pending;
  bool get hasTimer => due != null && sla != null;
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
  }) =>
      Order(
        id: id,
        orderNumber: orderNumber,
        customer: customer,
        status: status ?? this.status,
        total: total,
        placed: placed,
        deliver: deliver,
        date: date,
        payment: payment,
        tags: tags,
        items: items ?? this.items,
        note: note ?? this.note,
        noteAr: noteAr,
        images: images ?? this.images,
        due: due,
        sla: sla,
      );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: int.tryParse(json['id'].toString()) ?? 0,
        orderNumber: json['order_number'] as String? ?? '',
        customer: (json['customer_name'] ?? json['customer']) as String? ?? '',
        status: OrderStatus.fromWire(json['status'] as String?),
        total: double.tryParse(json['total'].toString()) ?? 0,
        placed: _minutesSince(json['created_at'] as String?),
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
        due: json['due'] == null ? null : int.tryParse(json['due'].toString()),
        sla: json['sla'] == null ? null : int.tryParse(json['sla'].toString()),
      );

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
        'due': due,
        'sla': sla,
      };

  /// Whole minutes between `created_at` (ISO) and now; 0 if unparseable.
  static int _minutesSince(String? iso) {
    if (iso == null) return 0;
    final t = DateTime.tryParse(iso);
    return t == null ? 0 : DateTime.now().difference(t).inMinutes;
  }

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
