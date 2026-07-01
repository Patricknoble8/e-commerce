import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/review.dart';
import '../../models/product.dart';
import '../../providers/providers.dart';
import '../../widgets/reviews/reviews.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/common/app_back_button.dart';
import 'write_review_screen.dart';

/// Screen showing all reviews for a product
class ProductReviewsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductReviewsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductReviewsScreen> createState() =>
      _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends ConsumerState<ProductReviewsScreen> {
  ReviewFilterState _filterState = const ReviewFilterState();

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewProvider);
    final summary = ref.watch(productRatingSummaryProvider(widget.product.id));
    final currentUserId = ref.watch(currentUserIdProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const AppBackButton(),
        title: Text('Reviews', style: AppTypography.h4),
        actions: [
          IconButton(
            icon: Icon(Icons.rate_review_outlined),
            onPressed: () => _navigateToWriteReview(),
            tooltip: 'Write a review',
          ),
        ],
      ),
      body: reviewState.isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
              onRefresh: () {
                ref.invalidate(reviewProvider);
                return Future<void>.value();
              },
              child: CustomScrollView(
                slivers: [
                  // Rating summary
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: ReviewSummaryCard(
                        summary: summary,
                        onWriteReviewTap: () => _navigateToWriteReview(),
                        onRatingFilterTap: (rating) {
                          setState(() {
                            _filterState = _filterState.copyWith(
                              filterByRating: rating,
                              clearRatingFilter: rating == null,
                            );
                          });
                          ref
                              .read(reviewProvider.notifier)
                              .updateFilter(_filterState);
                        },
                        selectedRating: _filterState.filterByRating,
                      ),
                    ),
                  ),

                  // Filter bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: ReviewFilterBar(
                        filterState: _filterState,
                        onFilterChanged: (state) {
                          setState(() => _filterState = state);
                          ref.read(reviewProvider.notifier).updateFilter(state);
                        },
                        totalReviews: _getFilteredReviews().length,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

                  // Reviews list
                  _buildReviewsList(currentUserId),

                  // Bottom padding
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
                ],
              ),
            ),
    );
  }

  List<Review> _getFilteredReviews() {
    final allReviews = ref.read(productReviewsProvider(widget.product.id));
    var reviews = allReviews;

    // Apply rating filter
    if (_filterState.filterByRating != null) {
      reviews = reviews
          .where((r) => r.rating.round() == _filterState.filterByRating)
          .toList();
    }

    // Apply verified only filter
    if (_filterState.verifiedOnly) {
      reviews = reviews.where((r) => r.isVerifiedPurchase).toList();
    }

    // Apply with images only filter
    if (_filterState.withImagesOnly) {
      reviews = reviews.where((r) => r.images.isNotEmpty).toList();
    }

    // Apply sorting
    switch (_filterState.sortBy) {
      case ReviewSortOption.mostRecent:
        reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case ReviewSortOption.mostHelpful:
        reviews.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
        break;
      case ReviewSortOption.highestRated:
        reviews.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ReviewSortOption.lowestRated:
        reviews.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }

    return reviews;
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: const ReviewCardShimmer(),
        );
      },
    );
  }

  Widget _buildReviewsList(String currentUserId) {
    final reviews = _getFilteredReviews();

    if (reviews.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyState(),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final review = reviews[index];
          final isCurrentUserReview = review.userId == currentUserId;

          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: ReviewCard(
              review: review,
              isCurrentUserReview: isCurrentUserReview,
              currentUserId: currentUserId,
              onHelpfulTap: () => _handleHelpfulTap(review.id, currentUserId),
              onReportTap: () => _showReportDialog(review),
              onEditTap: isCurrentUserReview
                  ? () => _navigateToWriteReview(existingReview: review)
                  : null,
              onDeleteTap: isCurrentUserReview
                  ? () => _showDeleteConfirmation(review)
                  : null,
            ),
          );
        }, childCount: reviews.length),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasFilters =
        _filterState.filterByRating != null ||
        _filterState.verifiedOnly ||
        _filterState.withImagesOnly;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.filter_list_off : Icons.rate_review_outlined,
              size: 64,
              color: AppColors.foregroundMuted,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              hasFilters ? 'No reviews match your filters' : 'No reviews yet',
              style: AppTypography.h4.copyWith(color: AppColors.foreground),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              hasFilters
                  ? 'Try adjusting your filters to see more reviews'
                  : 'Be the first to review this product',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.foregroundSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            if (hasFilters)
              OutlinedButton(
                onPressed: () {
                  setState(() => _filterState = const ReviewFilterState());
                  ref
                      .read(reviewProvider.notifier)
                      .updateFilter(const ReviewFilterState());
                },
                child: Text('Clear filters'),
              )
            else
              ElevatedButton.icon(
                onPressed: () => _navigateToWriteReview(),
                icon: Icon(Icons.rate_review_outlined),
                label: Text('Write a review'),
              ),
          ],
        ),
      ),
    );
  }

  void _handleHelpfulTap(String reviewId, String userId) {
    HapticFeedback.lightImpact();
    ref.read(reviewProvider.notifier).toggleHelpful(reviewId, userId);
  }

  void _navigateToWriteReview({Review? existingReview}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => WriteReviewScreen(
          product: widget.product,
          existingReview: existingReview,
        ),
      ),
    );

    if (result == true) {
      // Refresh the list
      setState(() {});
    }
  }

  void _showReportDialog(Review review) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => ReportReviewBottomSheet(
        onReport: (reason) {
          ref.read(reviewProvider.notifier).reportReview(review.id, reason);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Review reported. Thank you for your feedback.'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(Review review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Review'),
        content: Text(
          'Are you sure you want to delete your review? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(reviewProvider.notifier).deleteReview(review.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Review deleted'),
                  backgroundColor: AppColors.foreground,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for reporting a review
class ReportReviewBottomSheet extends StatefulWidget {
  final Function(ReportReason) onReport;

  const ReportReviewBottomSheet({super.key, required this.onReport});

  @override
  State<ReportReviewBottomSheet> createState() =>
      _ReportReviewBottomSheetState();
}

class _ReportReviewBottomSheetState extends State<ReportReviewBottomSheet> {
  ReportReason? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text('Report Review', style: AppTypography.h4),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Why are you reporting this review?',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.foregroundSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          RadioGroup<ReportReason>(
            groupValue: _selectedReason,
            onChanged: (value) => setState(() => _selectedReason = value),
            child: Column(
              children: ReportReason.values.map((reason) {
                return RadioListTile<ReportReason>(
                  title: Text(reason.label),
                  value: reason,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedReason != null
                  ? () => widget.onReport(_selectedReason!)
                  : null,
              child: Text('Submit Report'),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

/// Shimmer loading for review cards
class ReviewCardShimmer extends StatelessWidget {
  const ReviewCardShimmer({super.key});

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
          Row(
            children: [
              ShimmerLoading(width: 40, height: 40, borderRadius: 20),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(width: 100, height: 14, borderRadius: 4),
                    SizedBox(height: 4),
                    ShimmerLoading(width: 80, height: 12, borderRadius: 4),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          ShimmerLoading(width: 150, height: 16, borderRadius: 4),
          SizedBox(height: AppSpacing.sm),
          ShimmerLoading(width: double.infinity, height: 14, borderRadius: 4),
          SizedBox(height: 4),
          ShimmerLoading(width: double.infinity, height: 14, borderRadius: 4),
          SizedBox(height: 4),
          ShimmerLoading(width: 200, height: 14, borderRadius: 4),
        ],
      ),
    );
  }
}
