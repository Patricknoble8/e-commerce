import 'package:e_commerce/services/api/api_client.dart';
import 'package:e_commerce/services/api/api_config.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/models/cart_item.dart';
import 'package:e_commerce/models/shipping_address.dart';
import 'package:e_commerce/models/product.dart';

/// Paginated response for orders
class OrdersResponse {
  final List<Order> orders;
  final int total;
  final int page;
  final int perPage;
  final bool hasMore;

  OrdersResponse({
    required this.orders,
    required this.total,
    required this.page,
    required this.perPage,
    required this.hasMore,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    final ordersList = (json['orders'] ?? json['data'] ?? []) as List;
    final meta = json['meta'] ?? json;

    return OrdersResponse(
      orders: ordersList.map((e) => OrderFromJson.fromJson(e)).toList(),
      total: meta['total'] ?? ordersList.length,
      page: meta['page'] ?? meta['current_page'] ?? 1,
      perPage: meta['per_page'] ?? meta['limit'] ?? 20,
      hasMore: meta['has_more'] ?? meta['has_next_page'] ?? false,
    );
  }
}

/// Create order request model
class CreateOrderRequest {
  final List<CartItem> items;
  final ShippingAddress shippingAddress;
  final String paymentMethodId;
  final String? promoCode;
  final String? notes;

  CreateOrderRequest({
    required this.items,
    required this.shippingAddress,
    required this.paymentMethodId,
    this.promoCode,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items
          .map(
            (item) => {
              'product_id': item.product.id,
              'quantity': item.quantity,
              'color': item.selectedColor,
              'size': item.selectedSize,
            },
          )
          .toList(),
      'shipping_address': {
        'name': shippingAddress.name,
        'street': shippingAddress.street,
        'city': shippingAddress.city,
        'state': shippingAddress.state,
        'zip_code': shippingAddress.zipCode,
        'country': shippingAddress.country,
        'phone': shippingAddress.phone,
      },
      'payment_method_id': paymentMethodId,
      if (promoCode != null) 'promo_code': promoCode,
      if (notes != null) 'notes': notes,
    };
  }
}

/// Orders API Service
/// Handles order creation, listing, tracking, and cancellation
class OrdersApiService {
  final ApiClient _client;

  OrdersApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get all orders for the current user
  Future<OrdersResponse> getOrders({
    int page = 1,
    int perPage = 20,
    OrderStatus? status,
  }) async {
    final response = await _client.get(
      ApiConfig.orders,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (status != null) 'status': status.name,
      },
    );

    return OrdersResponse.fromJson(response.data);
  }

  /// Get a single order by ID
  Future<Order> getOrder(String id) async {
    final response = await _client.get('${ApiConfig.orderDetail}/$id');
    return OrderFromJson.fromJson(response.data['order'] ?? response.data);
  }

  /// Create a new order
  Future<Order> createOrder(CreateOrderRequest request) async {
    final response = await _client.post(
      ApiConfig.createOrder,
      data: request.toJson(),
    );
    return OrderFromJson.fromJson(response.data['order'] ?? response.data);
  }

  /// Cancel an order
  Future<Order> cancelOrder(String orderId, {String? reason}) async {
    final response = await _client.post(
      ApiConfig.cancelOrder,
      data: {'order_id': orderId, if (reason != null) 'reason': reason},
    );
    return OrderFromJson.fromJson(response.data['order'] ?? response.data);
  }

  /// Get order tracking information
  Future<Map<String, dynamic>> trackOrder(String orderId) async {
    final response = await _client.get('${ApiConfig.trackOrder}/$orderId');
    return response.data;
  }

  /// Reorder - add items from a previous order to cart
  Future<List<CartItem>> getReorderItems(String orderId) async {
    final order = await getOrder(orderId);
    return order.items;
  }
}

/// Extension to add fromJson to Order model
extension OrderFromJson on Order {
  static Order fromJson(Map<String, dynamic> json) {
    // Parse status
    OrderStatus status = OrderStatus.pending;
    if (json['status'] != null) {
      final statusStr = json['status'].toString().toLowerCase();
      try {
        status = OrderStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == statusStr,
          orElse: () => OrderStatus.pending,
        );
      } catch (_) {
        status = OrderStatus.pending;
      }
    }

    // Parse items
    final itemsList = (json['items'] ?? []) as List;
    final items = itemsList.map((e) => _cartItemFromJson(e)).toList();

    // Parse shipping address
    final addressJson = json['shipping_address'] ?? {};
    final shippingAddress = ShippingAddress(
      id: addressJson['id']?.toString() ?? '',
      name: addressJson['name'] ?? addressJson['full_name'] ?? '',
      street:
          addressJson['street'] ??
          addressJson['address_line1'] ??
          addressJson['address'] ??
          '',
      city: addressJson['city'] ?? '',
      state: addressJson['state'] ?? '',
      zipCode:
          addressJson['zip_code'] ??
          addressJson['postal_code'] ??
          addressJson['zip'] ??
          '',
      country: addressJson['country'] ?? 'USA',
      phone: addressJson['phone'],
      isDefault: addressJson['is_default'] ?? false,
    );

    // Parse timeline
    final timelineList = (json['timeline'] ?? []) as List;
    final timeline = timelineList
        .map(
          (e) => OrderTimelineEvent(
            title: e['title'] ?? '',
            description: e['description'] ?? '',
            timestamp:
                DateTime.tryParse(e['timestamp'] ?? '') ?? DateTime.now(),
            status: OrderStatus.values.firstWhere(
              (s) =>
                  s.name.toLowerCase() ==
                  (e['status'] ?? '').toString().toLowerCase(),
              orElse: () => OrderStatus.pending,
            ),
            isCompleted: e['is_completed'] ?? false,
          ),
        )
        .toList();

    return Order(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number'] ?? json['order_id'] ?? '',
      items: items,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shippingCost: (json['shipping_cost'] ?? json['shipping'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      status: status,
      shippingAddress: shippingAddress,
      paymentMethod: json['payment_method'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.tryParse(json['estimated_delivery'])
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.tryParse(json['delivered_at'])
          : null,
      trackingNumber: json['tracking_number'],
      carrierName: json['carrier_name'] ?? json['carrier'],
      timeline: timeline,
      promoCode: json['promo_code'],
    );
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
