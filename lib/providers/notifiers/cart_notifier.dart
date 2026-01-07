import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../state/cart_state.dart';

/// Cart StateNotifier for managing cart operations
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  /// Add product to cart with selected color and size
  void addToCart(Product product, String color, int size) {
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
  void removeFromCart(CartItem item) {
    final updatedItems = state.items.where((i) => i != item).toList();
    state = state.copyWith(items: updatedItems);
  }

  /// Update quantity of an item
  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(item);
      return;
    }

    final index = state.items.indexOf(item);
    if (index >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[index] = item.copyWith(quantity: newQuantity);
      state = state.copyWith(items: updatedItems);
    }
  }

  /// Clear all items from cart
  void clearCart() {
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

/// Cart provider - Main state management for shopping cart
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

/// Computed providers for specific cart values
final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.itemCount;
});

final cartSubtotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.subtotal;
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.total;
});

final cartDeliveryChargeProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.deliveryCharge;
});
