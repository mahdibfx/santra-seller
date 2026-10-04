/// The shop's own trading state, from `GET /me` → `trading`.
///
/// `busy` is a self-imposed pause that ends by itself; `closed` is "closed for
/// now", which only the web portal can set. The lengths offered come from the
/// server so Santra can change them without an app release.
class Trading {
  final String status; // open | busy | closed
  final DateTime? busyUntil;
  final DateTime? maxUntil;
  final bool canExtend;

  /// Pause lengths, as sent: whole minutes, or the string `day`.
  final List<Object> busyChoices;

  /// Extra minutes offered while paused.
  final List<int> extendChoices;

  const Trading({
    this.status = 'open',
    this.busyUntil,
    this.maxUntil,
    this.canExtend = false,
    this.busyChoices = const [],
    this.extendChoices = const [],
  });

  bool get isBusy => status == 'busy';
  bool get isClosed => status == 'closed';
  bool get isOpen => status == 'open';

  factory Trading.fromJson(Map<String, dynamic> json) {
    final choices = json['choices'] as Map<String, dynamic>? ?? const {};
    return Trading(
      status: json['status'] as String? ?? 'open',
      busyUntil: DateTime.tryParse(json['busy_until']?.toString() ?? ''),
      maxUntil: DateTime.tryParse(json['max_until']?.toString() ?? ''),
      canExtend: json['can_extend'] == true,
      busyChoices: (choices['busy'] as List? ?? const [])
          .map((e) => e is num ? e.toInt() as Object : e.toString() as Object)
          .toList(),
      extendChoices: (choices['extend'] as List? ?? const [])
          .map((e) => int.tryParse(e.toString()) ?? 0)
          .where((e) => e > 0)
          .toList(),
    );
  }
}
