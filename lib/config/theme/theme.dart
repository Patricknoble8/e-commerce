import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// Main app theme configuration following shadcn/ui design principles
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.primaryForeground,
        onSecondary: AppColors.secondaryForeground,
        onSurface: AppColors.foreground,
        onError: Colors.white,
        outline: AppColors.border,
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.foreground,
          fontSize: 18,
          fontWeight: AppTypography.semiBold,
        ),
      ),

      // Card theme
      cardTheme: const CardThemeData(
        color: AppColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: AppColors.border, width: 1),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
      ),

      // Button themes defined in components
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.foreground,
          side: const BorderSide(color: AppColors.border, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.foreground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.muted,
        labelStyle: const TextStyle(color: AppColors.foreground),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColorsDark.background,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColorsDark.primary,
        secondary: AppColorsDark.secondary,
        surface: AppColorsDark.background,
        error: AppColorsDark.error,
        onPrimary: AppColorsDark.primaryForeground,
        onSecondary: AppColorsDark.secondaryForeground,
        onSurface: AppColorsDark.foreground,
        onError: Colors.white,
        outline: AppColorsDark.border,
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsDark.background,
        foregroundColor: AppColorsDark.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColorsDark.foreground,
          fontSize: 18,
          fontWeight: AppTypography.semiBold,
        ),
      ),

      // Card theme
      cardTheme: const CardThemeData(
        color: AppColorsDark.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: AppColorsDark.border, width: 1),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsDark.backgroundSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsDark.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsDark.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsDark.ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsDark.error, width: 1),
        ),
        labelStyle: const TextStyle(color: AppColorsDark.foregroundMuted),
        hintStyle: const TextStyle(color: AppColorsDark.foregroundMuted),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          foregroundColor: AppColorsDark.primaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsDark.foreground,
          side: const BorderSide(color: AppColorsDark.border, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsDark.foreground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColorsDark.border,
        thickness: 1,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColorsDark.muted,
        labelStyle: const TextStyle(color: AppColorsDark.foreground),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColorsDark.card,
        surfaceTintColor: Colors.transparent,
      ),

      // Dialog theme
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColorsDark.card,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
