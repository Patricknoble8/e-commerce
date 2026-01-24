import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../services/api/services/cart_service.dart';
import '../state/cart_state.dart';

/// Global flag to enable/disable API mode for cart
bool useCartApiMode = true;

/// Cart StateNotifier for managing cart operations
class CartNotifier extends StateNotifier<CartState> {
  final CartService? _cartService;

  CartNotifier({CartService? cartService})
    : _cartService = cartService,
      super(const CartState());

  /// Load cart from API
  Future<void> loadCart() async {
    if (!useCartApiMode || _cartService == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final cart = await _cartService.getCart();
      state = state.copyWith(items: cart.items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Add product to cart with selected color and size
  Future<void> addToCart(Product product, String color, int size) async {
    if (useCartApiMode && _cartService != null) {
      state = state.copyWith(isLoading: true, error: null);
      try {
        final cart = await _cartService.addToCart(
          productId: product.id,
          quantity: 1,
          color: color,
          size: size.toString(),
        );
        state = state.copyWith(items: cart.items, isLoading: false);
        return;
      } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
        // Fall back to local mode on error
      }
    }

    // Local mode fallback
    final existingIndex = state.items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor == color &&
          item.selectedSize == size,
    );

    List<CartItem> updatedItems;

    if (existingIndex >= 0) {
      // Update quantity if item exists
      updatedItems = List.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
    } else {
      // Add new item
      updatedItems = [
        ...state.items,
        CartItem(
          product: product,
          quantity: 1,
          selectedColor: color,
          selectedSize: size,
        ),
      ];
    }

    state = state.copyWith(items: updatedItems);
  }

  /// Remove item from cart
  Future<void> removeFromCart(CartItem item) async {
    if (useCartApiMode && _cartService != null && item.id != null) {
      state = state.copyWith(isLoading: true, error: null);
      try {
        final cart = await _cartService.removeFromCart(item.id!);
        state = state.copyWith(items: cart.items, isLoading: false);
        return;
      } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }

    // Local mode fallback
    final updatedItems = state.items.where((i) => i != item).toList();
    state = state.copyWith(items: updatedItems);
  }

  /// Update quantity of an item
  Future<void> updateQuantity(CartItem item, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeFromCart(item);
      return;
    }

    if (useCartApiMode && _cartService != null && item.id != null) {
      state = state.copyWith(isLoading: true, error: null);
      try {
        final cart = await _cartService.updateCartItem(
          itemId: item.id!,
          quantity: newQuantity,
        );
        state = state.copyWith(items: cart.items, isLoading: false);
        return;
      } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }

    // Local mode fallback
    final index = state.items.indexOf(item);
    if (index >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[index] = item.copyWith(quantity: newQuantity);
      state = state.copyWith(items: updatedItems);
    }
  }

  /// Clear all items from cart
  Future<void> clearCart() async {
    if (useCartApiMode && _cartService != null) {
      state = state.copyWith(isLoading: true, error: null);
      try {
        await _cartService.clearCart();
        state = const CartState();
        return;
      } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }

    // Local mode fallback
    state = const CartState();
  }

  /// Check if product is in cart
  bool isInCart(String productId) {
    return state.isInCart(productId);
  }

  /// Get cart item count for a specific product
  int getProductCount(String productId) {
    return state.items
        .where((item) => item.product.id == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }
}

// Note: cartProvider and computed cart providers are defined in api_providers.dart
// Import from providers.dart to access cartProvider, cartItemCountProvider, etc.
