import '../api_client.dart';
import '../api_config.dart';
import '../../../models/user.dart';
import '../../../models/shipping_address.dart';

/// Authentication API Service
/// Handles login, register, password reset, and profile management
class AuthService {
  final ApiClient _client;

  AuthService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  // ============ Authentication ============

  /// Login with email and password
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      ApiConfig.login,
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );

    final data = response.dataAsMap;

    // Save tokens
    await _client.saveTokens(
      accessToken: data['accessToken'] ?? data['token'],
      refreshToken: data['refreshToken'],
    );

    return AuthResponse(
      user: User.fromJson(data['user']),
      accessToken: data['accessToken'] ?? data['token'],
      refreshToken: data['refreshToken'],
    );
  }

  /// Register new user
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      ApiConfig.register,
      body: {'name': name, 'email': email, 'password': password},
      requiresAuth: false,
    );

    final data = response.dataAsMap;

    // Save tokens if provided (some APIs require email verification first)
    if (data['accessToken'] != null || data['token'] != null) {
      await _client.saveTokens(
        accessToken: data['accessToken'] ?? data['token'],
        refreshToken: data['refreshToken'],
      );
    }

    return AuthResponse(
      user: User.fromJson(data['user']),
      accessToken: data['accessToken'] ?? data['token'],
      refreshToken: data['refreshToken'],
      message: response.message,
    );
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      await _client.post(ApiConfig.logout);
    } finally {
      await _client.clearTokens();
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    await _client.initialize();
    return _client.hasToken;
  }

  /// Forgot password - request reset email
  Future<String> forgotPassword(String email) async {
    final response = await _client.post(
      ApiConfig.forgotPassword,
      body: {'email': email},
      requiresAuth: false,
    );
    return response.message ?? 'Password reset email sent';
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    await _client.post(
      ApiConfig.resetPassword,
      body: {'token': token, 'password': password},
      requiresAuth: false,
    );
  }

  /// Verify email with token
  Future<void> verifyEmail(String token) async {
    await _client.post('${ApiConfig.verifyEmail}/$token', requiresAuth: false);
  }

  /// Resend verification email
  Future<void> resendVerificationEmail(String email) async {
    await _client.post(
      ApiConfig.resendVerification,
      body: {'email': email},
      requiresAuth: false,
    );
  }

  // ============ Profile Management ============

  /// Get current user profile
  Future<User> getProfile() async {
    final response = await _client.get(ApiConfig.profile);
    return User.fromJson(response.dataAsMap);
  }

  /// Update user profile
  Future<User> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (phone != null) body['phone'] = phone;

    final response = await _client.put(ApiConfig.updateProfile, body: body);
    return User.fromJson(response.dataAsMap);
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.post(
      ApiConfig.changePassword,
      body: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }

  /// Upload avatar image
  Future<String> uploadAvatar(String filePath) async {
    final response = await _client.uploadFile(
      ApiConfig.uploadAvatar,
      filePath: filePath,
      fieldName: 'avatar',
    );
    return response.dataAsMap['avatarUrl'] ?? '';
  }

  /// Delete user account
  Future<void> deleteAccount({required String password}) async {
    await _client.delete(ApiConfig.deleteAccount, body: {'password': password});
    await _client.clearTokens();
  }

  // ============ Address Management ============

  /// Get all user addresses
  Future<List<ShippingAddress>> getAddresses() async {
    final response = await _client.get(ApiConfig.addresses);
    return (response.dataAsList)
        .map((json) => ShippingAddress.fromJson(json))
        .toList();
  }

  /// Add new address
  Future<ShippingAddress> addAddress(ShippingAddress address) async {
    final response = await _client.post(
      ApiConfig.addresses,
      body: address.toJson(),
    );
    return ShippingAddress.fromJson(response.dataAsMap);
  }

  /// Update address
  Future<ShippingAddress> updateAddress(ShippingAddress address) async {
    final response = await _client.put(
      ApiConfig.addressById(address.id),
      body: address.toJson(),
    );
    return ShippingAddress.fromJson(response.dataAsMap);
  }

  /// Delete address
  Future<void> deleteAddress(String addressId) async {
    await _client.delete(ApiConfig.addressById(addressId));
  }

  /// Set address as default
  Future<void> setDefaultAddress(String addressId) async {
    await _client.patch(
      ApiConfig.addressById(addressId),
      body: {'isDefault': true},
    );
  }
}

/// Auth response model
class AuthResponse {
  final User user;
  final String? accessToken;
  final String? refreshToken;
  final String? message;

  AuthResponse({
    required this.user,
    this.accessToken,
    this.refreshToken,
    this.message,
  });
}
