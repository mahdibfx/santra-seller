/// Spacing scale and corner radii, named so views never hold magic numbers.
class AppSpacing {
  AppSpacing._();

  // Spacing
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 22;
  static const double xxl = 28;

  // Screen horizontal padding
  static const double screenH = 22;
}

/// Corner radii from the design (inputs 12–16, chips/cards 18–22, sheets 28).
class AppRadii {
  AppRadii._();

  static const double input = 16;
  static const double chip = 999;
  static const double card = 22;
  static const double cardInner = 18;
  static const double tile = 14;
  static const double sheet = 28;
}
