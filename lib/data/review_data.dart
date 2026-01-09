import '../models/review.dart';

/// Demo review data for products
class ReviewData {
  /// Get reviews with proper dates
  static List<Review> getReviews() {
    final now = DateTime.now();
    return [
      // iPhone 15 Pro Max reviews
      Review(
        id: '1',
        productId: '1',
        userId: 'user1',
        userName: 'John D.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user1',
        rating: 5.0,
        title: 'Best iPhone Ever!',
        comment:
            'The titanium design feels premium and the camera quality is absolutely incredible. The A17 Pro chip handles everything I throw at it. Battery life is amazing too!',
        createdAt: now.subtract(const Duration(days: 1)),
        images: const [
          'https://picsum.photos/400/300?random=1',
          'https://picsum.photos/400/300?random=2',
        ],
        helpfulCount: 42,
        isVerifiedPurchase: true,
      ),
      Review(
        id: '2',
        productId: '1',
        userId: 'user2',
        userName: 'Sarah M.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user2',
        rating: 4.0,
        title: 'Great phone, minor issues',
        comment:
            'Love the phone overall. The camera is fantastic and the screen is gorgeous. Only complaint is the price and the weight - it\'s a bit heavier than my old phone.',
        createdAt: now.subtract(const Duration(days: 4)),
        images: const [],
        helpfulCount: 18,
        isVerifiedPurchase: true,
      ),
      Review(
        id: '3',
        productId: '1',
        userId: 'user3',
        userName: 'Michael K.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user3',
        rating: 5.0,
        title: 'Worth every penny',
        comment:
            'Upgraded from iPhone 12 and the difference is night and day. The Pro camera features are incredible for my photography hobby.',
        createdAt: now.subtract(const Duration(days: 7)),
        images: const ['https://picsum.photos/400/300?random=3'],
        helpfulCount: 25,
        isVerifiedPurchase: true,
      ),
      // Samsung Galaxy S24 Ultra reviews
      Review(
        id: '4',
        productId: '2',
        userId: 'user4',
        userName: 'Emily R.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user4',
        rating: 5.0,
        title: 'Galaxy AI is revolutionary',
        comment:
            'The AI features are game-changing! Circle to Search and the translation features have been incredibly useful. The S Pen is also great for note-taking.',
        createdAt: now.subtract(const Duration(days: 10)),
        images: const [
          'https://picsum.photos/400/300?random=4',
          'https://picsum.photos/400/300?random=5',
          'https://picsum.photos/400/300?random=6',
        ],
        helpfulCount: 35,
        isVerifiedPurchase: true,
      ),
      Review(
        id: '5',
        productId: '2',
        userId: 'user5',
        userName: 'David L.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user5',
        rating: 4.5,
        title: 'Excellent camera, good battery',
        comment:
            'The 200MP camera takes stunning photos. Battery easily lasts a full day. The titanium frame feels solid. Only wish the AI features were a bit more polished.',
        createdAt: now.subtract(const Duration(days: 13)),
        images: const [],
        helpfulCount: 22,
        isVerifiedPurchase: true,
      ),
      Review(
        id: '11',
        productId: '2',
        userId: 'user11',
        userName: 'Lisa T.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user11',
        rating: 3.0,
        title: 'Good but not great',
        comment:
            'Solid phone but not a huge upgrade from the S23 Ultra. The AI features are neat but I rarely use them. Camera is excellent though.',
        createdAt: now.subtract(const Duration(days: 20)),
        images: const [],
        helpfulCount: 12,
        isVerifiedPurchase: true,
      ),
      // MacBook Pro reviews
      Review(
        id: '6',
        productId: '3',
        userId: 'user6',
        userName: 'Alex T.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user6',
        rating: 5.0,
        title: 'Perfect for professionals',
        comment:
            'As a video editor, the M3 Max handles 8K footage without breaking a sweat. The battery life is insane - easily 15+ hours of real work. Worth every dollar.',
        createdAt: now.subtract(const Duration(days: 16)),
        images: const ['https://picsum.photos/400/300?random=7'],
        helpfulCount: 67,
        isVerifiedPurchase: true,
      ),
      Review(
        id: '7',
        productId: '3',
        userId: 'user7',
        userName: 'Jessica P.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user7',
        rating: 5.0,
        title: 'Best laptop I\'ve ever owned',
        comment:
            'Coming from a Windows laptop, this is a revelation. Everything is smooth, the display is stunning, and it stays cool even under heavy load.',
        createdAt: now.subtract(const Duration(days: 19)),
        images: const [],
        helpfulCount: 43,
        isVerifiedPurchase: true,
      ),
      // Sony WH-1000XM5 reviews
      Review(
        id: '8',
        productId: '5',
        userId: 'user8',
        userName: 'Chris B.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user8',
        rating: 5.0,
        title: 'Best noise cancelling ever',
        comment:
            'These headphones are incredible. The noise cancellation completely blocks out airplane noise. Sound quality is rich and balanced. Super comfortable for long listening sessions.',
        createdAt: now.subtract(const Duration(days: 22)),
        images: const [
          'https://picsum.photos/400/300?random=8',
          'https://picsum.photos/400/300?random=9',
        ],
        helpfulCount: 89,
        isVerifiedPurchase: true,
      ),
      Review(
        id: '9',
        productId: '5',
        userId: 'user9',
        userName: 'Amanda W.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user9',
        rating: 4.0,
        title: 'Great headphones with minor flaws',
        comment:
            'Sound quality and ANC are top-notch. My only complaints are that they don\'t fold like the XM4s and the touch controls can be finicky sometimes.',
        createdAt: now.subtract(const Duration(days: 25)),
        images: const [],
        helpfulCount: 34,
        isVerifiedPurchase: true,
      ),
      Review(
        id: '12',
        productId: '5',
        userId: 'user12',
        userName: 'Kevin M.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user12',
        rating: 2.0,
        title: 'Disappointed after XM4',
        comment:
            'The sound quality is good but not better than XM4. The new design doesn\'t fold which is a huge step back for portability. Returning these.',
        createdAt: now.subtract(const Duration(days: 30)),
        images: const [],
        helpfulCount: 56,
        isVerifiedPurchase: false,
      ),
      // Dell XPS reviews
      Review(
        id: '10',
        productId: '4',
        userId: 'user10',
        userName: 'Ryan M.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user10',
        rating: 5.0,
        title: 'Outstanding display',
        comment:
            'The OLED display on this Dell XPS is breathtaking. Colors are vibrant and blacks are truly black. Perfect for photo and video work.',
        createdAt: now.subtract(const Duration(days: 28)),
        images: const ['https://picsum.photos/400/300?random=10'],
        helpfulCount: 28,
        isVerifiedPurchase: true,
      ),
      Review(
        id: '13',
        productId: '4',
        userId: 'user13',
        userName: 'Nina S.',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=user13',
        rating: 4.5,
        title: 'Almost perfect',
        comment:
            'Beautiful laptop with great performance. The only issue is the webcam placement at the bottom of the screen - not great for video calls.',
        createdAt: now.subtract(const Duration(days: 35)),
        images: const [],
        helpfulCount: 15,
        isVerifiedPurchase: true,
      ),
    ];
  }

  /// Get reviews for a specific product
  static List<Review> getReviewsForProduct(String productId) {
    return getReviews().where((r) => r.productId == productId).toList();
  }

  /// Get rating summary for a product
  static ProductRatingSummary getRatingSummary(String productId) {
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
}
