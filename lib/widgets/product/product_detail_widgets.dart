import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../widgets/reviews/review_image_gallery.dart';

/// Hero image carousel with zoom capability
class ProductImageCarousel extends StatefulWidget {
  final List<String> images;
  final String? heroTag;
  final double height;

  const ProductImageCarousel({
    super.key,
    required this.images,
    this.heroTag,
    this.height = 320,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openFullScreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return ReviewImageGallery(
            images: widget.images,
            initialIndex: _currentIndex,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images.isNotEmpty
        ? widget.images
        : ['assets/images/placeholder.png'];

    return Container(
      height: widget.height,
      color: AppColors.backgroundMuted,
      child: Stack(
        children: [
          // Image pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              HapticFeedback.selectionClick();
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _openFullScreen,
                child: Container(
                  color: AppColors.backgroundMuted,
                  child: _buildImage(images[index]),
                ),
              );
            },
          ),

          // Page indicator
          if (images.length > 1)
            Positioned(
              bottom: AppSpacing.md,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

          // Zoom hint
          Positioned(
            bottom: AppSpacing.md,
            right: AppSpacing.md,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.zoom_in, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Tap to zoom',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Thumbnail strip
          if (images.length > 1)
            Positioned(
              bottom: AppSpacing.md + 24,
              left: AppSpacing.md,
              right: AppSpacing.md,
              child: SizedBox(
                height: 50,
                child: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (_, __) => SizedBox(width: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final isSelected = index == _currentIndex;
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppRadius.sm - 1,
                            ),
                            child: Opacity(
                              opacity: isSelected ? 1.0 : 0.6,
                              child: _buildImage(
                                images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl, {BoxFit fit = BoxFit.contain}) {
    // Check if it's an asset or network image
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
      );
    } else {
      return Image.network(
        imageUrl,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
      );
    }
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.backgroundMuted,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: AppColors.foregroundMuted,
        ),
      ),
    );
  }
}

/// Stock availability indicator
class StockIndicator extends StatelessWidget {
  final int stockCount;
  final int lowStockThreshold;

  const StockIndicator({
    super.key,
    required this.stockCount,
    this.lowStockThreshold = 5,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    IconData icon;

    if (stockCount == 0) {
      color = AppColors.error;
      text = 'Out of Stock';
      icon = Icons.remove_circle_outline;
    } else if (stockCount <= lowStockThreshold) {
      color = AppColors.warning;
      text = 'Only $stockCount left';
      icon = Icons.warning_amber_rounded;
    } else {
      color = AppColors.success;
      text = 'In Stock';
      icon = Icons.check_circle_outline;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(text, style: AppTypography.labelSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

/// Price display with original and sale price
class PriceDisplay extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double? discountPercent;
  final bool large;

  const PriceDisplay({
    super.key,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Current price
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: large
              ? AppTypography.h2.copyWith(
                  color: hasDiscount ? AppColors.error : AppColors.foreground,
                  fontWeight: FontWeight.bold,
                )
              : AppTypography.h4.copyWith(
                  color: hasDiscount ? AppColors.error : AppColors.foreground,
                  fontWeight: FontWeight.bold,
                ),
        ),

        if (hasDiscount) ...[
          SizedBox(width: AppSpacing.sm),
          // Original price (strikethrough)
          Text(
            '\$${originalPrice!.toStringAsFixed(2)}',
            style: (large ? AppTypography.bodyLarge : AppTypography.bodyMedium)
                .copyWith(
                  color: AppColors.foregroundMuted,
                  decoration: TextDecoration.lineThrough,
                ),
          ),
          SizedBox(width: AppSpacing.sm),
          // Discount badge
          if (discountPercent != null)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                '-${discountPercent!.round()}%',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ],
    );
  }
}

/// Enhanced color selector
class EnhancedColorSelector extends StatelessWidget {
  final List<String> colors;
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  const EnhancedColorSelector({
    super.key,
    required this.colors,
    this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Color',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.foreground,
              ),
            ),
            if (selectedColor != null) ...[
              SizedBox(width: AppSpacing.sm),
              Text(
                '• $selectedColor',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: colors.map((colorName) {
            final isSelected = selectedColor == colorName;
            return GestureDetector(
              onTap: () {
                onColorSelected(colorName);
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getColorFromName(colorName),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 20,
                        color: _isLightColor(colorName)
                            ? AppColors.foreground
                            : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return const Color(0xFF2563EB);
      case 'white':
        return const Color(0xFFFFFFFF);
      case 'orange':
        return const Color(0xFFF97316);
      case 'sky blue':
        return const Color(0xFF38BDF8);
      case 'red':
        return const Color(0xFFEF4444);
      case 'black':
        return const Color(0xFF0F172A);
      case 'green':
        return const Color(0xFF22C55E);
      case 'yellow':
        return const Color(0xFFFACC15);
      case 'pink':
        return const Color(0xFFEC4899);
      case 'purple':
        return const Color(0xFF8B5CF6);
      case 'gray':
      case 'grey':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF64748B);
    }
  }

  bool _isLightColor(String colorName) {
    return ['white', 'yellow', 'sky blue'].contains(colorName.toLowerCase());
  }
}

/// Enhanced size selector
class EnhancedSizeSelector extends StatelessWidget {
  final List<dynamic> sizes;
  final dynamic selectedSize;
  final ValueChanged<dynamic> onSizeSelected;
  final bool showSizeGuide;
  final VoidCallback? onSizeGuidePressed;

  const EnhancedSizeSelector({
    super.key,
    required this.sizes,
    this.selectedSize,
    required this.onSizeSelected,
    this.showSizeGuide = true,
    this.onSizeGuidePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Size',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.foreground,
                  ),
                ),
                if (selectedSize != null) ...[
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    '• $selectedSize',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.foregroundSecondary,
                    ),
                  ),
                ],
              ],
            ),
            if (showSizeGuide)
              TextButton(
                onPressed: onSizeGuidePressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Size Guide',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: sizes.map((size) {
            final isSelected = selectedSize == size;
            return GestureDetector(
              onTap: () {
                onSizeSelected(size);
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    size.toString(),
                    style: AppTypography.labelLarge.copyWith(
                      color: isSelected
                          ? AppColors.primaryForeground
                          : AppColors.foreground,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Sticky add to cart button
class StickyAddToCartButton extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCart;
  final VoidCallback? onBuyNow;
  final bool isAddingToCart;

  const StickyAddToCartButton({
    super.key,
    required this.price,
    required this.onAddToCart,
    this.onBuyNow,
    this.isAddingToCart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Price',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.foregroundSecondary,
                    ),
                  ),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: AppTypography.h3.copyWith(
                      color: AppColors.foreground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md),
            // Add to cart button
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isAddingToCart ? null : onAddToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.primaryForeground,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: isAddingToCart
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryForeground,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 20),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              'Add to Cart',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.primaryForeground,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
