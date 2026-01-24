import 'product.dart';

/// Cart item model representing a product in the shopping cart
class CartItem {
  final String? id; // Cart item ID from backend
  final Product product;
  final int quantity;
  final String selectedColor;
  final int selectedSize;

  const CartItem({
    this.id,
    required this.product,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
  });

  double get totalPrice => product.finalPrice * quantity;

  /// Create from JSON (API response)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      product: json['product'] is Map<String, dynamic>
          ? Product.fromJson(json['product'])
          : Product(
              id: json['productId']?.toString() ?? '',
              name: json['name'] ?? json['productName'] ?? '',
              description: json['description'] ?? '',
              price: (json['price'] ?? 0).toDouble(),
              brand: json['brand'] ?? '',
              category: ProductCategory.clothing, // Default category
              imageUrl: json['image'] ?? json['imageUrl'] ?? '',
              availableColors: [],
              availableSizes: [],
              rating: 0,
              reviewCount: 0,
            ),
      quantity: json['quantity'] ?? 1,
      selectedColor: json['selectedColor'] ?? json['color'] ?? '',
      selectedSize: json['selectedSize'] ?? json['size'] ?? 0,
    );
  }

  /// Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'productId': product.id,
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'price': product.finalPrice,
    };
  }

  /// Convenience getters for API compatibility
  String get productId => product.id;
  String? get size => selectedSize.toString();
  String? get color => selectedColor;
  double get price => product.finalPrice;

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    String? selectedColor,
    int? selectedSize,
  }) {
    return CartItem(
      id: id ?? this.id,
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
