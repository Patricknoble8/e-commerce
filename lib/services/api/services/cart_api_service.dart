import 'package:e_commerce/services/api/api_client.dart';
import 'package:e_commerce/services/api/api_config.dart';
import 'package:e_commerce/models/cart_item.dart';
import 'package:e_commerce/models/product.dart';

/// Cart API response
class CartResponse {
  final List<CartItem> items;
  final double subtotal;
  final int itemCount;

  CartResponse({
    required this.items,
    required this.subtotal,
    required this.itemCount,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] ?? json['cart_items'] ?? []) as List;
    final items = itemsList
        .map((e) => _cartItemFromJson(e as Map<String, dynamic>))
        .toList();

    return CartResponse(
      items: items,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      itemCount: json['item_count'] ?? items.length,
    );
  }
}

/// Cart API Service
/// Handles shopping cart operations
class CartApiService {
  final ApiClient _client;

  CartApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get current user's cart
  Future<CartResponse> getCart() async {
    final response = await _client.get(ApiConfig.cart);
    return CartResponse.fromJson(response.data);
  }

  /// Add item to cart
  Future<CartResponse> addToCart({
    required String productId,
    required int quantity,
    String? color,
    String? size,
  }) async {
    final response = await _client.post(
      ApiConfig.addToCart,
      data: {
        'product_id': productId,
        'quantity': quantity,
        if (color != null) 'color': color,
        if (size != null) 'size': size,
      },
    );
    return CartResponse.fromJson(response.data);
  }

  /// Update cart item quantity
  Future<CartResponse> updateCartItem({
    required String cartItemId,
    required int quantity,
  }) async {
    final response = await _client.put(
      '${ApiConfig.updateCart}/$cartItemId',
      data: {'quantity': quantity},
    );
    return CartResponse.fromJson(response.data);
  }

  /// Remove item from cart
  Future<CartResponse> removeFromCart(String cartItemId) async {
    final response = await _client.delete(
      '${ApiConfig.removeFromCart}/$cartItemId',
    );
    return CartResponse.fromJson(response.data);
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    await _client.delete(ApiConfig.clearCart);
  }

  /// Sync local cart with server
  Future<CartResponse> syncCart(List<CartItem> localItems) async {
    final response = await _client.post(
      '${ApiConfig.cart}/sync',
      data: {
        'items': localItems
            .map(
              (item) => {
                'product_id': item.product.id,
                'quantity': item.quantity,
                'color': item.selectedColor,
                'size': item.selectedSize,
              },
            )
            .toList(),
      },
    );
    return CartResponse.fromJson(response.data);
  }
}

/// Helper function to parse CartItem from JSON
CartItem _cartItemFromJson(Map<String, dynamic> json) {
  final productJson = json['product'] ?? json;
  final product = Product.fromJson(productJson);

  return CartItem(
    product: product,
    quantity: json['quantity'] ?? 1,
    selectedColor: json['color'] ?? json['selected_color'],
    selectedSize: json['size'] ?? json['selected_size'],
  );
}
