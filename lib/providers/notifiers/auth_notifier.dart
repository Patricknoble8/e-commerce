import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../models/shipping_address.dart';

/// Authentication state
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// Auth state class
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({this.status = AuthStatus.initial, this.user, this.error});

  AuthState copyWith({AuthStatus? status, User? user, String? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

/// Auth notifier for managing authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    // Simulate checking auth status - auto login with demo user
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        // Start as authenticated with demo user for demo purposes
        state = AuthState(
          status: AuthStatus.authenticated,
          user: const User(
            id: '1',
            name: 'Olivia',
            email: 'olivia@gmail.com',
            phone: '+1 234 567 8900',
            membershipTier: 'Gold',
            loyaltyPoints: 2450,
            totalOrders: 12,
            totalReviews: 8,
            walletBalance: 45.50,
          ),
        );
      }
    });
  }

  /// Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Demo validation
    if (email.isEmpty || !email.contains('@')) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Please enter a valid email address',
      );
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Password must be at least 6 characters',
      );
      return false;
    }

    // Demo success
    state = AuthState(
      status: AuthStatus.authenticated,
      user: User(
        id: '1',
        name: email.split('@')[0].capitalize(),
        email: email,
        phone: '+1 234 567 8900',
        membershipTier: 'Bronze',
        loyaltyPoints: 0,
        totalOrders: 0,
        totalReviews: 0,
        walletBalance: 0.0,
      ),
    );

    return true;
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    await Future.delayed(const Duration(seconds: 1));

    // Validation
    if (name.isEmpty || name.length < 2) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Please enter your name',
      );
      return false;
    }

    if (email.isEmpty || !email.contains('@')) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Please enter a valid email address',
      );
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Password must be at least 6 characters',
      );
      return false;
    }

    if (password != confirmPassword) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Passwords do not match',
      );
      return false;
    }

    // Demo success
    state = AuthState(
      status: AuthStatus.authenticated,
      user: User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        membershipTier: 'Bronze',
        loyaltyPoints: 100, // Welcome bonus
        totalOrders: 0,
        totalReviews: 0,
        walletBalance: 0.0,
      ),
    );

    return true;
  }

  /// Sign out
  void signOut() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Update user profile
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    if (state.user == null) return;

    state = state.copyWith(
      user: state.user!.copyWith(
        name: name,
        email: email,
        phone: phone,
        avatarUrl: avatarUrl,
      ),
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

/// Current user provider (convenience)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

/// Is authenticated provider (convenience)
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Extension for string capitalization
extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Shipping addresses state
class AddressListState {
  final List<ShippingAddress> addresses;
  final bool isLoading;
  final String? error;

  const AddressListState({
    this.addresses = const [],
    this.isLoading = false,
    this.error,
  });

  AddressListState copyWith({
    List<ShippingAddress>? addresses,
    bool? isLoading,
    String? error,
  }) {
    return AddressListState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Address notifier for managing shipping addresses
class AddressNotifier extends StateNotifier<AddressListState> {
  AddressNotifier() : super(const AddressListState(isLoading: true)) {
    _loadAddresses();
  }

  void _loadAddresses() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        state = AddressListState(
          addresses: const [
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
          ],
          isLoading: false,
        );
      }
    });
  }

  /// Add new address
  void addAddress(ShippingAddress address) {
    final newAddress = address.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    // If this is set as default, update others
    List<ShippingAddress> updatedAddresses;
    if (newAddress.isDefault) {
      updatedAddresses = state.addresses
          .map((a) => a.copyWith(isDefault: false))
          .toList();
    } else {
      updatedAddresses = [...state.addresses];
    }

    updatedAddresses.add(newAddress);
    state = state.copyWith(addresses: updatedAddresses);
  }

  /// Update address
  void updateAddress(ShippingAddress address) {
    List<ShippingAddress> updatedAddresses;

    if (address.isDefault) {
      updatedAddresses = state.addresses.map((a) {
        if (a.id == address.id) return address;
        return a.copyWith(isDefault: false);
      }).toList();
    } else {
      updatedAddresses = state.addresses.map((a) {
        if (a.id == address.id) return address;
        return a;
      }).toList();
    }

    state = state.copyWith(addresses: updatedAddresses);
  }

  /// Delete address
  void deleteAddress(String addressId) {
    final updatedAddresses = state.addresses
        .where((a) => a.id != addressId)
        .toList();

    // If we deleted the default, make the first one default
    if (updatedAddresses.isNotEmpty &&
        !updatedAddresses.any((a) => a.isDefault)) {
      updatedAddresses[0] = updatedAddresses[0].copyWith(isDefault: true);
    }

    state = state.copyWith(addresses: updatedAddresses);
  }

  /// Set default address
  void setDefaultAddress(String addressId) {
    final updatedAddresses = state.addresses.map((a) {
      return a.copyWith(isDefault: a.id == addressId);
    }).toList();

    state = state.copyWith(addresses: updatedAddresses);
  }

  /// Get default address
  ShippingAddress? get defaultAddress {
    try {
      return state.addresses.firstWhere((a) => a.isDefault);
    } catch (e) {
      return state.addresses.isNotEmpty ? state.addresses.first : null;
    }
  }
}

/// Address provider
final addressProvider =
    StateNotifierProvider<AddressNotifier, AddressListState>(
      (ref) => AddressNotifier(),
    );

/// Default address provider
final defaultAddressProvider = Provider<ShippingAddress?>((ref) {
  final addresses = ref.watch(addressProvider).addresses;
  try {
    return addresses.firstWhere((a) => a.isDefault);
  } catch (e) {
    return addresses.isNotEmpty ? addresses.first : null;
  }
});
