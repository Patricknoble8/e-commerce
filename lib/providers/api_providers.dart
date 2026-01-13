import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api/api_client.dart';
import '../services/api/services/auth_api_service.dart';
import '../services/api/services/products_api_service.dart';
import '../services/api/services/orders_api_service.dart';
import '../services/api/services/cart_api_service.dart';
import '../services/api/services/wishlist_api_service.dart';
import '../services/api/services/addresses_api_service.dart';

/// Provider for the shared API client instance
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Provider for Auth API Service
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthApiService(client: client);
});

/// Provider for Products API Service
final productsApiServiceProvider = Provider<ProductsApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return ProductsApiService(client: client);
});

/// Provider for Orders API Service
final ordersApiServiceProvider = Provider<OrdersApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return OrdersApiService(client: client);
});

/// Provider for Cart API Service
final cartApiServiceProvider = Provider<CartApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return CartApiService(client: client);
});

/// Provider for Wishlist API Service
final wishlistApiServiceProvider = Provider<WishlistApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return WishlistApiService(client: client);
});

/// Provider for Addresses API Service
final addressesApiServiceProvider = Provider<AddressesApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return AddressesApiService(client: client);
});

/// Provider to check authentication status
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final client = ref.watch(apiClientProvider);
  return await client.isAuthenticated();
});
