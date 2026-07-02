import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';

/// Badge component for displaying count or status
class Badge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const Badge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingSm,
        vertical: AppSpacing.paddingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: textColor ?? AppColors.primaryForeground,
        ),
      ),
    );
  }
}

/// Chip component for selections
class ChipComponent extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const ChipComponent({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Material(
      color: isSelected ? AppColors.primary : AppColors.background,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingMd,
            vertical: AppSpacing.paddingSm,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: AppBorderWidth.thin,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? AppColors.primaryForeground
                      : AppColors.foreground,
                ),
                SizedBox(width: AppSpacing.gapXs),
              ],
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected
                      ? AppColors.primaryForeground
                      : AppColors.foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Color selector component
class ColorSelector extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const ColorSelector({
    super.key,
    required this.color,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.foreground : AppColors.border,
            width: isSelected ? AppBorderWidth.medium : AppBorderWidth.thin,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 18, color: Colors.white)
            : null,
      ),
    );
  }
}

/// Size selector button
class SizeSelector extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback? onTap;

  const SizeSelector({
    super.key,
    required this.size,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Material(
      color: isSelected ? AppColors.primary : AppColors.background,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: AppBorderWidth.thin,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Center(
            child: Text(
              size,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.primaryForeground
                    : AppColors.foreground,
                fontWeight: AppTypography.medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Divider component
class DividerComponent extends StatelessWidget {
  final double? height;

  const DividerComponent({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Container(
      height: height ?? AppBorderWidth.thin,
      color: AppColors.border,
    );
  }
}
