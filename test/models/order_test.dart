import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/models/cart_item.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/models/shipping_address.dart';

void main() {
  const testProduct = Product(
    id: 'order-test-1',
    name: 'Test Product',
    price: 100.0,
    imageUrl: 'https://example.com/product.jpg',
    description: 'Test product for order testing',
    availableColors: ['Black'],
    availableSizes: [42],
    brand: 'TestBrand',
    category: ProductCategory.footwear,
  );

  const testCartItem = CartItem(
    product: testProduct,
    quantity: 2,
    selectedColor: 'Black',
    selectedSize: 42,
  );

  const testAddress = ShippingAddress(
    id: 'addr-1',
    name: 'John Doe',
    street: '123 Main St',
    city: 'New York',
    state: 'NY',
    zipCode: '10001',
    country: 'USA',
    isDefault: true,
  );

  group('OrderStatus', () {
    test('should have all expected statuses', () {
      expect(OrderStatus.values, contains(OrderStatus.pending));
      expect(OrderStatus.values, contains(OrderStatus.confirmed));
      expect(OrderStatus.values, contains(OrderStatus.processing));
      expect(OrderStatus.values, contains(OrderStatus.shipped));
      expect(OrderStatus.values, contains(OrderStatus.outForDelivery));
      expect(OrderStatus.values, contains(OrderStatus.delivered));
      expect(OrderStatus.values, contains(OrderStatus.cancelled));
      expect(OrderStatus.values, contains(OrderStatus.returned));
    });
  });

  group('OrderTimelineEvent', () {
    test('should create timeline event with required fields', () {
      final event = OrderTimelineEvent(
        title: 'Order Placed',
        description: 'Your order has been placed successfully',
        timestamp: DateTime(2025, 1, 10, 14, 30),
        status: OrderStatus.pending,
        isCompleted: true,
      );

      expect(event.title, 'Order Placed');
      expect(event.description, 'Your order has been placed successfully');
      expect(event.status, OrderStatus.pending);
      expect(event.isCompleted, true);
    });

    test('should default isCompleted to false', () {
      final event = OrderTimelineEvent(
        title: 'Processing',
        description: 'Order is being processed',
        timestamp: DateTime.now(),
        status: OrderStatus.processing,
      );

      expect(event.isCompleted, false);
    });
  });

  group('Order Model', () {
    late Order testOrder;

    setUp(() {
      testOrder = Order(
        id: 'order-1',
        orderNumber: 'ORD-2025-001',
        items: const [testCartItem],
        subtotal: 200.0,
        shippingCost: 10.0,
        tax: 18.0,
        discount: 20.0,
        total: 208.0,
        status: OrderStatus.processing,
        shippingAddress: testAddress,
        paymentMethod: 'Credit Card',
        createdAt: DateTime(2025, 1, 10),
        estimatedDelivery: DateTime(2025, 1, 15),
        trackingNumber: 'TRK123456789',
        carrierName: 'FedEx',
      );
    });

    test('should create order with required fields', () {
      expect(testOrder.id, 'order-1');
      expect(testOrder.orderNumber, 'ORD-2025-001');
      expect(testOrder.items.length, 1);
      expect(testOrder.subtotal, 200.0);
      expect(testOrder.total, 208.0);
      expect(testOrder.status, OrderStatus.processing);
    });

    test('should calculate item count correctly', () {
      expect(testOrder.itemCount, 2); // quantity of 2
    });

    test('should calculate item count with multiple items', () {
      const anotherCartItem = CartItem(
        product: testProduct,
        quantity: 3,
        selectedColor: 'Black',
        selectedSize: 41,
      );

      final orderWithMultipleItems = testOrder.copyWith(
        items: [testCartItem, anotherCartItem],
      );

      expect(orderWithMultipleItems.itemCount, 5); // 2 + 3
    });
  });

  group('Order Status Display Names', () {
    test('should return correct display name for pending', () {
      final order = Order(
        id: '1',
        orderNumber: 'ORD-1',
        items: const [testCartItem],
        subtotal: 100.0,
        shippingCost: 10.0,
        tax: 10.0,
        total: 120.0,
        status: OrderStatus.pending,
        shippingAddress: testAddress,
        paymentMethod: 'Credit Card',
        createdAt: DateTime.now(),
      );

      expect(order.statusDisplayName, 'Pending');
    });

    test('should return correct display names for all statuses', () {
      final statusDisplayNames = {
        OrderStatus.pending: 'Pending',
        OrderStatus.confirmed: 'Confirmed',
        OrderStatus.processing: 'Processing',
        OrderStatus.shipped: 'Shipped',
        OrderStatus.outForDelivery: 'Out for Delivery',
        OrderStatus.delivered: 'Delivered',
        OrderStatus.cancelled: 'Cancelled',
        OrderStatus.returned: 'Returned',
      };

      for (final entry in statusDisplayNames.entries) {
        final order = Order(
          id: '1',
          orderNumber: 'ORD-1',
          items: const [testCartItem],
          subtotal: 100.0,
          shippingCost: 10.0,
          tax: 10.0,
          total: 120.0,
          status: entry.key,
          shippingAddress: testAddress,
          paymentMethod: 'Credit Card',
          createdAt: DateTime.now(),
        );

        expect(
          order.statusDisplayName,
          entry.value,
          reason: 'Status ${entry.key} should display as ${entry.value}',
        );
      }
    });
  });

  group('Order canCancel', () {
    test('should be true for pending orders', () {
      final order = Order(
        id: '1',
        orderNumber: 'ORD-1',
        items: const [testCartItem],
        subtotal: 100.0,
        shippingCost: 10.0,
        tax: 10.0,
        total: 120.0,
        status: OrderStatus.pending,
        shippingAddress: testAddress,
        paymentMethod: 'Credit Card',
        createdAt: DateTime.now(),
      );

      expect(order.canCancel, isTrue);
    });

    test('should be true for confirmed orders', () {
      final order = Order(
        id: '1',
        orderNumber: 'ORD-1',
        items: const [testCartItem],
        subtotal: 100.0,
        shippingCost: 10.0,
        tax: 10.0,
        total: 120.0,
        status: OrderStatus.confirmed,
        shippingAddress: testAddress,
        paymentMethod: 'Credit Card',
        createdAt: DateTime.now(),
      );

      expect(order.canCancel, isTrue);
    });

    test('should be false for shipped orders', () {
      final order = Order(
        id: '1',
        orderNumber: 'ORD-1',
        items: const [testCartItem],
        subtotal: 100.0,
        shippingCost: 10.0,
        tax: 10.0,
        total: 120.0,
        status: OrderStatus.shipped,
        shippingAddress: testAddress,
        paymentMethod: 'Credit Card',
        createdAt: DateTime.now(),
      );

      expect(order.canCancel, isFalse);
    });

    test('should be false for delivered orders', () {
      final order = Order(
        id: '1',
        orderNumber: 'ORD-1',
        items: const [testCartItem],
        subtotal: 100.0,
        shippingCost: 10.0,
        tax: 10.0,
        total: 120.0,
        status: OrderStatus.delivered,
        shippingAddress: testAddress,
        paymentMethod: 'Credit Card',
        createdAt: DateTime.now(),
      );

      expect(order.canCancel, isFalse);
    });
  });

  group('Order canTrack', () {
    test('should be true for shipped orders', () {
      final order = Order(
        id: '1',
        orderNumber: 'ORD-1',
        items: const [testCartItem],
        subtotal: 100.0,
        shippingCost: 10.0,
        tax: 10.0,
        total: 120.0,
        status: OrderStatus.shipped,
        shippingAddress: testAddress,
        paymentMethod: 'Credit Card',
        createdAt: DateTime.now(),
      );

      expect(order.canTrack, isTrue);
    });

    test('should be true for out for delivery orders', () {
      final order = Order(
        id: '1',
        orderNumber: 'ORD-1',
        items: const [testCartItem],
        subtotal: 100.0,
        shippingCost: 10.0,
        tax: 10.0,
        total: 120.0,
        status: OrderStatus.outForDelivery,
        shippingAddress: testAddress,
        paymentMethod: 'Credit Card',
        createdAt: DateTime.now(),
      );

      expect(order.canTrack, isTrue);
    });

    test('should be true for delivered orders', () {
      final order = Order(
        id: '1',
        orderNumber: 'ORD-1',
        items: const [testCartItem],
        subtotal: 100.0,
        shippingCost: 10.0,
        tax: 10.0,
        total: 120.0,
        status: OrderStatus.delivered,
        shippingAddress: testAddress,
        paymentMethod: 'Credit Card',
        createdAt: DateTime.now(),
      );

      expect(order.canTrack, isTrue);
    });

    test('should be false for pending orders', () {
      final order = Order(
        id: '1',
        orderNumber: 'ORD-1',
        items: const [testCartItem],
        subtotal: 100.0,
        shippingCost: 10.0,
        tax: 10.0,
        total: 120.0,
        status: OrderStatus.pending,
        shippingAddress: testAddress,
        paymentMethod: 'Credit Card',
        createdAt: DateTime.now(),
      );

      expect(order.canTrack, isFalse);
    });
  });

  group('ShippingAddress Model', () {
    test('should create address with required fields', () {
      expect(testAddress.id, 'addr-1');
      expect(testAddress.name, 'John Doe');
      expect(testAddress.street, '123 Main St');
      expect(testAddress.city, 'New York');
      expect(testAddress.state, 'NY');
      expect(testAddress.zipCode, '10001');
      expect(testAddress.country, 'USA');
    });

    test('should format full address correctly', () {
      expect(testAddress.fullAddress, '123 Main St, New York, NY 10001');
    });

    test('copyWith should update specified fields', () {
      final updatedAddress = testAddress.copyWith(
        street: '456 Oak Ave',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '90001',
      );

      expect(updatedAddress.street, '456 Oak Ave');
      expect(updatedAddress.city, 'Los Angeles');
      expect(updatedAddress.state, 'CA');
      expect(updatedAddress.zipCode, '90001');
      // Unchanged fields
      expect(updatedAddress.name, testAddress.name);
      expect(updatedAddress.country, testAddress.country);
    });

    test('should default isDefault to false', () {
      const address = ShippingAddress(
        id: 'addr-2',
        name: 'Jane Doe',
        street: '789 Pine St',
        city: 'Chicago',
        state: 'IL',
        zipCode: '60601',
        country: 'USA',
      );

      expect(address.isDefault, false);
    });
  });
}
