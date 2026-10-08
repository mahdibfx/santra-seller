import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/models/auth_tokens.dart';
import 'package:santra_seller/models/cancel_reason.dart';
import 'package:santra_seller/models/failure.dart';
import 'package:santra_seller/models/order.dart';
import 'package:santra_seller/models/order_status.dart';
import 'package:santra_seller/models/paginated.dart';
import 'package:santra_seller/models/promotion_request.dart';
import 'package:santra_seller/models/seller_profile.dart';
import 'package:santra_seller/models/trading.dart';

// The bits most likely to break silently against the real partner API:
// un-enveloped auth tokens, dual-key profile fields, and defensive fallbacks.
void main() {
  test('AuthTokens reads top-level (un-enveloped) fields', () {
    final t = AuthTokens.fromJson(
        {'accessToken': 'a', 'refreshToken': 'r', 'expiresIn': 900});
    expect(t.accessToken, 'a');
    expect(t.refreshToken, 'r');
  });

  test('AuthTokens tolerates missing fields', () {
    final t = AuthTokens.fromJson({});
    expect(t.accessToken, '');
    expect(t.refreshToken, '');
  });

  test('SellerProfile reads partner camelCase keys', () {
    final p = SellerProfile.fromJson(
        {'nameEn': 'Mimi', 'nameAr': 'ميمي', 'logo': 'x.png'});
    expect(p.storeName, 'Mimi');
    expect(p.displayName('ar'), 'ميمي');
    expect(p.avatar, 'x.png');
    expect(p.openNow, true); // default when absent
  });

  test('SellerProfile reads the snake_case keys GET /me actually sends', () {
    final p = SellerProfile.fromJson(
        {'name_en': 'Mimi', 'name_ar': 'ميمي', 'logo_url': 'x.png'});
    expect(p.storeName, 'Mimi');
    expect(p.displayName('ar'), 'ميمي');
    expect(p.avatar, 'x.png');
    // /me carries no open/closed flag — hours are Santra-managed.
    expect(p.openNow, true);
  });

  test('Paginated.fromBody reads meta and computes hasMore', () {
    final p = Paginated.fromBody({
      'data': [
        {'id': 1},
        {'id': 2},
      ],
      'meta': {'page': 1, 'limit': 20, 'total': 137, 'totalPages': 7},
    }, (j) => j['id'], 1);
    expect(p.items, [1, 2]);
    expect(p.total, 137);
    expect(p.hasMore, true);
  });

  test('Paginated.fromBody falls back when meta is missing', () {
    final p = Paginated.fromBody({
      'data': [
        {'id': 1},
      ],
    }, (j) => j['id'], 1);
    expect(p.total, 1); // falls back to item count
    expect(p.totalPages, 1);
    expect(p.hasMore, false);
  });

  test('PromotionRequest reads partner share from terms_json snapshot', () {
    final r = PromotionRequest.fromJson({
      'id': 12,
      'stock_status': 'pending',
      'signature_status': 'pending',
      'funded_by': 'shared',
      'santra_share_pct': 60,
      'terms_json': {
        'funding': {
          'fundedBy': 'shared',
          'santraSharePct': 60,
          'partnerSharePct': 40
        },
      },
      'products': [
        {
          'id': 7578,
          'name_en': 'Cake',
          'track_inventory': 1,
          'stock_quantity': 12,
          'availability_status': 'online'
        },
      ],
    });
    expect(r.partnerShare, 40); // from the frozen snapshot, not re-derived
    expect(r.needsAction, true);
    expect(r.products.single.trackInventory, true);
    expect(r.products.single.stockQuantity, 12);
  });

  test('PromotionRequest derives partner share when terms absent (list row)',
      () {
    final r = PromotionRequest.fromJson({
      'id': 1,
      'stock_status': 'confirmed',
      'signature_status': 'not_required',
      'funded_by': 'santra',
      'santra_share_pct': 100,
    });
    expect(r.partnerShare, 0); // Santra-funded → partner pays nothing
    expect(r.needsAction, false);
  });

  group('allowed_transitions', () {
    Order order(Map<String, dynamic> extra) => Order.fromJson({
          'id': 1,
          'status': 'confirmed',
          'total': 100,
          ...extra,
        });

    test('drives the buttons when the server sends it', () {
      final o = order({
        'allowed_transitions': ['preparing', 'cancelled']
      });
      expect(o.can(OrderStatus.preparing), true);
      expect(o.can(OrderStatus.cancelled), true);
      expect(o.can(OrderStatus.confirmed), false);
      expect(o.nextStep, OrderStatus.preparing);
    });

    test('cancel follows the server, on any status', () {
      final confirmed = order({
        'allowed_transitions': ['preparing', 'cancelled']
      });
      expect(confirmed.can(OrderStatus.cancelled), true);
      final ready = order({'status': 'ready', 'allowed_transitions': []});
      expect(ready.can(OrderStatus.cancelled), false);
    });

    test('CancelReason picks the label for the language', () {
      final r = CancelReason.fromJson({
        'code': 'other',
        'label_en': 'Another reason',
        'label_ar': 'سبب آخر',
      });
      expect(r.label('en'), 'Another reason');
      expect(r.label('ar'), 'سبب آخر');
      expect(r.needsComment, true); // 'other' is the only one that does
    });

    test('empty list means no action is allowed', () {
      final o = order({'status': 'ready', 'allowed_transitions': []});
      expect(o.can(OrderStatus.cancelled), false);
      expect(o.nextStep, isNull);
    });

    test('falls back to the documented ladder when the field is absent', () {
      expect(order({'status': 'pending'}).can(OrderStatus.confirmed), true);
      expect(order({'status': 'pending'}).can(OrderStatus.cancelled), true);
      expect(order({}).nextStep, OrderStatus.preparing); // confirmed
      expect(order({'status': 'ready'}).can(OrderStatus.cancelled), false);
    });

    test('unknown values are dropped, not coerced to pending', () {
      final o = order({
        'allowed_transitions': ['teleported']
      });
      expect(o.can(OrderStatus.pending), false);
      expect(o.can(OrderStatus.confirmed), false);
    });
  });

  group('refund bank details', () {
    test('parses the block when Santra is waiting', () {
      final o = Order.fromJson({
        'id': 1,
        'status': 'confirmed',
        'total': 100,
        'refund_bank_details': {'needed': true, 'amount': 100},
      });
      expect(o.refundBankDetails?.needed, true);
      expect(o.refundBankDetails?.amount, 100);
    });

    test('null when nothing is waiting (and on the list endpoint)', () {
      final o = Order.fromJson({'id': 1, 'status': 'confirmed', 'total': 100});
      expect(o.refundBankDetails, isNull);
    });
  });

  test('Failure carries the API error code for per-code copy', () {
    const f = GeneralFailure('Invalid IBAN', code: 'BAD_IBAN');
    expect(f.code, 'BAD_IBAN');
    expect(const GeneralFailure('boom').code, isNull);
  });

  group('addons and destination', () {
    test('parses add-ons and the emirate', () {
      final o = Order.fromJson({
        'id': 1,
        'status': 'confirmed',
        'total': 100,
        'delivery_type': 'standard',
        'addons': [
          {
            'name_en': 'Birthday candle',
            'name_ar': 'شمعة عيد ميلاد',
            'quantity': 2,
            'unit_price': 5,
            'total_price': 10,
          }
        ],
        'delivery_emirate': {'name_en': 'Dubai', 'name_ar': 'دبي'},
      });
      expect(o.addons.single.quantity, 2);
      expect(o.addons.single.displayName('ar'), 'شمعة عيد ميلاد');
      expect(o.addons.single.totalPrice, 10);
      expect(o.deliveryEmirate?.displayName('en'), 'Dubai');
      expect(o.isPickup, false);
    });

    test('empty add-ons and a pickup with no emirate', () {
      final o = Order.fromJson({
        'id': 1,
        'status': 'confirmed',
        'total': 100,
        'delivery_type': 'pickup',
        'addons': [],
        'delivery_emirate': null,
      });
      expect(o.addons, isEmpty);
      expect(o.deliveryEmirate, isNull);
      expect(o.isPickup, true);
    });
  });

  group('manual vs app orders', () {
    test('a shop-entered order exposes the contact it typed', () {
      final o = Order.fromJson({
        'id': 1,
        'status': 'confirmed',
        'total': 100,
        'placed_by': 'partner',
        'customer_name': 'Khalid Noor',
        'customer_phone': '502223344',
        'customer_country_code': '+971',
        'delivery_address_line': 'Apt 802, Marina Heights',
        'delivery_building': 'Tower B',
        'delivery_instructions': 'Call on arrival',
      });
      expect(o.isManual, true);
      expect(o.customerPhone, '+971 502223344');
      expect(o.fullAddress, 'Tower B · Apt 802, Marina Heights');
      expect(o.deliveryInstructions, 'Call on arrival');
    });

    test('an app order has nothing to show but the first name', () {
      final o = Order.fromJson({
        'id': 1,
        'status': 'confirmed',
        'total': 100,
        'placed_by': 'customer',
        'customer_name': 'Mahdi',
        'delivery_emirate': {'name_en': 'Dubai', 'name_ar': 'دبي'},
      });
      expect(o.isManual, false);
      expect(o.customerPhone, '');
      expect(o.fullAddress, '');
    });
  });

  group('parcels and the waiting clock', () {
    test('a parcel is flagged and carries its courier stage', () {
      final o = Order.fromJson({
        'id': 1,
        'status': 'confirmed',
        'total': 30,
        'order_kind': 'delivery_service',
        'courier_stage': 'after_assignment',
        'allowed_transitions': ['cancelled'],
      });
      expect(o.isParcel, true);
      expect(o.courierStage, 'after_assignment');
      expect(o.can(OrderStatus.cancelled), true);
      expect(o.nextStep, isNull); // nothing to prepare
    });

    test('a product order defaults to the product kind', () {
      final o = Order.fromJson({'id': 1, 'status': 'pending', 'total': 10});
      expect(o.isParcel, false);
      expect(o.courierStage, isNull);
    });

    test('the clock counts from received_at, not the checkout start', () {
      final now = DateTime.now().toUtc();
      final o = Order.fromJson({
        'id': 1,
        'status': 'pending',
        'total': 10,
        'created_at':
            now.subtract(const Duration(minutes: 30)).toIso8601String(),
        'received_at':
            now.subtract(const Duration(minutes: 5)).toIso8601String(),
      });
      expect(o.placed, closeTo(5, 1));
      expect(o.hasTimer, true); // pending, so the shop still owes an action
    });

    test('no clock once the shop has nothing left to do', () {
      final o = Order.fromJson({
        'id': 1,
        'status': 'ready',
        'total': 10,
        'allowed_transitions': [],
        'received_at': DateTime.now().toUtc().toIso8601String(),
      });
      expect(o.hasTimer, false);
    });
  });

  group('shop pause and shortages', () {
    test('trading reads the server\'s choices, never hard-coded lengths', () {
      final t = Trading.fromJson({
        'status': 'busy',
        'busy_until': '2026-09-30T14:30:00.000Z',
        'max_until': '2026-10-01T02:00:00.000Z',
        'can_extend': true,
        'choices': {
          'busy': [30, 60, 120, 'day'],
          'extend': [30, 60],
          'max_minutes': 720,
        },
      });
      expect(t.isBusy, true);
      expect(t.busyChoices, [30, 60, 120, 'day']);
      expect(t.extendChoices, [30, 60]);
      expect(t.canExtend, true);
      expect(t.busyUntil, isNotNull);
    });

    test('a shop with no trading block is treated as open', () {
      final p = SellerProfile.fromJson({'name_en': 'Mimi'});
      expect(p.trading.isOpen, true);
      expect(p.trading.busyChoices, isEmpty);
    });

    test('shortages and what is still reportable', () {
      final o = Order.fromJson({
        'id': 1,
        'status': 'preparing',
        'total': 60,
        'amount_due': 52,
        'can_report_unavailable': true,
        'items': [
          {
            'id': 1234,
            'product_name_en': 'Laban 200 ml',
            'quantity': 4,
            'unavailable_quantity': 2,
          }
        ],
        'shortages': {
          'units': [
            {
              'order_item_id': 1234,
              'name_en': 'Laban 200 ml',
              'name_ar': 'لبن',
              'quantity': 2,
            }
          ],
          'customer_net': 4.0,
        },
      });
      expect(o.canReportUnavailable, true);
      expect(o.items.single.id, 1234);
      expect(o.items.single.unavailableQuantity, 2);
      expect(o.items.single.reportableQuantity, 2); // 4 ordered − 2 reported
      expect(o.shortages.single.displayName('ar'), 'لبن');
      expect(o.amountDue, 52);
    });

    test('an order with nothing reported offers no link and no shortages', () {
      final o = Order.fromJson({'id': 1, 'status': 'ready', 'total': 60});
      expect(o.canReportUnavailable, false);
      expect(o.shortages, isEmpty);
      expect(o.amountDue, isNull);
    });
  });

  group('profile open state comes from /me trading', () {
    SellerProfile me(String status) => SellerProfile.fromJson({
          'name_en': 'Mahdi Test Shop',
          'trading': {'status': status, 'busy_until': null},
        });

    test('a paused or closed shop no longer claims to be open', () {
      // Hardcoded true before this, which contradicted the orders board.
      expect(me('open').openNow, isTrue);
      expect(me('busy').openNow, isFalse);
      expect(me('closed').openNow, isFalse);
    });

    test('a payload without trading falls back to open', () {
      expect(SellerProfile.fromJson({'name_en': 'X'}).openNow, isTrue);
    });
  });
}
