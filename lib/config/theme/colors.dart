import 'package:flutter/material.dart';

/// App-wide color palette following shadcn/ui design system
/// Focus on muted, neutral colors with subtle accents
class AppColors {
  // ============ LIGHT THEME COLORS ============

  // Background colors
  static const background = Color(0xFFFFFFFF);
  static const backgroundSecondary = Color(0xFFF8F9FA);
  static const backgroundMuted = Color(0xFFF1F3F5);

  // Foreground/Text colors
  static const foreground = Color(0xFF0F172A);
  static const foregroundSecondary = Color(0xFF475569);
  static const foregroundMuted = Color(0xFF94A3B8);

  // Primary colors (subtle blues)
  static const primary = Color(0xFF0F172A);
  static const primaryHover = Color(0xFF1E293B);
  static const primaryForeground = Color(0xFFFFFFFF);

  // Secondary colors
  static const secondary = Color(0xFFF1F3F5);
  static const secondaryHover = Color(0xFFE2E8F0);
  static const secondaryForeground = Color(0xFF0F172A);

  // Border colors
  static const border = Color(0xFFE2E8F0);
  static const borderHover = Color(0xFFCBD5E1);

  // Ring/Focus colors
  static const ring = Color(0xFF3B82F6);

  // Accent colors (minimal use)
  static const accent = Color(0xFF3B82F6);
  static const accentForeground = Color(0xFFFFFFFF);

  // Status colors
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const destructive = Color(0xFFEF4444);

  // Card colors
  static const card = Color(0xFFFFFFFF);
  static const cardForeground = Color(0xFF0F172A);

  // Muted colors for less prominent elements
  static const muted = Color(0xFFF1F3F5);
  static const mutedForeground = Color(0xFF64748B);
}

/// Dark theme colors
class AppColorsDark {
  // Background colors
  static const background = Color(0xFF09090B);
  static const backgroundSecondary = Color(0xFF18181B);
  static const backgroundMuted = Color(0xFF27272A);

  // Foreground/Text colors
  static const foreground = Color(0xFFFAFAFA);
  static const foregroundSecondary = Color(0xFFA1A1AA);
  static const foregroundMuted = Color(0xFF71717A);

  // Primary colors
  static const primary = Color(0xFFFAFAFA);
  static const primaryHover = Color(0xFFE4E4E7);
  static const primaryForeground = Color(0xFF18181B);

  // Secondary colors
  static const secondary = Color(0xFF27272A);
  static const secondaryHover = Color(0xFF3F3F46);
  static const secondaryForeground = Color(0xFFFAFAFA);

  // Border colors
  static const border = Color(0xFF27272A);
  static const borderHover = Color(0xFF3F3F46);

  // Ring/Focus colors
  static const ring = Color(0xFF3B82F6);

  // Accent colors
  static const accent = Color(0xFF3B82F6);
  static const accentForeground = Color(0xFFFFFFFF);

  // Status colors
  static const success = Color(0xFF22C55E);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const destructive = Color(0xFFEF4444);

  // Card colors
  static const card = Color(0xFF18181B);
  static const cardForeground = Color(0xFFFAFAFA);

  // Muted colors
  static const muted = Color(0xFF27272A);
  static const mutedForeground = Color(0xFFA1A1AA);
}
