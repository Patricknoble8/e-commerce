import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../data/product_data.dart';

/// Product list provider
final productListProvider = Provider<List<Product>>((ref) {
  return ProductData.products;
});

/// Product by ID provider
final productByIdProvider = Provider.family<Product, String>((ref, id) {
  return ProductData.getProductById(id);
});

/// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Selected category state
final selectedCategoryProvider = StateProvider<ProductCategory?>((ref) => null);

/// Price range state (min, max)
final priceRangeProvider = StateProvider<(double, double)?>((ref) => null);

/// Map legacy categories to new categories for filtering
Set<ProductCategory> _getCategoryMatches(ProductCategory selected) {
  switch (selected) {
    case ProductCategory.footwear:
      return {
        ProductCategory.footwear,
        ProductCategory.lifestyle,
        ProductCategory.running,
        ProductCategory.basketball,
        ProductCategory.casual,
        ProductCategory.skate,
      };
    case ProductCategory.sportswear:
      return {ProductCategory.sportswear, ProductCategory.training};
    case ProductCategory.clothing:
      return {ProductCategory.clothing, ProductCategory.apparel};
    case ProductCategory.smartphones:
      return {ProductCategory.smartphones};
    case ProductCategory.laptops:
      return {ProductCategory.laptops};
    case ProductCategory.audio:
      return {ProductCategory.audio};
    case ProductCategory.gaming:
      return {ProductCategory.gaming};
    case ProductCategory.wearables:
      return {ProductCategory.wearables, ProductCategory.watches};
    case ProductCategory.furniture:
      return {
        ProductCategory.furniture,
        ProductCategory.decor,
        ProductCategory.lighting,
      };
    case ProductCategory.kitchen:
      return {ProductCategory.kitchen};
    case ProductCategory.skincare:
      return {
        ProductCategory.skincare,
        ProductCategory.makeup,
        ProductCategory.haircare,
      };
    case ProductCategory.fragrance:
      return {ProductCategory.fragrance};
    case ProductCategory.fitnessEquipment:
      return {ProductCategory.fitnessEquipment, ProductCategory.outdoorGear};
    case ProductCategory.books:
      return {ProductCategory.books};
    case ProductCategory.toys:
      return {ProductCategory.toys, ProductCategory.babyClothing};
    case ProductCategory.petSupplies:
      return {ProductCategory.petSupplies};
    case ProductCategory.accessories:
      return {ProductCategory.accessories, ProductCategory.eyewear};
    case ProductCategory.watches:
      return {ProductCategory.watches};
    default:
      return {selected};
  }
}

/// Filtered products provider with search, category, and price range
final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productListProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase().trim();
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final priceRange = ref.watch(priceRangeProvider);

  var filtered = products;

  // Filter by search query
  if (searchQuery.isNotEmpty) {
    filtered = filtered.where((p) {
      return p.name.toLowerCase().contains(searchQuery) ||
          p.brand.toLowerCase().contains(searchQuery) ||
          p.description.toLowerCase().contains(searchQuery);
    }).toList();
  }

  // Filter by category (with legacy mapping)
  if (selectedCategory != null) {
    final matchingCategories = _getCategoryMatches(selectedCategory);
    filtered = filtered
        .where((p) => matchingCategories.contains(p.category))
        .toList();
  }

  // Filter by price range
  if (priceRange != null) {
    final (minPrice, maxPrice) = priceRange;
    filtered = filtered.where((p) {
      final price = p.finalPrice;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  return filtered;
});

/// Filtered products by category provider (legacy)
final productsByCategoryProvider = Provider.family<List<Product>, String>((
  ref,
  category,
) {
  final products = ref.watch(productListProvider);

  if (category == 'All') {
    return products;
  }

  // This is a simple example - you can implement actual category filtering
  return products;
});

/// Favorite products state
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }

  void clearFavorites() {
    state = {};
  }
}

/// Favorites provider
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) {
    return FavoritesNotifier();
  },
);

/// Favorite products list provider
final favoriteProductsProvider = Provider<List<Product>>((ref) {
  final favorites = ref.watch(favoritesProvider);
  final allProducts = ref.watch(productListProvider);

  return allProducts.where((p) => favorites.contains(p.id)).toList();
});
