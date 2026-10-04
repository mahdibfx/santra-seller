import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import 'app_text.dart';

/// (flag, dial code, name) — ponytail: hardcoded GCC + nearby markets instead
/// of a country-picker package. Add rows here when a new market onboards.
const countries = [
  ('🇦🇪', '+971', 'United Arab Emirates'),
  ('🇸🇦', '+966', 'Saudi Arabia'),
  ('🇶🇦', '+974', 'Qatar'),
  ('🇰🇼', '+965', 'Kuwait'),
  ('🇧🇭', '+973', 'Bahrain'),
  ('🇴🇲', '+968', 'Oman'),
  ('🇪🇬', '+20', 'Egypt'),
  ('🇯🇴', '+962', 'Jordan'),
  ('🇱🇧', '+961', 'Lebanon'),
  ('🇲🇦', '+212', 'Morocco'),
  ('🇹🇳', '+216', 'Tunisia'),
  ('🇩🇿', '+213', 'Algeria'),
  ('🇬🇧', '+44', 'United Kingdom'),
  ('🇺🇸', '+1', 'United States'),
  ('🇮🇳', '+91', 'India'),
  ('🇵🇰', '+92', 'Pakistan'),
  ('🇵🇭', '+63', 'Philippines'),
  ('🇹🇷', '+90', 'Türkiye'),
  ('🇫🇷', '+33', 'France'),
  ('🇩🇪', '+49', 'Germany'),
];

String flagFor(String dialCode) => countries
    .firstWhere((c) => c.$2 == dialCode, orElse: () => countries.first)
    .$1;

/// Bottom sheet listing supported dial codes. Returns the picked code, or null.
Future<String?> showCountrySheet(BuildContext context, String selected) =>
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x80143232),
      isScrollControlled: true,
      builder: (context) => _CountrySheet(selected: selected),
    );

class _CountrySheet extends StatelessWidget {
  const _CountrySheet({required this.selected});

  final String selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
                color: AppColors.lineStrong,
                borderRadius: BorderRadius.circular(999)),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              itemCount: countries.length,
              itemBuilder: (context, i) {
                final (flag, dial, name) = countries[i];
                final isSelected = dial == selected;
                return InkWell(
                  onTap: () => Navigator.of(context).pop(dial),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      children: [
                        Text(flag, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 14),
                        Expanded(child: AppText.body(name, fontSize: 16)),
                        AppText.body(
                          dial,
                          fontSize: 16,
                          color: isSelected ? AppColors.brand : AppColors.muted,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
