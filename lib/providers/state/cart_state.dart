import '../../models/cart_item.dart';

/// Cart state class
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(
        0,
        (sum, item) => sum + item.totalPrice,
      );

  double get deliveryCharge => subtotal > 0 ? 50 : 0;

  double get total => subtotal + deliveryCharge;

  bool isInCart(String productId) {
    return items.any((item) => item.product.id == productId);
  }

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
