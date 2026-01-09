import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/review.dart';
import '../../data/review_data.dart';

/// Review state
class ReviewState {
  final List<Review> reviews;
  final bool isLoading;
  final String? error;
  final ReviewFilterState filterState;
  final Set<String> reportedReviewIds;

  const ReviewState({
    this.reviews = const [],
    this.isLoading = false,
    this.error,
    this.filterState = const ReviewFilterState(),
    this.reportedReviewIds = const {},
  });

  ReviewState copyWith({
    List<Review>? reviews,
    bool? isLoading,
    String? error,
    ReviewFilterState? filterState,
    Set<String>? reportedReviewIds,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterState: filterState ?? this.filterState,
      reportedReviewIds: reportedReviewIds ?? this.reportedReviewIds,
    );
  }
}

/// Review notifier with full functionality
class ReviewNotifier extends StateNotifier<ReviewState> {
  ReviewNotifier() : super(const ReviewState(isLoading: true)) {
    _loadReviews();
  }

  void _loadReviews() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        state = ReviewState(reviews: ReviewData.getReviews(), isLoading: false);
      }
    });
  }

  /// Add a new review
  void addReview(Review review) {
    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: review.productId,
      userId: review.userId,
      userName: review.userName,
      userAvatarUrl: review.userAvatarUrl,
      rating: review.rating,
      title: review.title,
      comment: review.comment,
      createdAt: DateTime.now(),
      images: review.images,
      helpfulCount: 0,
      isVerifiedPurchase: review.isVerifiedPurchase,
      status: ReviewStatus.approved,
    );

    state = state.copyWith(reviews: [newReview, ...state.reviews]);
  }

  /// Update an existing review
  void updateReview(
    String reviewId, {
    double? rating,
    String? title,
    String? comment,
    List<String>? images,
  }) {
    final updatedReviews = state.reviews.map((r) {
      if (r.id == reviewId) {
        return r.copyWith(
          rating: rating,
          title: title,
          comment: comment,
          images: images,
          updatedAt: DateTime.now(),
        );
      }
      return r;
    }).toList();

    state = state.copyWith(reviews: updatedReviews);
  }

  /// Delete a review
  void deleteReview(String reviewId) {
    final updatedReviews = state.reviews
        .where((r) => r.id != reviewId)
        .toList();
    state = state.copyWith(reviews: updatedReviews);
  }

  /// Mark review as helpful (with user tracking)
  void toggleHelpful(String reviewId, String visitorId) {
    final updatedReviews = state.reviews.map((r) {
      if (r.id == reviewId) {
        final hasMarked = r.hasUserMarkedHelpful(visitorId);
        final newVoters = List<String>.from(r.helpfulVoters);

        if (hasMarked) {
          newVoters.remove(visitorId);
          return r.copyWith(
            helpfulCount: r.helpfulCount - 1,
            helpfulVoters: newVoters,
          );
        } else {
          newVoters.add(visitorId);
          return r.copyWith(
            helpfulCount: r.helpfulCount + 1,
            helpfulVoters: newVoters,
          );
        }
      }
      return r;
    }).toList();

    state = state.copyWith(reviews: updatedReviews);
  }

  /// Report a review
  void reportReview(String reviewId, ReportReason reason) {
    final updatedReviews = state.reviews.map((r) {
      if (r.id == reviewId) {
        return r.copyWith(
          isReported: true,
          reportReason: reason.label,
          status: ReviewStatus.flagged,
        );
      }
      return r;
    }).toList();

    final newReportedIds = Set<String>.from(state.reportedReviewIds)
      ..add(reviewId);
    state = state.copyWith(
      reviews: updatedReviews,
      reportedReviewIds: newReportedIds,
    );
  }

  /// Update filter state
  void updateFilter(ReviewFilterState filterState) {
    state = state.copyWith(filterState: filterState);
  }

  /// Get filtered and sorted reviews for a product
  List<Review> getFilteredReviewsForProduct(String productId) {
    var reviews = state.reviews
        .where((r) => r.productId == productId)
        .where((r) => r.status == ReviewStatus.approved)
        .toList();

    final filter = state.filterState;

    // Apply rating filter
    if (filter.filterByRating != null) {
      reviews = reviews
          .where((r) => r.rating.round() == filter.filterByRating)
          .toList();
    }

    // Apply verified only filter
    if (filter.verifiedOnly) {
      reviews = reviews.where((r) => r.isVerifiedPurchase).toList();
    }

    // Apply with images only filter
    if (filter.withImagesOnly) {
      reviews = reviews.where((r) => r.images.isNotEmpty).toList();
    }

    // Apply sorting
    switch (filter.sortBy) {
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

  /// Get reviews for product (unfiltered)
  List<Review> getReviewsForProduct(String productId) {
    return state.reviews
        .where((r) => r.productId == productId)
        .where((r) => r.status == ReviewStatus.approved)
        .toList();
  }

  /// Get rating summary for product
  ProductRatingSummary getRatingSummary(String productId) {
    final productReviews = getReviewsForProduct(productId);
    if (productReviews.isEmpty) {
      return ProductRatingSummary(
        productId: productId,
        averageRating: 0,
        totalReviews: 0,
        ratingDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
      );
    }

    final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    double totalRating = 0;

    for (final review in productReviews) {
      final ratingKey = review.rating.round();
      distribution[ratingKey] = (distribution[ratingKey] ?? 0) + 1;
      totalRating += review.rating;
    }

    return ProductRatingSummary(
      productId: productId,
      averageRating: totalRating / productReviews.length,
      totalReviews: productReviews.length,
      ratingDistribution: distribution,
    );
  }

  /// Check if user has reviewed a product
  bool hasUserReviewedProduct(String productId, String visitorId) {
    return state.reviews.any(
      (r) => r.productId == productId && r.userId == visitorId,
    );
  }

  /// Get user's review for a product
  Review? getUserReviewForProduct(String productId, String visitorId) {
    try {
      return state.reviews.firstWhere(
        (r) => r.productId == productId && r.userId == visitorId,
      );
    } catch (_) {
      return null;
    }
  }
}

/// Review provider
final reviewProvider = StateNotifierProvider<ReviewNotifier, ReviewState>(
  (ref) => ReviewNotifier(),
);

/// Review filter state provider
final reviewFilterProvider = StateProvider<ReviewFilterState>(
  (ref) => const ReviewFilterState(),
);

/// Product reviews provider (unfiltered)
final productReviewsProvider = Provider.family<List<Review>, String>((
  ref,
  productId,
) {
  final reviewState = ref.watch(reviewProvider);
  return reviewState.reviews
      .where((r) => r.productId == productId)
      .where((r) => r.status == ReviewStatus.approved)
      .toList();
});

/// Filtered product reviews provider
final filteredProductReviewsProvider = Provider.family<List<Review>, String>((
  ref,
  productId,
) {
  final notifier = ref.read(reviewProvider.notifier);
  ref.watch(reviewProvider); // Watch for changes
  return notifier.getFilteredReviewsForProduct(productId);
});

/// Product rating summary provider
final productRatingSummaryProvider =
    Provider.family<ProductRatingSummary, String>((ref, productId) {
      final reviews = ref.watch(productReviewsProvider(productId));

      if (reviews.isEmpty) {
        return ProductRatingSummary(
          productId: productId,
          averageRating: 0,
          totalReviews: 0,
          ratingDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
        );
      }

      final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      double totalRating = 0;

      for (final review in reviews) {
        final ratingKey = review.rating.round();
        distribution[ratingKey] = (distribution[ratingKey] ?? 0) + 1;
        totalRating += review.rating;
      }

      return ProductRatingSummary(
        productId: productId,
        averageRating: totalRating / reviews.length,
        totalReviews: reviews.length,
        ratingDistribution: distribution,
      );
    });

/// Current user ID provider (mock - replace with actual auth)
final currentUserIdProvider = Provider<String>((ref) => 'current_user');
