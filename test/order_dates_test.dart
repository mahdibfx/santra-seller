import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/models/order.dart';
import 'package:santra_seller/models/order_item.dart';

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

  test('placed is kept exactly as the server sent it', () {
    // No timezone shifting in the app: the backend decides what time an order
    // was placed, and converting here only creates a second opinion that
    // reads differently depending on which country the phone is in.
    final o = order({'created_at': '2026-10-13T06:02:11.000Z'});
    expect(o.createdAt, DateTime.utc(2026, 10, 13, 6, 2, 11));
  });

  test('both absent leaves nulls rather than a wrong date', () {
    final o = order({});
    expect(o.createdAt, isNull);
    expect(o.deliveryDate, '');
  });

  group('item modifiers', () {
    // Verified against production 18 Oct 2026: the server has always sent
    // these and the app never read them, so a cake ordered "10 inch,
    // chocolate sponge" reached the shop as "Cake ×1".
    OrderItem item(Map<String, dynamic> extra) => OrderItem.fromJson({
          'id': 1,
          'product_name_en': 'Cake',
          'product_name_ar': 'كيكة',
          'quantity': 1,
          ...extra,
        });

    test('what the customer chose is read, in both languages', () {
      final i = item({
        'modifiers': [
          {
            'group_name_en': 'Size',
            'group_name_ar': 'الحجم',
            'modifier_name_en': '10 inch',
            'modifier_name_ar': '10 إنش',
            'price_addition': 20,
            'quantity': 2,
          }
        ]
      });
      expect(i.modifiers, hasLength(1));
      final m = i.modifiers.single;
      expect(m.displayGroup('en'), 'Size');
      expect(m.displayGroup('ar'), 'الحجم');
      expect(m.displayName('en'), '10 inch');
      expect(m.displayName('ar'), '10 إنش');
      expect(m.priceAddition, 20);
      expect(m.quantity, 2);
    });

    test('a pick-many group collapses onto one line', () {
      // Two options from the SAME group must not repeat the group label down
      // the card; two options from DIFFERENT groups must stay apart, because
      // a cake's size and its sponge are two separate questions.
      final i = item({
        'modifiers': [
          {'group_name_en': 'Size', 'modifier_name_en': '10 inch'},
          {'group_name_en': 'Add-ons', 'modifier_name_en': 'Nuts'},
          {'group_name_en': 'Add-ons', 'modifier_name_en': 'Sprinkles'},
        ]
      });
      final grouped = i.groupedModifiers('en');
      expect(grouped, hasLength(2));
      expect(grouped.first.key, 'Size');
      expect(grouped.first.value, hasLength(1));
      expect(grouped.last.key, 'Add-ons');
      expect(grouped.last.value.map((m) => m.nameEn), ['Nuts', 'Sprinkles']);
    });

    test('groups keep the order the server sent them in', () {
      final i = item({
        'modifiers': [
          {'group_name_en': 'Sponge', 'modifier_name_en': 'Vanilla'},
          {'group_name_en': 'Size', 'modifier_name_en': '8 inch'},
        ]
      });
      expect(i.groupedModifiers('en').map((e) => e.key), ['Sponge', 'Size']);
    });

    test('an unnamed group keys on empty, so the UI shows the bare option',
        () {
      final i = item({
        'modifiers': [
          {'modifier_name_en': 'Extra hot'}
        ]
      });
      expect(i.groupedModifiers('en').single.key, '');
    });

    test('an item with no options parses to an empty list, not a crash', () {
      expect(item({}).modifiers, isEmpty);
      expect(item({'modifiers': null}).modifiers, isEmpty);
      expect(item({'modifiers': []}).modifiers, isEmpty);
    });

    test('Arabic falls back to English when the server left it blank', () {
      final i = item({
        'modifiers': [
          {'modifier_name_en': 'Extra nuts', 'modifier_name_ar': ''}
        ]
      });
      expect(i.modifiers.single.displayName('ar'), 'Extra nuts');
    });
  });
}
