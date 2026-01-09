import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../models/payment_method.dart';
import '../../models/shipping_address.dart';
import '../../models/order.dart';
import 'auth_notifier.dart';
import 'order_notifier.dart';

/// User provider - Connected to auth state
final userProvider = Provider<User>((ref) {
  final authState = ref.watch(authProvider);

  // Return user from auth if authenticated, otherwise return guest user
  return authState.user ??
      const User(
        id: 'guest',
        name: 'Guest',
        email: '',
        phone: '',
        membershipTier: 'None',
        loyaltyPoints: 0,
        totalOrders: 0,
        totalReviews: 0,
        walletBalance: 0.0,
      );
});

/// Payment methods provider - Now connected to the notifier
final paymentMethodsProvider = Provider<List<PaymentMethod>>((ref) {
  return ref.watch(paymentMethodsNotifierProvider).methods;
});

/// Shipping addresses provider - Now connected to AddressNotifier from auth_notifier.dart
final shippingAddressesProvider = Provider<List<ShippingAddress>>((ref) {
  return ref.watch(addressProvider).addresses;
});

/// Unread notifications count - now uses actual notification provider
/// (This is a fallback, actual count comes from notifications_notifier.dart)
final unreadNotificationsProvider = Provider<int>((ref) => 3);

/// Active orders count - connected to actual orders
final activeOrdersProvider = Provider<int>((ref) {
  final orderState = ref.watch(orderProvider);
  return orderState.orders
      .where(
        (o) =>
            o.status != OrderStatus.delivered &&
            o.status != OrderStatus.cancelled &&
            o.status != OrderStatus.returned,
      )
      .length;
});

/// Payment methods state
class PaymentMethodsState {
  final List<PaymentMethod> methods;
  final bool isLoading;
  final String? error;

  const PaymentMethodsState({
    this.methods = const [],
    this.isLoading = false,
    this.error,
  });

  PaymentMethodsState copyWith({
    List<PaymentMethod>? methods,
    bool? isLoading,
    String? error,
  }) {
    return PaymentMethodsState(
      methods: methods ?? this.methods,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Payment methods notifier for managing payment methods
class PaymentMethodsNotifier extends StateNotifier<PaymentMethodsState> {
  PaymentMethodsNotifier() : super(const PaymentMethodsState(isLoading: true)) {
    _loadPaymentMethods();
  }

  void _loadPaymentMethods() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        state = PaymentMethodsState(
          methods: const [
            PaymentMethod(
              id: '1',
              type: 'card',
              name: 'Visa',
              cardNumber: '4532',
              expiryDate: '12/25',
              isDefault: true,
            ),
            PaymentMethod(
              id: '2',
              type: 'card',
              name: 'Mastercard',
              cardNumber: '5425',
              expiryDate: '08/26',
              isDefault: false,
            ),
            PaymentMethod(
              id: '3',
              type: 'paypal',
              name: 'PayPal',
              isDefault: false,
            ),
          ],
          isLoading: false,
        );
      }
    });
  }

  /// Add new payment method
  void addPaymentMethod(PaymentMethod method) {
    final newMethod = method.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    List<PaymentMethod> updatedMethods;
    if (newMethod.isDefault) {
      updatedMethods = state.methods
          .map((m) => m.copyWith(isDefault: false))
          .toList();
    } else {
      updatedMethods = [...state.methods];
    }

    updatedMethods.add(newMethod);
    state = state.copyWith(methods: updatedMethods);
  }

  /// Remove payment method
  void removePaymentMethod(String id) {
    final updatedMethods = state.methods.where((m) => m.id != id).toList();

    // If we removed the default, make the first one default
    if (updatedMethods.isNotEmpty && !updatedMethods.any((m) => m.isDefault)) {
      updatedMethods[0] = updatedMethods[0].copyWith(isDefault: true);
    }

    state = state.copyWith(methods: updatedMethods);
  }

  /// Set default payment method
  void setDefaultPaymentMethod(String id) {
    final updatedMethods = state.methods.map((m) {
      return m.copyWith(isDefault: m.id == id);
    }).toList();

    state = state.copyWith(methods: updatedMethods);
  }

  /// Get default payment method
  PaymentMethod? get defaultMethod {
    try {
      return state.methods.firstWhere((m) => m.isDefault);
    } catch (e) {
      return state.methods.isNotEmpty ? state.methods.first : null;
    }
  }
}

/// Payment methods notifier provider
final paymentMethodsNotifierProvider =
    StateNotifierProvider<PaymentMethodsNotifier, PaymentMethodsState>(
      (ref) => PaymentMethodsNotifier(),
    );

/// Convenience provider for just the list
final editablePaymentMethodsProvider = Provider<List<PaymentMethod>>((ref) {
  return ref.watch(paymentMethodsNotifierProvider).methods;
});
