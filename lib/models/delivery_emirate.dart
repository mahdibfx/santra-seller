/// Where an app order is going. Santra's privacy rule: the shop is told the
/// emirate and the customer's first name, never the area or the address.
class DeliveryEmirate {
  final String name;
  final String nameAr;

  const DeliveryEmirate({required this.name, required this.nameAr});

  String displayName(String lang) =>
      lang == 'ar' && nameAr.isNotEmpty ? nameAr : name;

  factory DeliveryEmirate.fromJson(Map<String, dynamic> json) =>
      DeliveryEmirate(
        name: json['name_en'] as String? ?? '',
        nameAr: json['name_ar'] as String? ?? '',
      );
}
