import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/models/auth_tokens.dart';
import 'package:santra_seller/models/paginated.dart';
import 'package:santra_seller/models/promotion_request.dart';
import 'package:santra_seller/models/seller_profile.dart';

// The bits most likely to break silently against the real partner API:
// un-enveloped auth tokens, dual-key profile fields, and defensive fallbacks.
void main() {
  test('AuthTokens reads top-level (un-enveloped) fields', () {
    final t = AuthTokens.fromJson({'accessToken': 'a', 'refreshToken': 'r', 'expiresIn': 900});
    expect(t.accessToken, 'a');
    expect(t.refreshToken, 'r');
  });

  test('AuthTokens tolerates missing fields', () {
    final t = AuthTokens.fromJson({});
    expect(t.accessToken, '');
    expect(t.refreshToken, '');
  });

  test('SellerProfile reads partner camelCase keys', () {
    final p = SellerProfile.fromJson({'nameEn': 'Mimi', 'nameAr': 'ميمي', 'logo': 'x.png'});
    expect(p.storeName, 'Mimi');
    expect(p.displayName('ar'), 'ميمي');
    expect(p.avatar, 'x.png');
    expect(p.openNow, true); // default when absent
  });

  test('SellerProfile still reads legacy snake_case keys', () {
    final p = SellerProfile.fromJson({'store_name': 'Old', 'open_now': false});
    expect(p.storeName, 'Old');
    expect(p.openNow, false);
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
        'funding': {'fundedBy': 'shared', 'santraSharePct': 60, 'partnerSharePct': 40},
      },
      'products': [
        {'id': 7578, 'name_en': 'Cake', 'track_inventory': 1, 'stock_quantity': 12, 'availability_status': 'online'},
      ],
    });
    expect(r.partnerShare, 40); // from the frozen snapshot, not re-derived
    expect(r.needsAction, true);
    expect(r.products.single.trackInventory, true);
    expect(r.products.single.stockQuantity, 12);
  });

  test('PromotionRequest derives partner share when terms absent (list row)', () {
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
}
