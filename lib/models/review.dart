/// Review model for product reviews and ratings
class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final double rating; // 1-5 stars (supports half stars)
  final String title;
  final String comment;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> images;
  final int helpfulCount;
  final bool isVerifiedPurchase;
  final List<String> helpfulVoters; // User IDs who marked helpful
  final bool isReported;
  final String? reportReason;
  final ReviewStatus status;

  const Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    required this.title,
    required this.comment,
    required this.createdAt,
    this.updatedAt,
    this.images = const [],
    this.helpfulCount = 0,
    this.isVerifiedPurchase = false,
    this.helpfulVoters = const [],
    this.isReported = false,
    this.reportReason,
    this.status = ReviewStatus.approved,
  });

  /// Check if a user has marked this review as helpful
  bool hasUserMarkedHelpful(String visitorId) {
    return helpfulVoters.contains(visitorId);
  }

  /// Get relative time string
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  Review copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    double? rating,
    String? title,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? images,
    int? helpfulCount,
    bool? isVerifiedPurchase,
    List<String>? helpfulVoters,
    bool? isReported,
    String? reportReason,
    ReviewStatus? status,
  }) {
    return Review(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
      helpfulVoters: helpfulVoters ?? this.helpfulVoters,
      isReported: isReported ?? this.isReported,
      reportReason: reportReason ?? this.reportReason,
      status: status ?? this.status,
    );
  }
}

/// Review status enum
enum ReviewStatus { pending, approved, rejected, flagged }

/// Report reasons for reviews
enum ReportReason {
  spam('Spam or fake review'),
  inappropriate('Inappropriate content'),
  offensive('Offensive language'),
  irrelevant('Not relevant to product'),
  misleading('Misleading information'),
  other('Other');

  final String label;
  const ReportReason(this.label);
}

/// Product rating summary
class ProductRatingSummary {
  final String productId;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // 1-5 -> count

  const ProductRatingSummary({
    required this.productId,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  /// Get percentage for a specific rating
  double getPercentageForRating(int rating) {
    if (totalReviews == 0) return 0;
    return ((ratingDistribution[rating] ?? 0) / totalReviews) * 100;
  }

  /// Get count for a specific rating
  int getCountForRating(int rating) {
    return ratingDistribution[rating] ?? 0;
  }
}

/// Review filter options
enum ReviewSortOption {
  mostRecent('Most Recent'),
  mostHelpful('Most Helpful'),
  highestRated('Highest Rated'),
  lowestRated('Lowest Rated');

  final String label;
  const ReviewSortOption(this.label);
}

/// Review filter state
class ReviewFilterState {
  final ReviewSortOption sortBy;
  final int? filterByRating; // null = all ratings
  final bool verifiedOnly;
  final bool withImagesOnly;

  const ReviewFilterState({
    this.sortBy = ReviewSortOption.mostRecent,
    this.filterByRating,
    this.verifiedOnly = false,
    this.withImagesOnly = false,
  });

  ReviewFilterState copyWith({
    ReviewSortOption? sortBy,
    int? filterByRating,
    bool? verifiedOnly,
    bool? withImagesOnly,
    bool clearRatingFilter = false,
  }) {
    return ReviewFilterState(
      sortBy: sortBy ?? this.sortBy,
      filterByRating: clearRatingFilter
          ? null
          : (filterByRating ?? this.filterByRating),
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      withImagesOnly: withImagesOnly ?? this.withImagesOnly,
    );
  }
}
