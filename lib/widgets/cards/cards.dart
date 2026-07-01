import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';

/// Card component following shadcn/ui design
/// Border-focused with minimal shadows
class CardComponent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool showBorder;

  const CardComponent({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: padding ?? EdgeInsets.all(AppSpacing.paddingMd),
          decoration: BoxDecoration(
            border: showBorder
                ? Border.all(
                    color: AppColors.border,
                    width: AppBorderWidth.thin,
                  )
                : null,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Product card component for grid display
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String? originalPrice;
  final String? discountPercent;
  final String? brand;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    this.brand,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      onTap: onTap,
      padding: EdgeInsets.all(AppSpacing.paddingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container with favorite button and discount badge
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundMuted,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.backgroundMuted,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: AppColors.mutedForeground,
                            ),
                            SizedBox(height: AppSpacing.xs),
                            Text(
                              'Image unavailable',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Discount badge
              if (discountPercent != null)
                Positioned(
                  top: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      '-$discountPercent%',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                  ),
                ),
              // Favorite button
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: AppColors.border,
                        width: AppBorderWidth.thin,
                      ),
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: isFavorite
                          ? const Color(0xFFEF4444)
                          : AppColors.foreground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          // Brand label
          if (brand != null) ...[
            Text(
              brand!.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.mutedForeground,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSpacing.xs),
          ],
          // Product name
          Text(
            name,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: AppTypography.medium,
              color: AppColors.foreground,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.xs),
          // Price section
          Row(
            children: [
              Text(
                price,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.foreground,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              if (originalPrice != null) ...[
                SizedBox(width: AppSpacing.sm),
                Text(
                  originalPrice!,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.mutedForeground,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
