import 'cart_item.dart';
import 'shipping_address.dart';

/// Order status enum
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned,
}

/// Order timeline event
class OrderTimelineEvent {
  final String title;
  final String description;
  final DateTime timestamp;
  final OrderStatus status;
  final bool isCompleted;

  const OrderTimelineEvent({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.status,
    this.isCompleted = false,
  });
}

/// Order model
class Order {
  final String id;
  final String orderNumber;
  final List<CartItem> items;
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double discount;
  final double total;
  final OrderStatus status;
  final ShippingAddress shippingAddress;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;
  final DateTime? deliveredAt;
  final String? trackingNumber;
  final String? carrierName;
  final List<OrderTimelineEvent> timeline;
  final String? promoCode;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    this.discount = 0,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.createdAt,
    this.estimatedDelivery,
    this.deliveredAt,
    this.trackingNumber,
    this.carrierName,
    this.timeline = const [],
    this.promoCode,
  });

  /// Get the number of items in this order
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get status display name
  String get statusDisplayName {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  /// Check if order can be cancelled
  bool get canCancel =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  /// Check if order can be tracked
  bool get canTrack =>
      status == OrderStatus.shipped ||
      status == OrderStatus.outForDelivery ||
      status == OrderStatus.delivered;

  /// Copy with method
  Order copyWith({
    String? id,
    String? orderNumber,
    List<CartItem>? items,
    double? subtotal,
    double? shippingCost,
    double? tax,
    double? discount,
    double? total,
    OrderStatus? status,
    ShippingAddress? shippingAddress,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? estimatedDelivery,
    DateTime? deliveredAt,
    String? trackingNumber,
    String? carrierName,
    List<OrderTimelineEvent>? timeline,
    String? promoCode,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      carrierName: carrierName ?? this.carrierName,
      timeline: timeline ?? this.timeline,
      promoCode: promoCode ?? this.promoCode,
    );
  }
}
