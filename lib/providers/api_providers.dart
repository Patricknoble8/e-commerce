import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api/api_client.dart';
import '../services/api/services/auth_service.dart';
import '../services/api/services/product_service.dart';
import '../services/api/services/order_service.dart';
import '../services/api/services/cart_service.dart';
import '../services/api/services/wishlist_service.dart';

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

/// Whether to use the API or demo mode
final useApiModeProvider = StateProvider<bool>((ref) => false);

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
/// Cart State Providers
/// ============================================================

/// Cart state
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final cartService = ref.watch(cartServiceProvider);
  final useApi = ref.watch(useApiModeProvider);
  return CartNotifier(cartService: cartService, useApi: useApi);
});

/// Cart state model
class CartState {
  final Cart? cart;
  final bool isLoading;
  final String? error;
  final bool isApplyingCoupon;

  CartState({
    this.cart,
    this.isLoading = false,
    this.error,
    this.isApplyingCoupon = false,
  });

  CartState copyWith({
    Cart? cart,
    bool? isLoading,
    String? error,
    bool? isApplyingCoupon,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isApplyingCoupon: isApplyingCoupon ?? this.isApplyingCoupon,
    );
  }

  int get itemCount => cart?.itemCount ?? 0;
  double get total => cart?.total ?? 0;
  bool get isEmpty => cart?.isEmpty ?? true;
}

/// Cart state notifier
class CartNotifier extends StateNotifier<CartState> {
  final CartService _cartService;
  final bool _useApi;

  CartNotifier({required CartService cartService, required bool useApi})
    : _cartService = cartService,
      _useApi = useApi,
      super(CartState());

  /// Load cart from API
  Future<void> loadCart() async {
    if (!_useApi) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _cartService.getCart();
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Add item to cart
  Future<void> addToCart({
    required String productId,
    required int quantity,
    String? size,
    String? color,
  }) async {
    if (!_useApi) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _cartService.addToCart(
        productId: productId,
        quantity: quantity,
        size: size,
        color: color,
      );
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Update cart item quantity
  Future<void> updateQuantity(String itemId, int quantity) async {
    if (!_useApi) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _cartService.updateCartItem(
        itemId: itemId,
        quantity: quantity,
      );
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Remove item from cart
  Future<void> removeItem(String itemId) async {
    if (!_useApi) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _cartService.removeFromCart(itemId);
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    if (!_useApi) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.clearCart();
      state = CartState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Apply coupon code
  Future<bool> applyCoupon(String code) async {
    if (!_useApi) return false;

    state = state.copyWith(isApplyingCoupon: true, error: null);
    try {
      final result = await _cartService.applyCoupon(code);
      if (result.valid && result.updatedCart != null) {
        state = state.copyWith(
          cart: result.updatedCart,
          isApplyingCoupon: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isApplyingCoupon: false,
          error: result.message ?? 'Invalid coupon code',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isApplyingCoupon: false, error: e.toString());
      return false;
    }
  }

  /// Remove applied coupon
  Future<void> removeCoupon() async {
    if (!_useApi) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _cartService.removeCoupon();
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

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
