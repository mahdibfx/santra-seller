import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/models/order.dart';

/// Shops could not see when an order is due or when it came in — neither date
/// was on any screen (partner complaint, 13 Oct 2026). Backend confirms
/// `delivery_date` (DATE at UTC midnight), `created_at` (placed, UTC) and
/// `delivery_type` on list, board and detail.
void main() {
  Order order(Map<String, dynamic> extra) => Order.fromJson({
        'id': 1,
        'order_number': 'S260001',
        'status': 'pending',
        'total': 100,
        ...extra,
      });

  test('delivery_date is read as a plain day', () {
    final o = order({'delivery_date': '2026-10-15T00:00:00.000Z'});
    expect(o.deliveryDate, '2026-10-15');
  });

  test('a missing delivery_date NEVER falls back to the placed day', () {
    // The screens label this "Delivery". Showing created_at there tells a shop
    // the order is due the day it was placed, and they bake on the wrong
    // morning. Empty means the row hides instead.
    final o = order({'created_at': '2026-10-13T06:00:00.000Z'});
    expect(o.deliveryDate, '');
  });

  test('placed comes from created_at, not received_at', () {
    // received_at is when the SHOP got it — for a card order, when the payment
    // landed. The timer counts from that; "Placed" must show when the customer
    // actually ordered.
    final o = order({
      'created_at': '2026-10-13T06:02:11.000Z',
      'received_at': '2026-10-13T06:14:40.000Z',
    });
    expect(o.createdAt, DateTime.utc(2026, 10, 13, 6, 2, 11));
    expect(o.receivedAt, DateTime.utc(2026, 10, 13, 6, 14, 40));
  });

  test('both absent leaves nulls rather than a wrong date', () {
    final o = order({});
    expect(o.createdAt, isNull);
    expect(o.deliveryDate, '');
  });
}
