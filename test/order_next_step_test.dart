import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/models/order.dart';
import 'package:santra_seller/models/order_status.dart';

/// The forward action a shop is offered. The shapes below are copied from
/// real staging orders (partner 3363, 20 Oct 2026), not invented.
void main() {
  Order order(String status, List<String> allowed, {String type = 'standard'}) =>
      Order.fromJson({
        'id': 1,
        'order_number': 'S260001',
        'status': status,
        'total': 100,
        'delivery_type': type,
        'allowed_transitions': allowed,
      });

  test('confirmed → start preparing', () {
    expect(order('confirmed', ['preparing']).nextStep, OrderStatus.preparing);
  });

  test('preparing → mark ready', () {
    expect(order('preparing', ['ready']).nextStep, OrderStatus.ready);
  });

  test('a ready PICKUP order can be marked collected', () {
    // Staging order 136. The server allows `delivered` here because the
    // customer collects at the counter and only the shop can say it left.
    // nextStep used to stop at `ready`, so this order showed no button at all
    // and sat there forever.
    expect(order('ready', ['delivered'], type: 'pickup').nextStep,
        OrderStatus.delivered);
  });

  test('a ready DELIVERY order offers nothing — the courier has it', () {
    // Staging orders 122, 135, 140. Out-for-delivery and delivered are
    // ops-side; the API answers 409 if a shop tries.
    expect(order('ready', [], type: 'standard').nextStep, isNull);
    expect(order('ready', [], type: 'express').nextStep, isNull);
  });

  test('pending offers no forward step — that is accept, handled apart', () {
    expect(order('pending', ['confirmed', 'cancelled']).nextStep, isNull);
  });

  test('finished orders offer nothing', () {
    expect(order('delivered', []).nextStep, isNull);
    expect(order('cancelled', []).nextStep, isNull);
  });
}
