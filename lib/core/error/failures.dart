import 'package:equatable/equatable.dart';

/// Base failure class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  List<Object?> get props => [message, code];
}

/// Server failure class for all server failures
class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    String? code,
  }) : super(
    message: message,
    code: code,
  );
}

/// Cache failure class for all cache failures
class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    String? code,
  }) : super(
    message: message,
    code: code,
  );
}

/// Network failure class for all network failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    String? code,
  }) : super(
    message: message,
    code: code,
  );
}

/// Input validation failure for form validations
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;
  
  const ValidationFailure({
    required String message,
    this.fieldErrors,
    String? code,
  }) : super(
    message: message,
    code: code,
  );
  
  @override
  List<Object?> get props => [message, code, fieldErrors];
}

/// Authentication failure for auth operations
class AuthFailure extends Failure {
  const AuthFailure({
    required String message,
    String? code,
  }) : super(
    message: message,
    code: code,
  );
}

/// General failure for unexpected scenarios
class GeneralFailure extends Failure {
  const GeneralFailure({
    required String message,
    String? code,
  }) : super(
    message: message,
    code: code,
  );
}