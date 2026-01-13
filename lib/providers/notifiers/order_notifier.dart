import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/order.dart';
import '../../models/cart_item.dart';
import '../../models/shipping_address.dart';
import '../../data/order_data.dart';
import '../../services/api/services/orders_api_service.dart';

/// Set to true to use real API, false for demo mode
const bool useOrderApiMode = false;

/// Order list state
class OrderListState {
  final List<Order> orders;
  final bool isLoading;
  final String? error;
  final OrderFilter filter;

  const OrderListState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
    this.filter = OrderFilter.all,
  });

  OrderListState copyWith({
    List<Order>? orders,
    bool? isLoading,
    String? error,
    OrderFilter? filter,
  }) {
    return OrderListState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filter: filter ?? this.filter,
    );
  }
}

/// Order filter options
enum OrderFilter { all, active, completed, cancelled }

/// Order notifier for managing orders
class OrderNotifier extends StateNotifier<OrderListState> {
  final OrdersApiService _ordersService;

  OrderNotifier({OrdersApiService? ordersService})
    : _ordersService = ordersService ?? OrdersApiService(),
      super(const OrderListState(isLoading: true)) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (useOrderApiMode) {
      try {
        final response = await _ordersService.getOrders();
        state = state.copyWith(orders: response.orders, isLoading: false);
      } catch (e) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load orders',
        );
      }
    } else {
      // Demo mode
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          state = state.copyWith(
            orders: OrderData.getOrders(),
            isLoading: false,
          );
        }
      });
    }
  }

  /// Filter orders
  void setFilter(OrderFilter filter) {
    state = state.copyWith(filter: filter);
  }

  /// Get filtered orders
  List<Order> get filteredOrders {
    switch (state.filter) {
      case OrderFilter.all:
        return state.orders;
      case OrderFilter.active:
        return state.orders
            .where(
              (o) =>
                  o.status != OrderStatus.delivered &&
                  o.status != OrderStatus.cancelled &&
                  o.status != OrderStatus.returned,
            )
            .toList();
      case OrderFilter.completed:
        return state.orders
            .where((o) => o.status == OrderStatus.delivered)
            .toList();
      case OrderFilter.cancelled:
        return state.orders
            .where(
              (o) =>
                  o.status == OrderStatus.cancelled ||
                  o.status == OrderStatus.returned,
            )
            .toList();
    }
  }

  /// Cancel an order
  Future<void> cancelOrder(String orderId) async {
    if (useOrderApiMode) {
      try {
        final cancelledOrder = await _ordersService.cancelOrder(orderId);
        final updatedOrders = state.orders.map((order) {
          if (order.id == orderId) return cancelledOrder;
          return order;
        }).toList();
        state = state.copyWith(orders: updatedOrders);
      } catch (e) {
        state = state.copyWith(error: 'Failed to cancel order');
      }
    } else {
      // Demo mode
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId && order.canCancel) {
          return order.copyWith(
            status: OrderStatus.cancelled,
            timeline: [
              ...order.timeline,
              OrderTimelineEvent(
                title: 'Order Cancelled',
                description: 'Order was cancelled by customer',
                timestamp: DateTime.now(),
                status: OrderStatus.cancelled,
                isCompleted: true,
              ),
            ],
          );
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
    }
  }

  /// Create a new order from cart items
  Future<Order> createOrder({
    required List<CartItem> items,
    required ShippingAddress shippingAddress,
    required String paymentMethod,
    required double subtotal,
    required double shippingCost,
    required double tax,
    double discount = 0,
    String? promoCode,
  }) async {
    if (useOrderApiMode) {
      try {
        final request = CreateOrderRequest(
          items: items,
          shippingAddress: shippingAddress,
          paymentMethodId: paymentMethod,
          promoCode: promoCode,
        );
        final newOrder = await _ordersService.createOrder(request);
        state = state.copyWith(orders: [newOrder, ...state.orders]);
        return newOrder;
      } catch (e) {
        // Fall through to demo mode if API fails
        rethrow;
      }
    }

    // Demo mode
    final orderNumber =
        'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final total = subtotal + shippingCost + tax - discount;
    final estimatedDelivery = DateTime.now().add(const Duration(days: 5));

    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNumber: orderNumber,
      items: items,
      subtotal: subtotal,
      shippingCost: shippingCost,
      tax: tax,
      discount: discount,
      total: total,
      status: OrderStatus.pending,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      estimatedDelivery: estimatedDelivery,
      promoCode: promoCode,
      timeline: [
        OrderTimelineEvent(
          title: 'Order Placed',
          description: 'Your order has been placed successfully',
          timestamp: DateTime.now(),
          status: OrderStatus.pending,
          isCompleted: true,
        ),
      ],
    );

    state = state.copyWith(orders: [newOrder, ...state.orders]);
    return newOrder;
  }

  /// Reorder - add items from an order to cart
  Future<List<CartItem>> getReorderItems(String orderId) async {
    if (useOrderApiMode) {
      try {
        return await _ordersService.getReorderItems(orderId);
      } catch (e) {
        // Fall through to local
      }
    }

    try {
      final order = state.orders.firstWhere((o) => o.id == orderId);
      return order.items;
    } catch (e) {
      return [];
    }
  }

  /// Refresh orders
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);

    if (useOrderApiMode) {
      try {
        final response = await _ordersService.getOrders();
        state = state.copyWith(orders: response.orders, isLoading: false);
        return;
      } catch (e) {
        // Fall through to demo data
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      state = state.copyWith(orders: OrderData.getOrders(), isLoading: false);
    }
  }
}

/// Order provider
final orderProvider = StateNotifierProvider<OrderNotifier, OrderListState>(
  (ref) => OrderNotifier(),
);

/// Single order provider for tracking
final singleOrderProvider = Provider.family<Order?, String>((ref, orderId) {
  final orderState = ref.watch(orderProvider);
  try {
    return orderState.orders.firstWhere((order) => order.id == orderId);
  } catch (e) {
    return null;
  }
});
