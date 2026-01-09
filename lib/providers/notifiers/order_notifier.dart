import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/order.dart';
import '../../data/order_data.dart';

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
  OrderNotifier() : super(const OrderListState(isLoading: true)) {
    _loadOrders();
  }

  void _loadOrders() {
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        state = state.copyWith(orders: OrderData.getOrders(), isLoading: false);
      }
    });
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
  void cancelOrder(String orderId) {
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

  /// Refresh orders
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
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
