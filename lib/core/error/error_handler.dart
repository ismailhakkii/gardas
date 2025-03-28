import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/core/error/exceptions.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:logger/logger.dart';

/// Error handler for the application
/// 
/// This class is responsible for handling exceptions and converting them to failures.
class ErrorHandler {
  final Logger _logger = Logger();
  
  /// Handles exceptions and converts them to failures
  Failure handleException(dynamic exception) {
    _logger.e('Exception occurred', error: exception);
    
    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        fieldErrors: exception.fieldErrors,
        code: exception.code,
      );
    } else if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is TimeoutException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is NotFoundException) {
      return GeneralFailure(
        message: exception.message,
        code: exception.code,
      );
    } else {
      return const GeneralFailure(
        message: AppStrings.errorGeneral,
      );
    }
  }
  
  /// Gets user-friendly message from failure
  String getMessageFromFailure(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message.isNotEmpty 
          ? failure.message 
          : AppStrings.errorServer;
    } else if (failure is CacheFailure) {
      return failure.message.isNotEmpty 
          ? failure.message 
          : AppStrings.errorDataNotFound;
    } else if (failure is NetworkFailure) {
      return failure.message.isNotEmpty 
          ? failure.message 
          : AppStrings.errorNetwork;
    } else if (failure is ValidationFailure) {
      return failure.message.isNotEmpty 
          ? failure.message 
          : AppStrings.errorInvalidInput;
    } else if (failure is AuthFailure) {
      return failure.message.isNotEmpty 
          ? failure.message 
          : AppStrings.errorUnauthorized;
    } else {
      return AppStrings.errorGeneral;
    }
  }
  
  /// Logs failure
  void logFailure(Failure failure) {
    _logger.e('Failure occurred', error: failure);
  }
}