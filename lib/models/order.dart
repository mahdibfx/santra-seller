import 'order_item.dart';
import 'order_status.dart';
import 'order_type.dart';

/// A seller order. Mirrors the design's mock order shape; see
/// `ApiOrdersService` for the documented backend JSON contract.
class Order {
  final int id;
  final String customer;
  final OrderStatus status;
  final int total;
  final int placed; // minutes since placed
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
  bool get hasRequest => note.isNotEmpty || images.isNotEmpty;

  String localizedNote(String lang) => lang == 'ar' && noteAr.isNotEmpty ? noteAr : note;

  Order copyWith({OrderStatus? status}) => Order(
        id: id,
        customer: customer,
        status: status ?? this.status,
        total: total,
        placed: placed,
        deliver: deliver,
        date: date,
        payment: payment,
        tags: tags,
        items: items,
        note: note,
        noteAr: noteAr,
        images: images,
        due: due,
        sla: sla,
      );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: int.tryParse(json['id'].toString()) ?? 0,
        customer: json['customer'] as String? ?? '',
        status: OrderStatus.fromWire(json['status'] as String?),
        total: int.tryParse(json['total'].toString()) ?? 0,
        placed: int.tryParse(json['placed'].toString()) ?? 0,
        deliver: json['deliver'] as String? ?? '',
        date: json['date'] as String? ?? '',
        payment: PaymentMethod.fromWire(json['payment'] as String?),
        tags: (json['tags'] as List? ?? [])
            .map((e) => OrderType.fromWire(e as String?))
            .whereType<OrderType>()
            .toList(),
        items: (json['items'] as List? ?? [])
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        note: json['note'] as String? ?? '',
        noteAr: json['noteAr'] as String? ?? '',
        images: (json['images'] as List? ?? []).map((e) => e.toString()).toList(),
        due: json['due'] == null ? null : int.tryParse(json['due'].toString()),
        sla: json['sla'] == null ? null : int.tryParse(json['sla'].toString()),
      );
}
