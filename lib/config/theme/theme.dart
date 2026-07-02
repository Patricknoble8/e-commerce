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
      scaffoldBackgroundColor: AppColorsLight.background,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColorsLight.primary,
        secondary: AppColorsLight.secondary,
        surface: AppColorsLight.background,
        error: AppColorsLight.error,
        onPrimary: AppColorsLight.primaryForeground,
        onSecondary: AppColorsLight.secondaryForeground,
        onSurface: AppColorsLight.foreground,
        onSurfaceVariant: AppColorsLight.foregroundSecondary,
        onError: Colors.white,
        outline: AppColorsLight.border,
        outlineVariant: AppColorsLight.border,
        surfaceContainerLow: AppColorsLight.backgroundSecondary,
        surfaceContainerHighest: AppColorsLight.muted,
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsLight.background,
        foregroundColor: AppColorsLight.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColorsLight.foreground,
          fontSize: 18,
          fontWeight: AppTypography.semiBold,
        ),
      ),

      // Card theme
      cardTheme: const CardThemeData(
        color: AppColorsLight.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: AppColorsLight.border, width: 1),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsLight.background,
        labelStyle: const TextStyle(color: AppColorsLight.foregroundSecondary),
        floatingLabelStyle: const TextStyle(color: AppColorsLight.foreground),
        hintStyle: const TextStyle(color: AppColorsLight.mutedForeground),
        helperStyle: const TextStyle(color: AppColorsLight.foregroundSecondary),
        errorStyle: const TextStyle(color: AppColorsLight.error),
        prefixIconColor: AppColorsLight.foregroundSecondary,
        suffixIconColor: AppColorsLight.foregroundSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsLight.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsLight.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsLight.ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColorsLight.error, width: 1),
        ),
      ),

      // Button themes defined in components
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsLight.primary,
          foregroundColor: AppColorsLight.primaryForeground,
          disabledBackgroundColor: AppColorsLight.muted,
          disabledForegroundColor: AppColorsLight.mutedForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTypography.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColorsLight.primary,
        selectionColor: AppColorsLight.ring.withValues(alpha: 0.25),
        selectionHandleColor: AppColorsLight.ring,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColorsLight.primary,
          foregroundColor: AppColorsLight.primaryForeground,
          disabledBackgroundColor: AppColorsLight.muted,
          disabledForegroundColor: AppColorsLight.mutedForeground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTypography.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsLight.foreground,
          disabledForegroundColor: AppColorsLight.mutedForeground,
          side: const BorderSide(color: AppColorsLight.border, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTypography.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsLight.foreground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColorsLight.border,
        thickness: 1,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColorsLight.muted,
        labelStyle: const TextStyle(color: AppColorsLight.foreground),
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
        onSurfaceVariant: AppColorsDark.foregroundSecondary,
        onError: Colors.white,
        outline: AppColorsDark.border,
        outlineVariant: AppColorsDark.border,
        surfaceContainerLow: AppColorsDark.backgroundSecondary,
        surfaceContainerHighest: AppColorsDark.muted,
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
        labelStyle: const TextStyle(color: AppColorsDark.foregroundSecondary),
        floatingLabelStyle: const TextStyle(color: AppColorsDark.foreground),
        hintStyle: const TextStyle(color: AppColorsDark.mutedForeground),
        helperStyle: const TextStyle(color: AppColorsDark.foregroundSecondary),
        errorStyle: const TextStyle(color: AppColorsDark.error),
        prefixIconColor: AppColorsDark.foregroundSecondary,
        suffixIconColor: AppColorsDark.foregroundSecondary,
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
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColorsDark.primary,
        selectionColor: AppColorsDark.ring.withValues(alpha: 0.35),
        selectionHandleColor: AppColorsDark.ring,
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          foregroundColor: AppColorsDark.primaryForeground,
          disabledBackgroundColor: AppColorsDark.muted,
          disabledForegroundColor: AppColorsDark.mutedForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTypography.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          foregroundColor: AppColorsDark.primaryForeground,
          disabledBackgroundColor: AppColorsDark.muted,
          disabledForegroundColor: AppColorsDark.mutedForeground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTypography.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsDark.foreground,
          disabledForegroundColor: AppColorsDark.mutedForeground,
          side: const BorderSide(color: AppColorsDark.border, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTypography.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsDark.foreground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTypography.labelLarge,
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
