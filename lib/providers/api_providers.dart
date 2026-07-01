import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api/api_client.dart';
import '../services/api/services/auth_service.dart';
import '../services/api/services/product_service.dart';
import '../services/api/services/order_service.dart';
import '../services/api/services/cart_service.dart';
import '../services/api/services/wishlist_service.dart';
import 'notifiers/cart_notifier.dart';
import 'notifiers/auth_notifier.dart';
import 'state/cart_state.dart';

/// ============================================================
/// API Service Providers
/// Provides singleton instances of all API services for the app
/// ============================================================

/// API Client provider
/// The base HTTP client with authentication handling
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.instance;
});

/// Auth Service provider
/// Handles authentication operations (login, register, logout, etc.)
final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthService(client: client);
});

/// Product Service provider
/// Handles product catalog operations
final productServiceProvider = Provider<ProductService>((ref) {
  final client = ref.watch(apiClientProvider);
  return ProductService(client: client);
});

/// Order Service provider
/// Handles order management operations
final orderServiceProvider = Provider<OrderService>((ref) {
  final client = ref.watch(apiClientProvider);
  return OrderService(client: client);
});

/// Cart Service provider
/// Handles cart operations
final cartServiceProvider = Provider<CartService>((ref) {
  final client = ref.watch(apiClientProvider);
  return CartService(client: client);
});

/// Wishlist Service provider
/// Handles wishlist/favorites operations
final wishlistServiceProvider = Provider<WishlistService>((ref) {
  final client = ref.watch(apiClientProvider);
  return WishlistService(client: client);
});

/// ============================================================
/// API Configuration State
/// ============================================================

/// Whether to use the API or demo mode (defaults to true for production)
final useApiModeProvider = StateProvider<bool>((ref) => true);

/// API connection status
enum ApiConnectionStatus { connected, disconnected, checking, error }

/// API connection status provider
final apiConnectionStatusProvider = StateProvider<ApiConnectionStatus>((ref) {
  return ApiConnectionStatus.disconnected;
});

/// Check API connection
final apiHealthCheckProvider = FutureProvider<bool>((ref) async {
  final client = ref.watch(apiClientProvider);
  try {
    ref.read(apiConnectionStatusProvider.notifier).state =
        ApiConnectionStatus.checking;

    final isHealthy = await client.healthCheck();

    ref.read(apiConnectionStatusProvider.notifier).state = isHealthy
        ? ApiConnectionStatus.connected
        : ApiConnectionStatus.error;

    // Auto-enable API mode if connection is healthy
    if (isHealthy) {
      ref.read(useApiModeProvider.notifier).state = true;
    }

    return isHealthy;
  } catch (e) {
    ref.read(apiConnectionStatusProvider.notifier).state =
        ApiConnectionStatus.error;
    return false;
  }
});

/// ============================================================
/// Cart State Provider - with API service injection
/// ============================================================

/// Cart provider - Main state management for shopping cart
/// Injects CartService for API integration
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final cartService = ref.watch(cartServiceProvider);
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  return CartNotifier(cartService: isAuthenticated ? cartService : null);
});

/// Computed providers for specific cart values
final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.itemCount;
});

final cartSubtotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.subtotal;
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.total;
});

final cartDeliveryChargeProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.deliveryCharge;
});

/// ============================================================
/// Wishlist Providers (Placeholder)
/// ============================================================

/// Wishlist state
final wishlistProvider = StateProvider<List<String>>((ref) => []);

/// Add to wishlist
void addToWishlist(WidgetRef ref, String productId) {
  final current = ref.read(wishlistProvider);
  if (!current.contains(productId)) {
    ref.read(wishlistProvider.notifier).state = [...current, productId];
  }
}

/// Remove from wishlist
void removeFromWishlist(WidgetRef ref, String productId) {
  final current = ref.read(wishlistProvider);
  ref.read(wishlistProvider.notifier).state = current
      .where((id) => id != productId)
      .toList();
}

/// Check if in wishlist
bool isInWishlist(WidgetRef ref, String productId) {
  return ref.read(wishlistProvider).contains(productId);
}
