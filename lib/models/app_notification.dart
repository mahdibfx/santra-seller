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
      );

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: int.tryParse(json['id'].toString()) ?? 0,
        group: (json['group'] as String?) == 'earlier' ? NotifGroup.earlier : NotifGroup.today,
        tone: switch (json['tone'] as String?) {
          'green' => NotifTone.green,
          'amber' => NotifTone.amber,
          _ => NotifTone.brand,
        },
        icon: json['icon'] as String? ?? 'bell',
        unread: (json['unread'] as bool?) ?? false,
        title: json['title'] as String? ?? '',
        titleAr: json['titleAr'] as String? ?? '',
        body: json['body'] as String? ?? '',
        bodyAr: json['bodyAr'] as String? ?? '',
        time: json['time'] as String? ?? '',
        timeAr: json['timeAr'] as String? ?? '',
      );
}
