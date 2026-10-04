/// Tone drives the icon-circle color (brand / green / amber).
enum NotifTone { brand, green, amber }

/// Section grouping in the notifications list.
enum NotifGroup { today, earlier }

class AppNotification {
  final int id;
  final NotifGroup group;
  final NotifTone tone;
  final String icon;
  final bool unread;
  final String title;
  final String titleAr;
  final String body;
  final String bodyAr;
  final String time;
  final String timeAr;

  /// Deep-link hints: `type` (e.g. `promo`) + the referenced record id.
  final String type;
  final int? referenceId;

  const AppNotification({
    required this.id,
    required this.group,
    required this.tone,
    required this.icon,
    required this.unread,
    required this.title,
    required this.titleAr,
    required this.body,
    required this.bodyAr,
    required this.time,
    required this.timeAr,
    this.type = '',
    this.referenceId,
  });

  String localizedTitle(String lang) => lang == 'ar' ? titleAr : title;
  String localizedBody(String lang) => lang == 'ar' ? bodyAr : body;
  String localizedTime(String lang) => lang == 'ar' ? timeAr : time;

  AppNotification copyWith({bool? unread}) => AppNotification(
        id: id,
        group: group,
        tone: tone,
        icon: icon,
        unread: unread ?? this.unread,
        title: title,
        titleAr: titleAr,
        body: body,
        bodyAr: bodyAr,
        time: time,
        timeAr: timeAr,
        type: type,
        referenceId: referenceId,
      );

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final created = DateTime.tryParse(json['created_at']?.toString() ?? '');
    final (icon, tone) = _look(json['type'] as String? ?? '');
    final (time, timeAr) = _ago(created);
    return AppNotification(
      id: int.tryParse(json['id'].toString()) ?? 0,
      group: _groupOf(created),
      tone: tone,
      icon: icon,
      // `is_read` comes back as 0/1, not a bool.
      unread: json['is_read'].toString() != '1' &&
          json['is_read'].toString() != 'true',
      title: (json['title_en'] ?? json['title']) as String? ?? '',
      titleAr: (json['title_ar'] ?? json['titleAr']) as String? ?? '',
      body: (json['body_en'] ?? json['body']) as String? ?? '',
      bodyAr: (json['body_ar'] ?? json['bodyAr']) as String? ?? '',
      time: time,
      timeAr: timeAr,
      type: json['type'] as String? ?? '',
      referenceId: json['reference_id'] == null
          ? null
          : int.tryParse(json['reference_id'].toString()),
    );
  }

  static NotifGroup _groupOf(DateTime? created) {
    if (created == null) return NotifGroup.earlier;
    final now = DateTime.now();
    final t = created.toLocal();
    return t.year == now.year && t.month == now.month && t.day == now.day
        ? NotifGroup.today
        : NotifGroup.earlier;
  }

  /// Icon + tone per notification `type`; the API sends no styling of its own.
  static (String, NotifTone) _look(String type) => switch (type) {
        'order_update' => ('bag', NotifTone.brand),
        'promotion_request' || 'promotion' => ('sparkle', NotifTone.amber),
        'invoice' || 'payout' || 'settlement' => ('wallet', NotifTone.green),
        'product' || 'product_review' => ('store', NotifTone.brand),
        _ => ('bell', NotifTone.brand),
      };

  /// Relative age, both languages. ponytail: two short switches beat pulling in
  /// a date-formatting package for four cases.
  static (String, String) _ago(DateTime? created) {
    if (created == null) return ('', '');
    final mins = DateTime.now().difference(created.toLocal()).inMinutes;
    if (mins < 1) return ('now', 'الآن');
    if (mins < 60) return ('${mins}m ago', 'منذ $mins د');
    final hours = mins ~/ 60;
    if (hours < 24) return ('${hours}h ago', 'منذ $hours س');
    final days = hours ~/ 24;
    return ('${days}d ago', 'منذ $days ي');
  }
}
