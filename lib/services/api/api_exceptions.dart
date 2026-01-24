/// Base API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;
}

/// Network related exceptions (no internet, timeout, etc.)
class NetworkException extends ApiException {
  NetworkException(super.message);
}

/// 400 Bad Request
class BadRequestException extends ApiException {
  BadRequestException(super.message, {super.errors});
}

/// 401 Unauthorized
class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message) : super(statusCode: 401);
}

/// 403 Forbidden
class ForbiddenException extends ApiException {
  ForbiddenException(super.message) : super(statusCode: 403);
}

/// 404 Not Found
class NotFoundException extends ApiException {
  NotFoundException(super.message) : super(statusCode: 404);
}

/// 409 Conflict (e.g., email already exists)
class ConflictException extends ApiException {
  ConflictException(super.message) : super(statusCode: 409);
}

/// 422 Validation Error
class ValidationException extends ApiException {
  final Map<String, List<String>>? fieldErrors;

  ValidationException(super.message, {super.errors})
    : fieldErrors = _parseFieldErrors(errors);

  static Map<String, List<String>>? _parseFieldErrors(dynamic errors) {
    if (errors == null) return null;
    if (errors is Map<String, dynamic>) {
      return errors.map((key, value) {
        if (value is List) {
          return MapEntry(key, value.map((e) => e.toString()).toList());
        }
        return MapEntry(key, [value.toString()]);
      });
    }
    return null;
  }

  /// Get first error for a specific field
  String? getFieldError(String field) {
    return fieldErrors?[field]?.firstOrNull;
  }

  /// Check if a field has error
  bool hasFieldError(String field) {
    return fieldErrors?.containsKey(field) ?? false;
  }
}

/// 429 Rate Limit Exceeded
class RateLimitException extends ApiException {
  RateLimitException(super.message) : super(statusCode: 429);
}

/// 500+ Server Error
class ServerException extends ApiException {
  ServerException(super.message) : super(statusCode: 500);
}

/// Helper extension to handle API exceptions in UI
extension ApiExceptionHandler on ApiException {
  /// Get user-friendly error message
  String get userMessage {
    if (this is NetworkException) {
      return 'Please check your internet connection and try again.';
    }
    if (this is UnauthorizedException) {
      return 'Your session has expired. Please login again.';
    }
    if (this is RateLimitException) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    if (this is ServerException) {
      return 'Something went wrong on our end. Please try again later.';
    }
    return message;
  }

  /// Check if error is retryable
  bool get isRetryable {
    return this is NetworkException || this is ServerException;
  }

  /// Check if should logout user
  bool get shouldLogout {
    return this is UnauthorizedException;
  }
}
