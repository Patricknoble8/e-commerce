/// Spacing system based on 8px grid
/// Provides consistent spacing throughout the app
class AppSpacing {
  // Base unit (8px)
  static const double unit = 8.0;
  
  // Spacing values
  static const double xs = unit * 0.5;  // 4px
  static const double sm = unit;         // 8px
  static const double md = unit * 2;     // 16px
  static const double lg = unit * 3;     // 24px
  static const double xl = unit * 4;     // 32px
  static const double xxl = unit * 6;    // 48px
  
  // Padding presets
  static const double paddingXs = xs;
  static const double paddingSm = sm;
  static const double paddingMd = md;
  static const double paddingLg = lg;
  static const double paddingXl = xl;
  
  // Margin presets
  static const double marginXs = xs;
  static const double marginSm = sm;
  static const double marginMd = md;
  static const double marginLg = lg;
  static const double marginXl = xl;
  
  // Gap presets
  static const double gapXs = xs;
  static const double gapSm = sm;
  static const double gapMd = md;
  static const double gapLg = lg;
  static const double gapXl = xl;
}

/// Border radius values
class AppRadius {
  static const double sm = 4.0;
  static const double md = 6.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double full = 9999.0;
}

/// Border width values
class AppBorderWidth {
  static const double thin = 1.0;
  static const double medium = 1.5;
  static const double thick = 2.0;
}
