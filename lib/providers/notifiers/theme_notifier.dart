import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode state
enum AppThemeMode {
  light,
  dark,
  system;

  ThemeMode get materialThemeMode {
    return switch (this) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  Brightness resolveBrightness(Brightness systemBrightness) {
    return switch (this) {
      AppThemeMode.light => Brightness.light,
      AppThemeMode.dark => Brightness.dark,
      AppThemeMode.system => systemBrightness,
    };
  }

  String get title {
    return switch (this) {
      AppThemeMode.light => 'Light',
      AppThemeMode.dark => 'Dark',
      AppThemeMode.system => 'System',
    };
  }

  String get subtitle {
    return switch (this) {
      AppThemeMode.light => 'Always use light mode',
      AppThemeMode.dark => 'Always use dark mode',
      AppThemeMode.system => 'Follow device appearance',
    };
  }

  IconData get icon {
    return switch (this) {
      AppThemeMode.light => Icons.light_mode_outlined,
      AppThemeMode.dark => Icons.dark_mode_outlined,
      AppThemeMode.system => Icons.brightness_auto_outlined,
    };
  }

  static AppThemeMode fromStorageValue(String? value) {
    return switch (value) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      'system' => AppThemeMode.system,
      _ => AppThemeMode.system,
    };
  }
}

/// Theme notifier for managing app theme
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  static const storageKey = 'appearance_theme_mode';

  bool _hasLocalSelection = false;

  ThemeNotifier() : super(AppThemeMode.system) {
    unawaited(_loadThemeMode());
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = AppThemeMode.fromStorageValue(
        prefs.getString(storageKey),
      );

      if (!_hasLocalSelection) {
        state = savedMode;
      }
    } catch (_) {
      // Keep the safe default when preferences are unavailable.
    }
  }

  Future<void> _saveThemeMode(AppThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(storageKey, mode.name);
    } catch (_) {
      // The visual state should still update even if persistence fails.
    }
  }

  /// Set theme mode
  void setThemeMode(AppThemeMode mode) {
    _hasLocalSelection = true;
    if (state != mode) {
      state = mode;
    }
    unawaited(_saveThemeMode(mode));
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    if (state == AppThemeMode.light) {
      setThemeMode(AppThemeMode.dark);
    } else {
      setThemeMode(AppThemeMode.light);
    }
  }

  /// Get the actual ThemeMode for MaterialApp
  ThemeMode get themeMode => state.materialThemeMode;
}

/// Tracks platform brightness so "System" responds while the app is running.
class SystemBrightnessNotifier extends StateNotifier<Brightness>
    with WidgetsBindingObserver {
  SystemBrightnessNotifier({Brightness? initialBrightness})
    : super(
        initialBrightness ??
            WidgetsBinding.instance.platformDispatcher.platformBrightness,
      ) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    state = WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>(
  (ref) => ThemeNotifier(),
);

/// Platform brightness provider
final systemBrightnessProvider =
    StateNotifierProvider<SystemBrightnessNotifier, Brightness>(
      (ref) => SystemBrightnessNotifier(),
    );

/// Theme mode provider (convenience)
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeProvider).materialThemeMode;
});

/// Effective brightness provider for UI that needs the rendered appearance.
final effectiveBrightnessProvider = Provider<Brightness>((ref) {
  final appThemeMode = ref.watch(themeProvider);
  final systemBrightness = ref.watch(systemBrightnessProvider);

  return appThemeMode.resolveBrightness(systemBrightness);
});

/// Is dark mode provider (convenience for UI checks)
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(effectiveBrightnessProvider) == Brightness.dark;
});
