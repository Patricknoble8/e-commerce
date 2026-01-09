import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/shipping_address.dart';
import 'product_data.dart';

/// Demo order data for the e-commerce app
class OrderData {
  static List<Order> getOrders() {
    final now = DateTime.now();
    final products = ProductData.products;

    return [
      // Delivered order
      Order(
        id: '1',
        orderNumber: 'ORD-2024-001',
        items: [
          CartItem(
            product: products[0], // iPhone
            quantity: 1,
            selectedColor: 'Natural Titanium',
            selectedSize: 256,
          ),
          CartItem(
            product: products[4], // Sony Headphones
            quantity: 1,
            selectedColor: 'Black',
            selectedSize: 1,
          ),
        ],
        subtotal: 1598.00,
        shippingCost: 0,
        tax: 127.84,
        discount: 0,
        total: 1725.84,
        status: OrderStatus.delivered,
        shippingAddress: const ShippingAddress(
          id: '1',
          name: 'Home',
          street: '123 Main Street',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
          phone: '+1 234 567 8900',
          isDefault: true,
        ),
        paymentMethod: 'Visa •••• 4532',
        createdAt: now.subtract(const Duration(days: 7)),
        estimatedDelivery: now.subtract(const Duration(days: 2)),
        deliveredAt: now.subtract(const Duration(days: 2)),
        trackingNumber: 'TRK1234567890',
        carrierName: 'FedEx',
        timeline: [
          OrderTimelineEvent(
            title: 'Order Placed',
            description: 'Your order has been placed successfully',
            timestamp: now.subtract(const Duration(days: 7)),
            status: OrderStatus.pending,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Order Confirmed',
            description: 'Your order has been confirmed',
            timestamp: now.subtract(const Duration(days: 7, hours: -2)),
            status: OrderStatus.confirmed,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Processing',
            description: 'Your order is being prepared',
            timestamp: now.subtract(const Duration(days: 6)),
            status: OrderStatus.processing,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Shipped',
            description: 'Your order has been shipped',
            timestamp: now.subtract(const Duration(days: 5)),
            status: OrderStatus.shipped,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Out for Delivery',
            description: 'Your order is out for delivery',
            timestamp: now.subtract(const Duration(days: 2, hours: 4)),
            status: OrderStatus.outForDelivery,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Delivered',
            description: 'Your order has been delivered',
            timestamp: now.subtract(const Duration(days: 2)),
            status: OrderStatus.delivered,
            isCompleted: true,
          ),
        ],
      ),

      // Shipped order (in transit)
      Order(
        id: '2',
        orderNumber: 'ORD-2024-002',
        items: [
          CartItem(
            product: products[2], // MacBook
            quantity: 1,
            selectedColor: 'Space Black',
            selectedSize: 512,
          ),
        ],
        subtotal: 3499.00,
        shippingCost: 0,
        tax: 279.92,
        discount: 100,
        total: 3678.92,
        status: OrderStatus.shipped,
        shippingAddress: const ShippingAddress(
          id: '2',
          name: 'Office',
          street: '456 Business Ave',
          city: 'New York',
          state: 'NY',
          zipCode: '10002',
          country: 'USA',
          phone: '+1 234 567 8901',
          isDefault: false,
        ),
        paymentMethod: 'Mastercard •••• 5425',
        createdAt: now.subtract(const Duration(days: 3)),
        estimatedDelivery: now.add(const Duration(days: 2)),
        trackingNumber: 'TRK0987654321',
        carrierName: 'UPS',
        promoCode: 'SAVE100',
        timeline: [
          OrderTimelineEvent(
            title: 'Order Placed',
            description: 'Your order has been placed successfully',
            timestamp: now.subtract(const Duration(days: 3)),
            status: OrderStatus.pending,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Order Confirmed',
            description: 'Your order has been confirmed',
            timestamp: now.subtract(const Duration(days: 3, hours: -1)),
            status: OrderStatus.confirmed,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Processing',
            description: 'Your order is being prepared',
            timestamp: now.subtract(const Duration(days: 2)),
            status: OrderStatus.processing,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Shipped',
            description: 'Your order has been shipped',
            timestamp: now.subtract(const Duration(days: 1)),
            status: OrderStatus.shipped,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Out for Delivery',
            description: 'Estimated arrival in 2 days',
            timestamp: now.add(const Duration(days: 1)),
            status: OrderStatus.outForDelivery,
            isCompleted: false,
          ),
          OrderTimelineEvent(
            title: 'Delivered',
            description: 'Package will be delivered',
            timestamp: now.add(const Duration(days: 2)),
            status: OrderStatus.delivered,
            isCompleted: false,
          ),
        ],
      ),

      // Processing order
      Order(
        id: '3',
        orderNumber: 'ORD-2024-003',
        items: [
          CartItem(
            product: products[1], // Samsung Galaxy
            quantity: 1,
            selectedColor: 'Titanium Gray',
            selectedSize: 256,
          ),
          CartItem(
            product: products[5], // AirPods
            quantity: 2,
            selectedColor: 'White',
            selectedSize: 1,
          ),
        ],
        subtotal: 1601.30,
        shippingCost: 9.99,
        tax: 128.10,
        discount: 0,
        total: 1739.39,
        status: OrderStatus.processing,
        shippingAddress: const ShippingAddress(
          id: '1',
          name: 'Home',
          street: '123 Main Street',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
          phone: '+1 234 567 8900',
          isDefault: true,
        ),
        paymentMethod: 'PayPal',
        createdAt: now.subtract(const Duration(hours: 8)),
        estimatedDelivery: now.add(const Duration(days: 5)),
        timeline: [
          OrderTimelineEvent(
            title: 'Order Placed',
            description: 'Your order has been placed successfully',
            timestamp: now.subtract(const Duration(hours: 8)),
            status: OrderStatus.pending,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Order Confirmed',
            description: 'Your order has been confirmed',
            timestamp: now.subtract(const Duration(hours: 7)),
            status: OrderStatus.confirmed,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Processing',
            description: 'Your order is being prepared',
            timestamp: now.subtract(const Duration(hours: 4)),
            status: OrderStatus.processing,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Shipped',
            description: 'Preparing for shipment',
            timestamp: now.add(const Duration(days: 1)),
            status: OrderStatus.shipped,
            isCompleted: false,
          ),
          OrderTimelineEvent(
            title: 'Out for Delivery',
            description: 'Estimated arrival in 5 days',
            timestamp: now.add(const Duration(days: 4)),
            status: OrderStatus.outForDelivery,
            isCompleted: false,
          ),
          OrderTimelineEvent(
            title: 'Delivered',
            description: 'Package will be delivered',
            timestamp: now.add(const Duration(days: 5)),
            status: OrderStatus.delivered,
            isCompleted: false,
          ),
        ],
      ),

      // Cancelled order
      Order(
        id: '4',
        orderNumber: 'ORD-2024-004',
        items: [
          CartItem(
            product: products[3], // Dell XPS
            quantity: 1,
            selectedColor: 'Platinum Silver',
            selectedSize: 512,
          ),
        ],
        subtotal: 1519.20,
        shippingCost: 0,
        tax: 121.54,
        discount: 0,
        total: 1640.74,
        status: OrderStatus.cancelled,
        shippingAddress: const ShippingAddress(
          id: '1',
          name: 'Home',
          street: '123 Main Street',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
          phone: '+1 234 567 8900',
          isDefault: true,
        ),
        paymentMethod: 'Visa •••• 4532',
        createdAt: now.subtract(const Duration(days: 14)),
        timeline: [
          OrderTimelineEvent(
            title: 'Order Placed',
            description: 'Your order has been placed successfully',
            timestamp: now.subtract(const Duration(days: 14)),
            status: OrderStatus.pending,
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Order Cancelled',
            description: 'Order was cancelled by customer',
            timestamp: now.subtract(const Duration(days: 14, hours: -3)),
            status: OrderStatus.cancelled,
            isCompleted: true,
          ),
        ],
      ),
    ];
  }

  /// Get order by ID
  static Order? getOrderById(String id) {
    try {
      return getOrders().firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get active orders (not delivered or cancelled)
  static List<Order> getActiveOrders() {
    return getOrders()
        .where(
          (order) =>
              order.status != OrderStatus.delivered &&
              order.status != OrderStatus.cancelled &&
              order.status != OrderStatus.returned,
        )
        .toList();
  }

  /// Get completed orders
  static List<Order> getCompletedOrders() {
    return getOrders()
        .where((order) => order.status == OrderStatus.delivered)
        .toList();
  }
}
