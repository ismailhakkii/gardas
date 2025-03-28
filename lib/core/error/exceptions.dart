/// Base exception class for all exceptions in the application
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;
  
  AppException({
    required this.message,
    this.code,
    this.details,
  });
  
  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Server exception for all server errors
class ServerException extends AppException {
  ServerException({
    required String message,
    String? code,
    dynamic details,
  }) : super(
    message: message,
    code: code,
    details: details,
  );
}

/// Cache exception for all cache errors
class CacheException extends AppException {
  CacheException({
    required String message,
    String? code,
    dynamic details,
  }) : super(
    message: message,
    code: code,
    details: details,
  );
}

/// Network exception for network errors
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    dynamic details,
  }) : super(
    message: message,
    code: code,
    details: details,
  );
}

/// Validation exception for form validations
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;
  
  ValidationException({
    required String message,
    this.fieldErrors,
    String? code,
    dynamic details,
  }) : super(
    message: message,
    code: code,
    details: details,
  );
}

/// Authentication exception for auth operations
class AuthException extends AppException {
  AuthException({
    required String message,
    String? code,
    dynamic details,
  }) : super(
    message: message,
    code: code,
    details: details,
  );
}

/// Timeout exception for network timeouts
class TimeoutException extends AppException {
  TimeoutException({
    String message = 'Operation timed out',
    String? code,
    dynamic details,
  }) : super(
    message: message,
    code: code,
    details: details,
  );
}

/// Data not found exception
class NotFoundException extends AppException {
  NotFoundException({
    String message = 'Data not found',
    String? code,
    dynamic details,
  }) : super(
    message: message,
    code: code,
    details: details,
  );
}