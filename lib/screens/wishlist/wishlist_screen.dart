import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../providers/notifiers/product_notifier.dart';
import '../../widgets/cards/cards.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final products = ref.watch(productListProvider);
    final favoriteProducts = products
        .where((p) => favorites.contains(p.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Wishlist',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
        actions: [
          if (favoriteProducts.isNotEmpty)
            TextButton(
              onPressed: () {
                // Clear all favorites
                for (var product in favoriteProducts) {
                  ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(product.id);
                }
              },
              child: Text(
                'Clear All',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.destructive,
                ),
              ),
            ),
        ],
      ),
      body: favoriteProducts.isEmpty
          ? _EmptyWishlist()
          : Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Text(
                        '${favoriteProducts.length} Items',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.foreground,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.sort, size: 18),
                        label: const Text('Sort'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.foregroundSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Product Grid
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(AppSpacing.md),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                    ),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];
                      return ProductCard(
                        imageUrl: product.imageUrl,
                        name: product.name,
                        price: '\$${product.finalPrice.toStringAsFixed(0)}',
                        originalPrice: product.hasDiscount
                            ? '\$${product.price.toStringAsFixed(0)}'
                            : null,
                        discountPercent: product.hasDiscount
                            ? product.discount!.toStringAsFixed(0)
                            : null,
                        brand: product.brand,
                        isFavorite: true,
                        onFavoriteToggle: () {
                          ref
                              .read(favoritesProvider.notifier)
                              .toggleFavorite(product.id);
                        },
                        onTap: () {
                          // Navigate to product detail
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Icon(
                Icons.favorite_border,
                size: 64,
                color: AppColors.foregroundSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Your Wishlist is Empty',
              style: AppTypography.h3.copyWith(color: AppColors.foreground),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Save your favorite items here\nto buy them later',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.foregroundSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text('Start Shopping', style: AppTypography.labelLarge),
            ),
          ],
        ),
      ),
    );
  }
}
