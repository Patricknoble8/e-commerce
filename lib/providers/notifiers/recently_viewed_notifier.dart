import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';

/// Recently viewed products state
class RecentlyViewedState {
  final List<Product> products;
  final int maxItems;

  const RecentlyViewedState({this.products = const [], this.maxItems = 20});

  RecentlyViewedState copyWith({List<Product>? products, int? maxItems}) {
    return RecentlyViewedState(
      products: products ?? this.products,
      maxItems: maxItems ?? this.maxItems,
    );
  }
}

/// Recently viewed notifier
class RecentlyViewedNotifier extends StateNotifier<RecentlyViewedState> {
  RecentlyViewedNotifier() : super(const RecentlyViewedState());

  /// Add product to recently viewed
  void addProduct(Product product) {
    // Remove if already exists
    final updatedProducts = state.products
        .where((p) => p.id != product.id)
        .toList();

    // Add to beginning
    updatedProducts.insert(0, product);

    // Limit to max items
    if (updatedProducts.length > state.maxItems) {
      updatedProducts.removeLast();
    }

    state = state.copyWith(products: updatedProducts);
  }

  /// Clear all recently viewed
  void clear() {
    state = state.copyWith(products: []);
  }

  /// Remove specific product
  void removeProduct(String productId) {
    final updatedProducts = state.products
        .where((p) => p.id != productId)
        .toList();
    state = state.copyWith(products: updatedProducts);
  }
}

/// Recently viewed provider
final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, RecentlyViewedState>(
      (ref) => RecentlyViewedNotifier(),
    );

/// Recently viewed products list provider
final recentlyViewedProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(recentlyViewedProvider).products;
});
