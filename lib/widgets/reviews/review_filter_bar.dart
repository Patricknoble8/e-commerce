import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/review.dart';

/// Filter bar for reviews
class ReviewFilterBar extends StatelessWidget {
  final ReviewFilterState filterState;
  final ValueChanged<ReviewFilterState> onFilterChanged;
  final int totalReviews;

  const ReviewFilterBar({
    super.key,
    required this.filterState,
    required this.onFilterChanged,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    AppColors.bind(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sort dropdown and filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Sort dropdown
              _buildSortDropdown(),
              SizedBox(width: AppSpacing.sm),
              // Verified only chip
              _buildFilterChip(
                label: 'Verified',
                icon: Icons.verified,
                isSelected: filterState.verifiedOnly,
                onTap: () => onFilterChanged(
                  filterState.copyWith(verifiedOnly: !filterState.verifiedOnly),
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              // With images only chip
              _buildFilterChip(
                label: 'With photos',
                icon: Icons.photo_library_outlined,
                isSelected: filterState.withImagesOnly,
                onTap: () => onFilterChanged(
                  filterState.copyWith(
                    withImagesOnly: !filterState.withImagesOnly,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              // Rating filter chips
              ...List.generate(5, (index) {
                final rating = 5 - index;
                return Padding(
                  padding: EdgeInsets.only(right: AppSpacing.xs),
                  child: _buildFilterChip(
                    label: '$rating★',
                    isSelected: filterState.filterByRating == rating,
                    onTap: () {
                      if (filterState.filterByRating == rating) {
                        onFilterChanged(
                          filterState.copyWith(clearRatingFilter: true),
                        );
                      } else {
                        onFilterChanged(
                          filterState.copyWith(filterByRating: rating),
                        );
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        ),

        // Active filters summary
        if (_hasActiveFilters) ...[
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                '$totalReviews reviews',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => onFilterChanged(const ReviewFilterState()),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Clear filters',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  bool get _hasActiveFilters =>
      filterState.filterByRating != null ||
      filterState.verifiedOnly ||
      filterState.withImagesOnly;

  Widget _buildSortDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReviewSortOption>(
          value: filterState.sortBy,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.foregroundSecondary,
          ),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.foreground,
          ),
          items: ReviewSortOption.values.map((option) {
            return DropdownMenuItem(value: option, child: Text(option.label));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onFilterChanged(filterState.copyWith(sortBy: value));
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? AppColors.primary : AppColors.background,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: isSelected
                      ? AppColors.primaryForeground
                      : AppColors.foregroundSecondary,
                ),
                SizedBox(width: 4),
              ],
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
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
