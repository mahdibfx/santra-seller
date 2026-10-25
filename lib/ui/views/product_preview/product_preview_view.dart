import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../app/app.locator.dart';
import '../../../models/order_item.dart';
import '../../../services/api/api_endpoints.dart';
import '../../../services/dio_service.dart';
import '../../common/app_colors.dart';
import '../../common/format.dart';
import '../../widgets/app_text.dart';
import '../../widgets/image_viewer.dart';
import '../../widgets/thumb_image.dart';
import '../../widgets/top_bar.dart';

/// Read-only product page, opened by tapping a line on an order.
///
/// Nothing here is selectable: the shop sees the product as the customer saw
/// it, with the options THIS customer picked ticked. The order line is drawn
/// first so the page is never blank, and stays as the fallback when the
/// product cannot be loaded (no `product_id` on the line, product deleted).
class ProductPreviewView extends StatelessWidget {
  const ProductPreviewView({super.key, required this.item});

  final OrderItem item;

  static Future<void> open(BuildContext context, OrderItem item) =>
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductPreviewView(item: item)));

  Future<Map<String, dynamic>?> _load() async {
    final id = item.productId;
    if (id == null) return null;
    try {
      final res = await locator<DioService>().dio.get(ApiEndpoints.product(id));
      final data = (res.data as Map<String, dynamic>)['data'];
      return data is Map<String, dynamic> ? data : null;
    } catch (_) {
      return null; // ponytail: silent fallback to the order line
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                22, MediaQuery.of(context).padding.top + 8, 22, 0),
            child: TopBar(onBack: () => Navigator.of(context).pop()),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _load(),
              builder: (context, snap) => _Body(
                item: item,
                product: snap.data == null ? null : _Product(snap.data!),
                loading: snap.connectionState != ConnectionState.done,
                lang: lang,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(
      {required this.item,
      required this.product,
      required this.loading,
      required this.lang});

  final OrderItem item;
  final _Product? product;
  final bool loading;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final p = product;
    final images = p != null && p.images.isNotEmpty
        ? p.images
        : [if (item.image.isNotEmpty) item.image];
    final name = p?.text('name', lang) ?? item.displayName(lang);
    // By id (the order line's `modifier_id` is the product option's `id`);
    // names only for a line that predates ids.
    final pickedIds = {for (final m in item.modifiers) m.modifierId}
      ..remove(null);
    final pickedNames = {
      for (final m in item.modifiers) ...[m.nameEn.trim(), m.nameAr.trim()]
    }..remove('');

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
      children: [
        if (images.isNotEmpty)
          SizedBox(
            height: 240,
            child: PageView(
              children: [
                for (int i = 0; i < images.length; i++)
                  GestureDetector(
                    onTap: () => showImageViewer(context, images, i),
                    child: LayoutBuilder(
                      builder: (_, c) => ThumbImage(
                          path: images[i], size: c.maxWidth, radius: 20),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 18),
        AppText.title(name),
        if (p?.price != null) ...[
          const SizedBox(height: 6),
          AppText(money(p!.price!, context),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.brand),
        ],
        if (loading) ...[
          const SizedBox(height: 24),
          const Center(
              child: CircularProgressIndicator(color: AppColors.brand)),
        ],
        if (p != null) ...[
          for (final f in [
            ('product_description', p.text('description', lang)),
            ('product_ingredients', p.text('ingredients', lang)),
            ('product_allergens', p.text('allergen_info', lang)),
            ('product_size', p.text('quantity_label', lang)),
          ])
            if (f.$2 != null) _Field(label: f.$1.tr(), value: f.$2!),
          for (final g in p.groups) ...[
            const SizedBox(height: 20),
            AppText(g.name(lang), fontSize: 15, fontWeight: FontWeight.w600),
            const SizedBox(height: 6),
            for (final o in g.options)
              _OptionRow(
                name: o.name(lang),
                price: o.price,
                chosen: pickedIds.contains(o.id) ||
                    (o.id == null &&
                        (pickedNames.contains(o.nameEn.trim()) ||
                            pickedNames.contains(o.nameAr.trim()))),
              ),
          ],
        ],
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(label,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.muted),
            const SizedBox(height: 4),
            AppText.body(value, fontSize: 14.5, height: 1.5),
          ],
        ),
      );
}

class _OptionRow extends StatelessWidget {
  const _OptionRow(
      {required this.name, required this.price, required this.chosen});
  final String name;
  final num price;
  final bool chosen;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: chosen ? AppColors.brandSofter : AppColors.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
              color: chosen ? AppColors.brand : AppColors.line,
              width: chosen ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(name,
                  fontSize: 14.5,
                  fontWeight: chosen ? FontWeight.w600 : FontWeight.w400),
            ),
            if (price > 0)
              AppText('+${money(price, context)}',
                  fontSize: 13.5, color: AppColors.muted),
            if (chosen) ...[
              const SizedBox(width: 8),
              const Icon(Icons.check_circle, size: 18, color: AppColors.brand),
            ],
          ],
        ),
      );
}

/// Reads `GET /partner/products/:id` — snake_case throughout, checked against
/// production on 22 Oct 2026; the groups arrive as `modifierGroups[].modifiers[]`
/// and `images[]` as `{url}`. The camelCase fallback costs nothing and covers a
/// rename.
class _Product {
  _Product(this.json);
  final Map<String, dynamic> json;

  dynamic _get(String snake) {
    if (json.containsKey(snake)) return json[snake];
    final camel = snake.replaceAllMapped(
        RegExp(r'_([a-z])'), (m) => m.group(1)!.toUpperCase());
    return json[camel];
  }

  String? text(String base, String lang) {
    final v = (lang == 'ar' ? _get('${base}_ar') : null) ??
        _get('${base}_en') ??
        _get(base);
    final s = v?.toString().trim() ?? '';
    return s.isEmpty ? null : s;
  }

  num? get price => num.tryParse(_get('price')?.toString() ?? '');

  List<String> get images => [
        for (final i in (_get('images') as List? ?? const []))
          i is Map ? (i['url'] ?? i['image_url'] ?? '').toString() : '$i',
        if ((_get('images') as List?)?.isEmpty ?? true)
          (_get('image_url') ?? '').toString(),
      ].where((u) => u.isNotEmpty).toList();

  List<_Group> get groups => [
        for (final g in (_get('modifier_groups') as List? ?? const []))
          if (g is Map<String, dynamic>) _Group(g),
      ];
}

class _Group {
  _Group(this.json);
  final Map<String, dynamic> json;

  String name(String lang) =>
      (lang == 'ar' ? json['name_ar'] ?? json['nameAr'] : null)?.toString() ??
      (json['name_en'] ?? json['nameEn'] ?? json['name'] ?? '').toString();

  List<_Option> get options => [
        for (final o
            in (json['modifiers'] ?? json['options'] ?? const []) as List)
          if (o is Map<String, dynamic>) _Option(o),
      ];
}

class _Option {
  _Option(this.json);
  final Map<String, dynamic> json;

  int? get id => int.tryParse(json['id']?.toString() ?? '');

  String get nameEn =>
      (json['name_en'] ?? json['nameEn'] ?? json['name'] ?? '').toString();
  String get nameAr => (json['name_ar'] ?? json['nameAr'] ?? '').toString();
  String name(String lang) =>
      lang == 'ar' && nameAr.isNotEmpty ? nameAr : nameEn;

  num get price =>
      num.tryParse((json['price_addition'] ??
              json['priceAddition'] ??
              json['price'] ??
              '')
          .toString()) ??
      0;
}
