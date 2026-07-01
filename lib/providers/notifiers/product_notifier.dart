import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../data/product_data.dart';
import '../../services/api/services/product_service.dart';
import '../../services/api/services/wishlist_service.dart';

/// Global flag for API mode - can be toggled at runtime
bool useProductApiMode = true;

/// Product list state for API mode
class ProductListState {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const ProductListState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  ProductListState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return ProductListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Product notifier for managing products
class ProductNotifier extends StateNotifier<ProductListState> {
  final ProductService? _productsService;

  ProductNotifier({ProductService? productsService})
    : _productsService = productsService,
      super(const ProductListState(isLoading: true)) {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (useProductApiMode && _productsService != null) {
      // API mode - fetch from backend
      try {
        final response = await _productsService.getProducts();
        if (mounted) {
          state = ProductListState(
            products: response.products,
            isLoading: false,
            hasMore: response.hasMore,
            currentPage: response.page,
          );
        }
      } catch (e) {
        // Fallback to demo data on API error
        if (mounted) {
          state = ProductListState(
            products: ProductData.products,
            isLoading: false,
            hasMore: false,
            error: e.toString(),
          );
        }
      }
    } else {
      if (mounted) {
        state = ProductListState(
          products: ProductData.products,
          isLoading: false,
          hasMore: false,
        );
      }
    }
  }

  /// Load more products (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true);

    if (useProductApiMode && _productsService != null) {
      try {
        final response = await _productsService.getProducts(
          page: state.currentPage + 1,
        );
        state = state.copyWith(
          products: [...state.products, ...response.products],
          isLoading: false,
          hasMore: response.hasMore,
          currentPage: response.page,
        );
      } catch (e) {
        state = state.copyWith(isLoading: false, error: 'Failed to load more');
      }
    } else {
      state = state.copyWith(isLoading: false, hasMore: false);
    }
  }

  /// Refresh products
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, currentPage: 1);
    await _loadProducts();
  }

  /// Search products
  Future<List<Product>> searchProducts(String query) async {
    if (useProductApiMode && _productsService != null) {
      try {
        final response = await _productsService.searchProducts(query: query);
        return response.products;
      } catch (e) {
        // Fallback to local search
      }
    }
    // Local search
    final queryLower = query.toLowerCase();
    return state.products.where((p) {
      return p.name.toLowerCase().contains(queryLower) ||
          p.brand.toLowerCase().contains(queryLower) ||
          p.description.toLowerCase().contains(queryLower);
    }).toList();
  }

  /// Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    if (useProductApiMode && _productsService != null) {
      try {
        return await _productsService.getFeaturedProducts();
      } catch (e) {
        // Fallback to local data
      }
    }
    return state.products.take(6).toList();
  }
}

/// Product notifier provider
final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, ProductListState>(
      (ref) => ProductNotifier(),
    );

/// Product list provider
final productListProvider = Provider<List<Product>>((ref) {
  return ref.watch(productNotifierProvider).products;
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
      return {ProductCategory.footwear};
    case ProductCategory.sportswear:
      return {ProductCategory.sportswear};
    case ProductCategory.clothing:
      return {ProductCategory.clothing};
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
      return {
        ProductCategory.accessories,
        ProductCategory.eyewear,
        ProductCategory.watches,
      };
    case ProductCategory.watches:
      return {ProductCategory.watches, ProductCategory.wearables};
    case ProductCategory.smartHome:
      return {ProductCategory.smartHome};
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

/// Favorite products state with API support
class FavoritesNotifier extends StateNotifier<Set<String>> {
  final WishlistService? _wishlistService;

  FavoritesNotifier({WishlistService? wishlistService})
    : _wishlistService = wishlistService,
      super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (useProductApiMode && _wishlistService != null) {
      try {
        final wishlist = await _wishlistService.getWishlist();
        state = wishlist.map((p) => p.id).toSet();
      } catch (e) {
        // Keep empty state on error
      }
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final wasInFavorites = state.contains(productId);

    // Optimistic update
    if (wasInFavorites) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }

    if (useProductApiMode && _wishlistService != null) {
      try {
        if (wasInFavorites) {
          await _wishlistService.removeFromWishlist(productId);
        } else {
          await _wishlistService.addToWishlist(productId);
        }
      } catch (e) {
        // Revert on error
        if (wasInFavorites) {
          state = {...state, productId};
        } else {
          state = {...state}..remove(productId);
        }
      }
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
