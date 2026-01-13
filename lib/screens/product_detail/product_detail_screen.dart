import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../models/product.dart';
import '../../models/review.dart';
import '../../widgets/common/common_widgets.dart';
import '../../widgets/reviews/reviews.dart';
import '../../widgets/product/product_detail_widgets.dart';
import '../../providers/providers.dart';
import '../reviews/product_reviews_screen.dart';
import '../reviews/write_review_screen.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedColor;
  dynamic _selectedSize;
  bool _isAddingToCart = false;
  final int _stockCount = 15; // Mock stock count - in production, get from API

  late AnimationController _fabAnimationController;

  @override
  void initState() {
    super.initState();
    if (widget.product.availableColors.isNotEmpty) {
      _selectedColor = widget.product.availableColors[0];
    }
    if (widget.product.availableSizes.isNotEmpty) {
      _selectedSize = widget.product.availableSizes[0];
    }
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Add to recently viewed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentlyViewedProvider.notifier).addProduct(widget.product);
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _addToCart() async {
    if (_selectedColor == null || _selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select color and size'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isAddingToCart = true);
    HapticFeedback.mediumImpact();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    ref
        .read(cartProvider.notifier)
        .addToCart(widget.product, _selectedColor!, _selectedSize);

    if (mounted) {
      setState(() => _isAddingToCart = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: AppSpacing.sm),
              Text('Added to cart'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'View Cart',
            textColor: Colors.white,
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratingSummary = ref.watch(
      productRatingSummaryProvider(widget.product.id),
    );
    final reviews = ref.watch(productReviewsProvider(widget.product.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom app bar
          _buildAppBar(),

          // Product content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image carousel
                ProductImageCarousel(
                  images: [
                    widget.product.imageUrl,
                    // Add more images in production
                  ],
                  heroTag: 'product-${widget.product.id}',
                ),

                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand
                      Text(
                        widget.product.brand,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),

                      // Product name
                      Text(
                        widget.product.name,
                        style: AppTypography.h3.copyWith(
                          color: AppColors.foreground,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),

                      // Rating and reviews
                      GestureDetector(
                        onTap: () => _navigateToReviews(),
                        child: Row(
                          children: [
                            StarRating(
                              rating: ratingSummary.averageRating,
                              size: 18,
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              '${ratingSummary.averageRating.toStringAsFixed(1)} (${ratingSummary.totalReviews} reviews)',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.foregroundSecondary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Price and stock
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceDisplay(
                            price: widget.product.finalPrice,
                            originalPrice: widget.product.hasDiscount
                                ? widget.product.price
                                : null,
                            discountPercent: widget.product.discount,
                            large: true,
                          ),
                          StockIndicator(stockCount: _stockCount),
                        ],
                      ),
                      SizedBox(height: AppSpacing.lg),

                      // Color selection
                      if (widget.product.availableColors.isNotEmpty) ...[
                        EnhancedColorSelector(
                          colors: widget.product.availableColors,
                          selectedColor: _selectedColor,
                          onColorSelected: (color) {
                            setState(() => _selectedColor = color);
                          },
                        ),
                        SizedBox(height: AppSpacing.lg),
                      ],

                      // Size selection
                      if (widget.product.availableSizes.isNotEmpty) ...[
                        EnhancedSizeSelector(
                          sizes: widget.product.availableSizes,
                          selectedSize: _selectedSize,
                          onSizeSelected: (size) {
                            setState(() => _selectedSize = size);
                          },
                          onSizeGuidePressed: () => _showSizeGuide(),
                        ),
                        SizedBox(height: AppSpacing.lg),
                      ],

                      const DividerComponent(),
                      SizedBox(height: AppSpacing.md),

                      // Description
                      Text(
                        'About',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.foreground,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.product.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.foregroundSecondary,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),

                      const DividerComponent(),
                      SizedBox(height: AppSpacing.md),

                      // Reviews section
                      _buildReviewsSection(ratingSummary, reviews),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: StickyAddToCartButton(
        price: widget.product.finalPrice,
        onAddToCart: _addToCart,
        isAddingToCart: _isAddingToCart,
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back, color: AppColors.foreground),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Product Details',
        style: AppTypography.h4.copyWith(color: AppColors.foreground),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.share_outlined, color: AppColors.foreground),
          ),
          onPressed: () {
            // Share product
            HapticFeedback.lightImpact();
          },
        ),
        Consumer(
          builder: (context, ref, _) {
            // Check if product is in wishlist
            return IconButton(
              icon: Container(
                padding: EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.favorite_border, color: AppColors.foreground),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                // Toggle wishlist
              },
            );
          },
        ),
        SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildReviewsSection(
    ProductRatingSummary summary,
    List<dynamic> reviews,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews (${summary.totalReviews})',
              style: AppTypography.h4.copyWith(color: AppColors.foreground),
            ),
            TextButton(
              onPressed: () => _navigateToReviews(),
              child: Text(
                'See All',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),

        // Rating summary
        if (summary.totalReviews > 0) ...[
          RatingDistribution(
            distribution: summary.ratingDistribution,
            totalReviews: summary.totalReviews,
            averageRating: summary.averageRating,
          ),
          SizedBox(height: AppSpacing.md),

          // Recent reviews preview (show first 2)
          ...reviews
              .take(2)
              .map(
                (review) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ReviewCard(
                    review: review,
                    onHelpfulTap: () {
                      final userId = ref.read(currentUserIdProvider);
                      ref
                          .read(reviewProvider.notifier)
                          .toggleHelpful(review.id, userId);
                    },
                    currentUserId: ref.read(currentUserIdProvider),
                  ),
                ),
              ),
        ] else ...[
          // Empty state
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.backgroundMuted,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 48,
                  color: AppColors.foregroundMuted,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'No reviews yet',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.foreground,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Be the first to review this product',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.foregroundSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: AppSpacing.md),

        // Write review button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _navigateToWriteReview(),
            icon: Icon(Icons.edit_outlined),
            label: Text('Write a Review'),
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
    );
  }

  void _navigateToReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductReviewsScreen(product: widget.product),
      ),
    );
  }

  void _navigateToWriteReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteReviewScreen(product: widget.product),
      ),
    );
  }

  void _showSizeGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(AppSpacing.md),
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
            Text('Size Guide', style: AppTypography.h4),
            SizedBox(height: AppSpacing.md),
            // Size chart table
            Table(
              border: TableBorder.all(color: AppColors.border),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: AppColors.backgroundMuted),
                  children: [
                    _buildTableCell('Size', isHeader: true),
                    _buildTableCell('US', isHeader: true),
                    _buildTableCell('EU', isHeader: true),
                    _buildTableCell('UK', isHeader: true),
                  ],
                ),
                ...['S', 'M', 'L', 'XL'].asMap().entries.map((entry) {
                  return TableRow(
                    children: [
                      _buildTableCell(entry.value),
                      _buildTableCell('${6 + entry.key * 2}'),
                      _buildTableCell('${36 + entry.key * 2}'),
                      _buildTableCell('${4 + entry.key * 2}'),
                    ],
                  );
                }),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            SafeArea(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: isHeader
            ? AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold)
            : AppTypography.bodySmall,
      ),
    );
  }
}
