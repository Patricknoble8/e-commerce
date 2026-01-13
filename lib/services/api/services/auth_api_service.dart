import 'package:e_commerce/services/api/api_client.dart';
import 'package:e_commerce/services/api/api_config.dart';
import 'package:e_commerce/models/user.dart';

/// Response model for authentication
class AuthResponse {
  final User user;
  final String accessToken;
  final String? refreshToken;

  AuthResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}

/// Authentication API Service
/// Handles login, registration, password reset, etc.
class AuthApiService {
  final ApiClient _client;

  AuthApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Login with email and password
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      ApiConfig.login,
      data: {'email': email, 'password': password},
    );

    final authResponse = AuthResponse.fromJson(response.data);

    // Save tokens
    await _client.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );

    return authResponse;
  }

  /// Register a new user
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _client.post(
      ApiConfig.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data);

    // Save tokens
    await _client.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );

    return authResponse;
  }

  /// Logout the current user
  Future<void> logout() async {
    try {
      await _client.post(ApiConfig.logout);
    } finally {
      await _client.clearTokens();
    }
  }

  /// Send forgot password email
  Future<void> forgotPassword(String email) async {
    await _client.post(ApiConfig.forgotPassword, data: {'email': email});
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    await _client.post(
      ApiConfig.resetPassword,
      data: {'token': token, 'password': password},
    );
  }

  /// Get current user profile
  Future<User> getProfile() async {
    final response = await _client.get(ApiConfig.profile);
    return User.fromJson(response.data['user'] ?? response.data);
  }

  /// Update user profile
  Future<User> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    final response = await _client.put(
      ApiConfig.updateProfile,
      data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      },
    );
    return User.fromJson(response.data['user'] ?? response.data);
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.post(
      ApiConfig.changePassword,
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }

  /// Upload avatar/profile image
  Future<String> uploadAvatar(String imagePath) async {
    final response = await _client.uploadFile(
      ApiConfig.uploadAvatar,
      filePath: imagePath,
      fieldName: 'avatar',
    );
    return response.data['avatar_url'];
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _client.isAuthenticated();
  }
}
