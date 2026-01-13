/// Custom API Exceptions for better error handling
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Thrown when authentication fails
class UnauthorizedException extends ApiException {
  UnauthorizedException({
    super.message = 'Unauthorized. Please login again.',
    super.data,
  }) : super(statusCode: 401);
}

/// Thrown when resource is not found
class NotFoundException extends ApiException {
  NotFoundException({super.message = 'Resource not found.', super.data})
    : super(statusCode: 404);
}

/// Thrown when request is invalid
class BadRequestException extends ApiException {
  BadRequestException({super.message = 'Invalid request.', super.data})
    : super(statusCode: 400);
}

/// Thrown when user doesn't have permission
class ForbiddenException extends ApiException {
  ForbiddenException({super.message = 'Access forbidden.', super.data})
    : super(statusCode: 403);
}

/// Thrown when server error occurs
class ServerException extends ApiException {
  ServerException({
    super.message = 'Server error. Please try again later.',
    int super.statusCode = 500,
    super.data,
  });
}

/// Thrown when network is unavailable
class NetworkException extends ApiException {
  NetworkException({
    super.message = 'Network error. Please check your connection.',
    super.data,
  }) : super(statusCode: null);
}

/// Thrown when request times out
class TimeoutException extends ApiException {
  TimeoutException({
    super.message = 'Request timed out. Please try again.',
    super.data,
  }) : super(statusCode: null);
}

/// Thrown when validation fails
class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  ValidationException({
    super.message = 'Validation failed.',
    this.errors,
    super.data,
  }) : super(statusCode: 422);
}
