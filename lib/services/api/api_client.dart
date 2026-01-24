import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';
import 'api_exceptions.dart';

/// HTTP Client for API communication
/// Handles authentication, token refresh, and error handling
class ApiClient {
  static ApiClient? _instance;
  final http.Client _httpClient;
  final FlutterSecureStorage _storage;

  String? _accessToken;
  String? _refreshToken;
  bool _isRefreshing = false;
  final List<Completer<void>> _refreshQueue = [];

  ApiClient._({http.Client? client, FlutterSecureStorage? storage})
    : _httpClient = client ?? http.Client(),
      _storage = storage ?? const FlutterSecureStorage();

  /// Singleton instance
  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  /// Factory constructor for dependency injection
  factory ApiClient({http.Client? client, FlutterSecureStorage? storage}) {
    return ApiClient._(client: client, storage: storage);
  }

  // ============ Token Management ============

  /// Initialize client and load stored tokens
  Future<void> initialize() async {
    _accessToken = await _storage.read(key: 'access_token');
    _refreshToken = await _storage.read(key: 'refresh_token');
  }

  /// Save tokens after login/register
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _storage.write(key: 'access_token', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
  }

  /// Clear tokens on logout
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  /// Check if user has valid token
  bool get hasToken => _accessToken != null && _accessToken!.isNotEmpty;

  /// Get current access token
  String? get accessToken => _accessToken;

  /// Health check to verify API connectivity
  Future<bool> healthCheck() async {
    try {
      final url = _buildUrl(ApiConfig.health);
      final response = await _httpClient
          .get(url, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 5));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }

  // ============ HTTP Methods ============

  /// GET request
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool requiresAuth = true,
  }) async {
    final url = _buildUrl(endpoint, queryParams);
    return _sendRequest(
      () => _httpClient.get(url, headers: _buildHeaders(requiresAuth)),
      requiresAuth: requiresAuth,
    );
  }

  /// POST request
  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final url = _buildUrl(endpoint);
    return _sendRequest(
      () => _httpClient.post(
        url,
        headers: _buildHeaders(requiresAuth),
        body: body != null ? jsonEncode(body) : null,
      ),
      requiresAuth: requiresAuth,
    );
  }

  /// PUT request
  Future<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final url = _buildUrl(endpoint);
    return _sendRequest(
      () => _httpClient.put(
        url,
        headers: _buildHeaders(requiresAuth),
        body: body != null ? jsonEncode(body) : null,
      ),
      requiresAuth: requiresAuth,
    );
  }

  /// PATCH request
  Future<ApiResponse> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final url = _buildUrl(endpoint);
    return _sendRequest(
      () => _httpClient.patch(
        url,
        headers: _buildHeaders(requiresAuth),
        body: body != null ? jsonEncode(body) : null,
      ),
      requiresAuth: requiresAuth,
    );
  }

  /// DELETE request
  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final url = _buildUrl(endpoint);
    return _sendRequest(
      () => _httpClient.delete(
        url,
        headers: _buildHeaders(requiresAuth),
        body: body != null ? jsonEncode(body) : null,
      ),
      requiresAuth: requiresAuth,
    );
  }

  /// Multipart POST request (for file uploads)
  Future<ApiResponse> uploadFile(
    String endpoint, {
    required String filePath,
    required String fieldName,
    Map<String, String>? fields,
    bool requiresAuth = true,
  }) async {
    final url = _buildUrl(endpoint);
    final request = http.MultipartRequest('POST', url);

    // Add headers
    final headers = _buildHeaders(requiresAuth);
    headers.remove('Content-Type'); // Let multipart set its own content type
    request.headers.addAll(headers);

    // Add file
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

    // Add additional fields
    if (fields != null) {
      request.fields.addAll(fields);
    }

    try {
      final streamedResponse = await request.send().timeout(
        ApiConfig.sendTimeout,
      );
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    }
  }

  // ============ Private Helpers ============

  Uri _buildUrl(String endpoint, [Map<String, dynamic>? queryParams]) {
    final url = '${ApiConfig.baseUrl}$endpoint';
    if (queryParams != null && queryParams.isNotEmpty) {
      return Uri.parse(url).replace(
        queryParameters: queryParams.map(
          (key, value) => MapEntry(key, value?.toString() ?? ''),
        ),
      );
    }
    return Uri.parse(url);
  }

  Map<String, String> _buildHeaders(bool requiresAuth) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  Future<ApiResponse> _sendRequest(
    Future<http.Response> Function() request, {
    bool requiresAuth = true,
    bool isRetry = false,
  }) async {
    try {
      final response = await request().timeout(ApiConfig.receiveTimeout);

      // Handle 401 Unauthorized - try to refresh token
      if (response.statusCode == 401 && requiresAuth && !isRetry) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          // Retry the original request
          return _sendRequest(
            request,
            requiresAuth: requiresAuth,
            isRetry: true,
          );
        } else {
          throw UnauthorizedException('Session expired. Please login again.');
        }
      }

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(
        'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      throw NetworkException('Request timed out. Please try again.');
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  ApiResponse _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: body['data'],
        message: body['message'],
      );
    }

    // Handle error responses
    final message = body['message'] ?? 'Something went wrong';
    final errors = body['errors'];

    switch (response.statusCode) {
      case 400:
        throw BadRequestException(message, errors: errors);
      case 401:
        throw UnauthorizedException(message);
      case 403:
        throw ForbiddenException(message);
      case 404:
        throw NotFoundException(message);
      case 409:
        throw ConflictException(message);
      case 422:
        throw ValidationException(message, errors: errors);
      case 429:
        throw RateLimitException(
          'Too many requests. Please wait and try again.',
        );
      case 500:
      case 502:
      case 503:
        throw ServerException('Server error. Please try again later.');
      default:
        throw ApiException(message, statusCode: response.statusCode);
    }
  }

  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) return false;

    // If already refreshing, wait for it to complete
    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshQueue.add(completer);
      await completer.future;
      return _accessToken != null;
    }

    _isRefreshing = true;

    try {
      final response = await _httpClient
          .post(
            _buildUrl(ApiConfig.refreshToken),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': _refreshToken}),
          )
          .timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        await saveTokens(
          accessToken: body['data']['accessToken'],
          refreshToken: body['data']['refreshToken'],
        );

        // Complete all waiting requests
        for (final completer in _refreshQueue) {
          completer.complete();
        }
        _refreshQueue.clear();

        return true;
      } else {
        // Refresh failed - clear tokens
        await clearTokens();

        // Fail all waiting requests
        for (final completer in _refreshQueue) {
          completer.complete();
        }
        _refreshQueue.clear();

        return false;
      }
    } catch (e) {
      await clearTokens();
      for (final completer in _refreshQueue) {
        completer.complete();
      }
      _refreshQueue.clear();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Dispose the client
  void dispose() {
    _httpClient.close();
  }
}

/// API Response wrapper
class ApiResponse {
  final bool success;
  final int statusCode;
  final dynamic data;
  final String? message;

  ApiResponse({
    required this.success,
    required this.statusCode,
    this.data,
    this.message,
  });

  /// Check if response has data
  bool get hasData => data != null;

  /// Get data as Map
  Map<String, dynamic> get dataAsMap => data as Map<String, dynamic>? ?? {};

  /// Get data as List
  List<dynamic> get dataAsList => data as List<dynamic>? ?? [];
}
