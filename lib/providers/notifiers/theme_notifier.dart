import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme mode state
enum AppThemeMode { light, dark, system }

/// Theme notifier for managing app theme
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.system);

  /// Set theme mode
  void setThemeMode(AppThemeMode mode) {
    state = mode;
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    if (state == AppThemeMode.light) {
      state = AppThemeMode.dark;
    } else {
      state = AppThemeMode.light;
    }
  }

  /// Get the actual ThemeMode for MaterialApp
  ThemeMode get themeMode {
    switch (state) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

/// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>(
  (ref) => ThemeNotifier(),
);

/// Theme mode provider (convenience)
final themeModeProvider = Provider<ThemeMode>((ref) {
  final appThemeMode = ref.watch(themeProvider);
  switch (appThemeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
});

/// Is dark mode provider (convenience for UI checks)
final isDarkModeProvider = Provider<bool>((ref) {
  final mode = ref.watch(themeProvider);
  return mode == AppThemeMode.dark;
});
