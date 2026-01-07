import 'product.dart';

/// Cart item model representing a product in the shopping cart
class CartItem {
  final Product product;
  final int quantity;
  final String selectedColor;
  final int selectedSize;

  const CartItem({
    required this.product,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
  });

  double get totalPrice => product.finalPrice * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedColor,
    int? selectedSize,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          product.id == other.product.id &&
          selectedColor == other.selectedColor &&
          selectedSize == other.selectedSize;

  @override
  int get hashCode =>
      product.id.hashCode ^ selectedColor.hashCode ^ selectedSize.hashCode;
}
