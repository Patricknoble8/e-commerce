import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';

/// Text input field following shadcn/ui design
class InputField extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final String? value;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;

  const InputField({
    super.key,
    this.label,
    this.placeholder,
    this.value,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.foreground,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        TextField(
          controller: value != null ? TextEditingController(text: value) : null,
          onChanged: onChanged,
          cursorColor: AppColors.primary,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.foreground),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.mutedForeground,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.background,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingMd,
              vertical: AppSpacing.paddingSm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: AppColors.border,
                width: AppBorderWidth.thin,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: AppColors.border,
                width: AppBorderWidth.thin,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.ring,
                width: AppBorderWidth.medium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Search input field component
class SearchField extends StatelessWidget {
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchField({
    super.key,
    this.placeholder,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return InputField(
      placeholder: placeholder ?? 'Search...',
      onChanged: onChanged,
      prefixIcon: Icon(
        Icons.search,
        size: 20,
        color: AppColors.mutedForeground,
      ),
      suffixIcon: onClear != null
          ? IconButton(
              icon: Icon(
                Icons.close,
                size: 20,
                color: AppColors.mutedForeground,
              ),
              onPressed: onClear,
            )
          : null,
    );
  }
}
