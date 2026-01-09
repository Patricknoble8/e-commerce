import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/review.dart';
import 'star_rating.dart';

/// Summary card showing rating overview
class ReviewSummaryCard extends StatelessWidget {
  final ProductRatingSummary summary;
  final VoidCallback? onWriteReviewTap;
  final ValueChanged<int?>? onRatingFilterTap;
  final int? selectedRating;

  const ReviewSummaryCard({
    super.key,
    required this.summary,
    this.onWriteReviewTap,
    this.onRatingFilterTap,
    this.selectedRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Reviews',
            style: AppTypography.h4.copyWith(color: AppColors.foreground),
          ),
          SizedBox(height: AppSpacing.md),

          // Rating distribution
          RatingDistribution(
            distribution: summary.ratingDistribution,
            totalReviews: summary.totalReviews,
            averageRating: summary.averageRating,
            onRatingFilterTap: onRatingFilterTap,
            selectedRating: selectedRating,
          ),

          SizedBox(height: AppSpacing.md),

          // Write review button
          if (onWriteReviewTap != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onWriteReviewTap,
                icon: Icon(Icons.rate_review_outlined),
                label: Text('Write a review'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  side: BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Compact rating display for product cards
class CompactRating extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final bool showCount;
  final double size;

  const CompactRating({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.showCount = true,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size, color: const Color(0xFFFACC15)),
        SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size - 2,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        if (showCount && reviewCount > 0) ...[
          SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: size - 2,
              color: AppColors.foregroundSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
