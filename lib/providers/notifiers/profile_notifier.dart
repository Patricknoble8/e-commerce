import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../models/payment_method.dart';
import '../../models/shipping_address.dart';

/// User provider - Demo data
final userProvider = Provider<User>((ref) {
  return const User(
    id: '1',
    name: 'Olivia',
    email: 'oliva@gmail.com',
    phone: '+1 234 567 8900',
    membershipTier: 'Gold',
    loyaltyPoints: 2450,
    totalOrders: 12,
    totalReviews: 8,
    walletBalance: 45.50,
  );
});

/// Payment methods provider - Demo data
final paymentMethodsProvider = Provider<List<PaymentMethod>>((ref) {
  return const [
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
  ];
});

/// Shipping addresses provider - Demo data
final shippingAddressesProvider = Provider<List<ShippingAddress>>((ref) {
  return const [
    ShippingAddress(
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
    ShippingAddress(
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
  ];
});

/// Unread notifications count
final unreadNotificationsProvider = Provider<int>((ref) => 3);

/// Active orders count
final activeOrdersProvider = Provider<int>((ref) => 2);
