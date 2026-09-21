/// A page of list results plus the API's `meta` block.
class Paginated<T> {
  final List<T> items;
  final int page;
  final int totalPages;
  final int total;

  const Paginated({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.total,
  });

  bool get hasMore => page < totalPages;

  static int _int(Object? v, int fallback) => int.tryParse(v.toString()) ?? fallback;

  factory Paginated.fromBody(Map<String, dynamic> body, T Function(Map<String, dynamic>) item, int reqPage) {
    final items = (body['data'] as List? ?? []).map((e) => item(e as Map<String, dynamic>)).toList();
    final meta = body['meta'] as Map<String, dynamic>? ?? const {};
    return Paginated<T>(
      items: items,
      page: _int(meta['page'], reqPage),
      totalPages: _int(meta['totalPages'], 1),
      total: _int(meta['total'], items.length),
    );
  }
}
