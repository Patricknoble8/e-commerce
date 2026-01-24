import '../api_client.dart';
import '../api_config.dart';
import '../../../models/order.dart';
import '../../../models/cart_item.dart';
import '../../../models/shipping_address.dart';

/// Order API Service
/// Handles order creation, listing, tracking, and management
class OrderService {
  final ApiClient _client;

  OrderService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  // ============ Order Listing ============

  /// Get all user orders with pagination
  Future<OrderListResponse> getOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    final response = await _client.get(
      ApiConfig.orders,
      queryParams: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.name,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
      },
    );

    return OrderListResponse.fromJson(response.dataAsMap);
  }

  /// Get single order by ID
  Future<Order> getOrderById(String orderId) async {
    final response = await _client.get(ApiConfig.orderById(orderId));
    return Order.fromJson(response.dataAsMap);
  }

  /// Get order by order number
  Future<Order> getOrderByNumber(String orderNumber) async {
    final response = await _client.get(
      ApiConfig.orders,
      queryParams: {'orderNumber': orderNumber},
    );
    final orders =
        (response.dataAsMap['orders'] ?? response.dataAsList) as List;
    if (orders.isEmpty) {
      throw Exception('Order not found');
    }
    return Order.fromJson(orders.first);
  }

  // ============ Order Creation ============

  /// Create a new order
  Future<Order> createOrder({
    required List<CartItem> items,
    required ShippingAddress shippingAddress,
    required String paymentMethodId,
    String? promoCode,
    String? notes,
  }) async {
    final response = await _client.post(
      ApiConfig.createOrder,
      body: {
        'items': items
            .map(
              (item) => {
                'productId': item.productId,
                'quantity': item.quantity,
                'size': item.size,
                'color': item.color,
                'price': item.price,
              },
            )
            .toList(),
        'shippingAddress': shippingAddress.toJson(),
        'paymentMethodId': paymentMethodId,
        if (promoCode != null) 'promoCode': promoCode,
        if (notes != null) 'notes': notes,
      },
    );

    return Order.fromJson(response.dataAsMap);
  }

  // ============ Order Actions ============

  /// Cancel an order
  Future<Order> cancelOrder(String orderId, {String? reason}) async {
    final response = await _client.post(
      ApiConfig.cancelOrder(orderId),
      body: {if (reason != null) 'reason': reason},
    );
    return Order.fromJson(response.dataAsMap);
  }

  /// Track order (get tracking info)
  Future<OrderTracking> trackOrder(String orderId) async {
    final response = await _client.get(ApiConfig.trackOrder(orderId));
    return OrderTracking.fromJson(response.dataAsMap);
  }

  /// Get items for reorder
  Future<List<CartItem>> getReorderItems(String orderId) async {
    final response = await _client.get(ApiConfig.reorder(orderId));
    return (response.dataAsList)
        .map((json) => CartItem.fromJson(json))
        .toList();
  }

  // ============ Order Stats ============

  /// Get order statistics for user
  Future<OrderStats> getOrderStats() async {
    final response = await _client.get('${ApiConfig.orders}/stats');
    return OrderStats.fromJson(response.dataAsMap);
  }
}

/// Order list response with pagination
class OrderListResponse {
  final List<Order> orders;
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasMore;

  OrderListResponse({
    required this.orders,
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasMore,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    final items = json['orders'] ?? json['items'] ?? [];
    final pagination = json['pagination'] ?? json;

    return OrderListResponse(
      orders: (items as List).map((o) => Order.fromJson(o)).toList(),
      page: pagination['page'] ?? pagination['currentPage'] ?? 1,
      limit: pagination['limit'] ?? pagination['perPage'] ?? 20,
      totalItems:
          pagination['totalItems'] ?? pagination['total'] ?? items.length,
      totalPages: pagination['totalPages'] ?? pagination['lastPage'] ?? 1,
      hasMore:
          pagination['hasMore'] ??
          (pagination['page'] ?? 1) < (pagination['totalPages'] ?? 1),
    );
  }
}

/// Order tracking information
class OrderTracking {
  final String orderId;
  final String orderNumber;
  final OrderStatus status;
  final String? trackingNumber;
  final String? carrier;
  final String? trackingUrl;
  final DateTime? estimatedDelivery;
  final List<TrackingEvent> events;

  OrderTracking({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    this.trackingNumber,
    this.carrier,
    this.trackingUrl,
    this.estimatedDelivery,
    this.events = const [],
  });

  factory OrderTracking.fromJson(Map<String, dynamic> json) {
    return OrderTracking(
      orderId: json['orderId']?.toString() ?? json['_id']?.toString() ?? '',
      orderNumber: json['orderNumber'] ?? '',
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      trackingNumber: json['trackingNumber'],
      carrier: json['carrier'],
      trackingUrl: json['trackingUrl'],
      estimatedDelivery: json['estimatedDelivery'] != null
          ? DateTime.parse(json['estimatedDelivery'])
          : null,
      events: json['events'] != null
          ? (json['events'] as List)
                .map((e) => TrackingEvent.fromJson(e))
                .toList()
          : [],
    );
  }
}

/// Tracking event
class TrackingEvent {
  final String title;
  final String? description;
  final String? location;
  final DateTime timestamp;

  TrackingEvent({
    required this.title,
    this.description,
    this.location,
    required this.timestamp,
  });

  factory TrackingEvent.fromJson(Map<String, dynamic> json) {
    return TrackingEvent(
      title: json['title'] ?? json['status'] ?? '',
      description: json['description'] ?? json['message'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp'] ?? json['date']),
    );
  }
}

/// Order statistics
class OrderStats {
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final int cancelledOrders;
  final double totalSpent;

  OrderStats({
    required this.totalOrders,
    required this.pendingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.totalSpent,
  });

  factory OrderStats.fromJson(Map<String, dynamic> json) {
    return OrderStats(
      totalOrders: json['totalOrders'] ?? json['total'] ?? 0,
      pendingOrders: json['pendingOrders'] ?? json['pending'] ?? 0,
      completedOrders: json['completedOrders'] ?? json['completed'] ?? 0,
      cancelledOrders: json['cancelledOrders'] ?? json['cancelled'] ?? 0,
      totalSpent: (json['totalSpent'] ?? json['spent'] ?? 0).toDouble(),
    );
  }
}
