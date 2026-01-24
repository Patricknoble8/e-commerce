import '../api_client.dart';
import '../api_config.dart';
import '../../../models/cart_item.dart';

/// Cart API Service
/// Handles cart operations - add, update, remove, and apply coupons
class CartService {
  final ApiClient _client;

  CartService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  // ============ Cart Operations ============

  /// Get current cart
  Future<Cart> getCart() async {
    final response = await _client.get(ApiConfig.cart);
    return Cart.fromJson(response.dataAsMap);
  }

  /// Add item to cart
  Future<Cart> addToCart({
    required String productId,
    required int quantity,
    String? size,
    String? color,
  }) async {
    final response = await _client.post(
      ApiConfig.addToCart,
      body: {
        'productId': productId,
        'quantity': quantity,
        if (size != null) 'size': size,
        if (color != null) 'color': color,
      },
    );
    return Cart.fromJson(response.dataAsMap);
  }

  /// Update cart item quantity
  Future<Cart> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    final response = await _client.put(
      ApiConfig.updateCartItem(itemId),
      body: {'quantity': quantity},
    );
    return Cart.fromJson(response.dataAsMap);
  }

  /// Remove item from cart
  Future<Cart> removeFromCart(String itemId) async {
    final response = await _client.delete(ApiConfig.removeFromCart(itemId));
    return Cart.fromJson(response.dataAsMap);
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    await _client.delete(ApiConfig.clearCart);
  }

  // ============ Coupon Operations ============

  /// Apply coupon code
  Future<CouponResult> applyCoupon(String couponCode) async {
    final response = await _client.post(
      ApiConfig.applyCoupon,
      body: {'code': couponCode},
    );
    return CouponResult.fromJson(response.dataAsMap);
  }

  /// Remove applied coupon
  Future<Cart> removeCoupon() async {
    final response = await _client.delete(ApiConfig.removeCoupon);
    return Cart.fromJson(response.dataAsMap);
  }

  // ============ Cart Calculations ============

  /// Get cart summary/totals
  Future<CartSummary> getCartSummary() async {
    final response = await _client.get('${ApiConfig.cart}/summary');
    return CartSummary.fromJson(response.dataAsMap);
  }

  /// Validate cart before checkout
  Future<CartValidation> validateCart() async {
    final response = await _client.post('${ApiConfig.cart}/validate');
    return CartValidation.fromJson(response.dataAsMap);
  }
}

/// Cart model from API
class Cart {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double shippingCost;
  final double tax;
  final double total;
  final String? couponCode;
  final int itemCount;

  Cart({
    required this.id,
    required this.items,
    required this.subtotal,
    this.discount = 0,
    this.shippingCost = 0,
    this.tax = 0,
    required this.total,
    this.couponCode,
    required this.itemCount,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      items:
          (json['items'] as List?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      shippingCost: (json['shippingCost'] ?? json['shipping'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      couponCode: json['couponCode'] ?? json['coupon'],
      itemCount:
          json['itemCount'] ??
          json['count'] ??
          (json['items'] as List?)?.length ??
          0,
    );
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  bool get hasCoupon => couponCode != null && couponCode!.isNotEmpty;
}

/// Coupon application result
class CouponResult {
  final bool valid;
  final String code;
  final String? discountType; // 'percentage' or 'fixed'
  final double discountValue;
  final double discountAmount;
  final String? message;
  final Cart? updatedCart;

  CouponResult({
    required this.valid,
    required this.code,
    this.discountType,
    this.discountValue = 0,
    this.discountAmount = 0,
    this.message,
    this.updatedCart,
  });

  factory CouponResult.fromJson(Map<String, dynamic> json) {
    return CouponResult(
      valid: json['valid'] ?? json['success'] ?? false,
      code: json['code'] ?? '',
      discountType: json['discountType'] ?? json['type'],
      discountValue: (json['discountValue'] ?? json['value'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? json['amount'] ?? 0)
          .toDouble(),
      message: json['message'],
      updatedCart: json['cart'] != null ? Cart.fromJson(json['cart']) : null,
    );
  }
}

/// Cart summary for checkout
class CartSummary {
  final double subtotal;
  final double discount;
  final double shippingCost;
  final double tax;
  final double total;
  final String? couponCode;
  final int itemCount;
  final List<ShippingOption> shippingOptions;

  CartSummary({
    required this.subtotal,
    this.discount = 0,
    this.shippingCost = 0,
    this.tax = 0,
    required this.total,
    this.couponCode,
    required this.itemCount,
    this.shippingOptions = const [],
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) {
    return CartSummary(
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      shippingCost: (json['shippingCost'] ?? json['shipping'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      couponCode: json['couponCode'],
      itemCount: json['itemCount'] ?? json['count'] ?? 0,
      shippingOptions:
          (json['shippingOptions'] as List?)
              ?.map((o) => ShippingOption.fromJson(o))
              .toList() ??
          [],
    );
  }
}

/// Shipping option
class ShippingOption {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String estimatedDelivery;

  ShippingOption({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.estimatedDelivery,
  });

  factory ShippingOption.fromJson(Map<String, dynamic> json) {
    return ShippingOption(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] ?? json['cost'] ?? 0).toDouble(),
      estimatedDelivery: json['estimatedDelivery'] ?? json['delivery'] ?? '',
    );
  }
}

/// Cart validation result
class CartValidation {
  final bool valid;
  final List<CartValidationError> errors;
  final List<CartItem> availableItems;
  final List<CartItem> unavailableItems;

  CartValidation({
    required this.valid,
    this.errors = const [],
    this.availableItems = const [],
    this.unavailableItems = const [],
  });

  factory CartValidation.fromJson(Map<String, dynamic> json) {
    return CartValidation(
      valid: json['valid'] ?? json['success'] ?? false,
      errors:
          (json['errors'] as List?)
              ?.map((e) => CartValidationError.fromJson(e))
              .toList() ??
          [],
      availableItems:
          (json['availableItems'] as List?)
              ?.map((i) => CartItem.fromJson(i))
              .toList() ??
          [],
      unavailableItems:
          (json['unavailableItems'] as List?)
              ?.map((i) => CartItem.fromJson(i))
              .toList() ??
          [],
    );
  }
}

/// Cart validation error
class CartValidationError {
  final String itemId;
  final String productId;
  final String message;
  final String type; // 'out_of_stock', 'quantity_exceeded', 'price_changed'

  CartValidationError({
    required this.itemId,
    required this.productId,
    required this.message,
    required this.type,
  });

  factory CartValidationError.fromJson(Map<String, dynamic> json) {
    return CartValidationError(
      itemId: json['itemId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'unknown',
    );
  }
}
