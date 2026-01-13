import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../models/shipping_address.dart';
import '../../services/api/api_exceptions.dart';
import '../../services/api/services/auth_api_service.dart';
import '../../services/api/services/addresses_api_service.dart';

/// Set to true to use real API, false for demo mode
const bool useApiMode = false;

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
  final AuthApiService _authService;

  AuthNotifier({AuthApiService? authService})
    : _authService = authService ?? AuthApiService(),
      super(const AuthState()) {
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    if (useApiMode) {
      // Check if user has valid token
      try {
        final isAuth = await _authService.isAuthenticated();
        if (isAuth) {
          final user = await _authService.getProfile();
          state = AuthState(status: AuthStatus.authenticated, user: user);
        } else {
          state = const AuthState(status: AuthStatus.unauthenticated);
        }
      } catch (e) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } else {
      // Demo mode - auto login with demo user
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
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
  }

  /// Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    // Validation
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

    if (useApiMode) {
      // Real API call
      try {
        final response = await _authService.login(
          email: email,
          password: password,
        );
        state = AuthState(
          status: AuthStatus.authenticated,
          user: response.user,
        );
        return true;
      } on ApiException catch (e) {
        state = state.copyWith(status: AuthStatus.error, error: e.message);
        return false;
      } catch (e) {
        state = state.copyWith(
          status: AuthStatus.error,
          error: 'Login failed. Please try again.',
        );
        return false;
      }
    } else {
      // Demo mode
      await Future.delayed(const Duration(seconds: 1));
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
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

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

    if (useApiMode) {
      // Real API call
      try {
        final response = await _authService.register(
          name: name,
          email: email,
          password: password,
        );
        state = AuthState(
          status: AuthStatus.authenticated,
          user: response.user,
        );
        return true;
      } on ApiException catch (e) {
        state = state.copyWith(status: AuthStatus.error, error: e.message);
        return false;
      } catch (e) {
        state = state.copyWith(
          status: AuthStatus.error,
          error: 'Registration failed. Please try again.',
        );
        return false;
      }
    } else {
      // Demo mode
      await Future.delayed(const Duration(seconds: 1));
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
  }

  /// Sign out
  Future<void> signOut() async {
    if (useApiMode) {
      try {
        await _authService.logout();
      } catch (_) {
        // Ignore errors during logout
      }
    }
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) async {
    if (state.user == null) return;

    if (useApiMode) {
      try {
        final updatedUser = await _authService.updateProfile(
          name: name,
          email: email,
          phone: phone,
        );
        state = state.copyWith(user: updatedUser);
      } catch (e) {
        // Fallback to local update
        state = state.copyWith(
          user: state.user!.copyWith(
            name: name,
            email: email,
            phone: phone,
            avatarUrl: avatarUrl,
          ),
        );
      }
    } else {
      state = state.copyWith(
        user: state.user!.copyWith(
          name: name,
          email: email,
          phone: phone,
          avatarUrl: avatarUrl,
        ),
      );
    }
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
  final AddressesApiService _addressService;

  AddressNotifier({AddressesApiService? addressService})
    : _addressService = addressService ?? AddressesApiService(),
      super(const AddressListState(isLoading: true)) {
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    if (useApiMode) {
      try {
        final addresses = await _addressService.getAddresses();
        state = AddressListState(addresses: addresses, isLoading: false);
      } catch (e) {
        state = AddressListState(
          isLoading: false,
          error: 'Failed to load addresses',
        );
      }
    } else {
      // Demo mode
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
  }

  /// Add new address
  Future<void> addAddress(ShippingAddress address) async {
    if (useApiMode) {
      try {
        final newAddress = await _addressService.addAddress(
          name: address.name,
          street: address.street,
          city: address.city,
          state: address.state,
          zipCode: address.zipCode,
          country: address.country,
          phone: address.phone,
          isDefault: address.isDefault,
        );

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
      } catch (e) {
        state = state.copyWith(error: 'Failed to add address');
      }
    } else {
      // Demo mode
      final newAddress = address.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );

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
  }

  /// Update address
  Future<void> updateAddress(ShippingAddress address) async {
    if (useApiMode) {
      try {
        await _addressService.updateAddress(
          addressId: address.id,
          name: address.name,
          street: address.street,
          city: address.city,
          state: address.state,
          zipCode: address.zipCode,
          country: address.country,
          phone: address.phone,
          isDefault: address.isDefault,
        );
      } catch (e) {
        // Continue with local update anyway
      }
    }

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
  Future<void> deleteAddress(String addressId) async {
    if (useApiMode) {
      try {
        await _addressService.deleteAddress(addressId);
      } catch (e) {
        // Continue with local delete anyway
      }
    }

    final updatedAddresses = state.addresses
        .where((a) => a.id != addressId)
        .toList();

    if (updatedAddresses.isNotEmpty &&
        !updatedAddresses.any((a) => a.isDefault)) {
      updatedAddresses[0] = updatedAddresses[0].copyWith(isDefault: true);
    }

    state = state.copyWith(addresses: updatedAddresses);
  }

  /// Set default address
  Future<void> setDefaultAddress(String addressId) async {
    if (useApiMode) {
      try {
        await _addressService.setDefaultAddress(addressId);
      } catch (e) {
        // Continue with local update anyway
      }
    }

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
