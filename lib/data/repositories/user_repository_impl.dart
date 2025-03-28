import 'package:dartz/dartz.dart';
import 'package:gardas/core/constants/app_constants.dart';
import 'package:gardas/core/error/error_handler.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/data/datasources/local/local_storage_service.dart';
import 'package:gardas/data/models/user_model.dart';
import 'package:gardas/domain/entities/user.dart';
import 'package:gardas/domain/repositories/user_repository.dart';

/// Implementation of [UserRepository]
class UserRepositoryImpl implements UserRepository {
  final LocalStorageService _storageService;
  final ErrorHandler _errorHandler;

  /// Constructor for UserRepositoryImpl
  UserRepositoryImpl(this._storageService, this._errorHandler);

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final UserModel? userModel = _storageService.getObject<UserModel>(
        AppConstants.userBoxName,
        AppConstants.userProfileKey,
        UserModel.fromJson,
      );
      
      if (userModel != null) {
        return Right(userModel);
      } else {
        // Create a default user if none exists
        return createUser();
      }
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      final UserModel userModel = UserModel.fromEntity(user);
      
      await _storageService.putObject<UserModel>(
        AppConstants.userBoxName,
        AppConstants.userProfileKey,
        userModel,
        (user) => user.toJson(),
      );
      
      return Right(userModel);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, User>> updateUsername(String username) async {
    try {
      // Get current user
      final Either<Failure, User> userResult = await getCurrentUser();
      
      return userResult.fold(
        (failure) => Left(failure),
        (user) async {
          // Update username
          final UserModel updatedUser = UserModel.fromEntity(user).copyWith(
            username: username,
            updatedAt: DateTime.now(),
          );
          
          // Save updated user
          await _storageService.putObject<UserModel>(
            AppConstants.userBoxName,
            AppConstants.userProfileKey,
            updatedUser,
            (user) => user.toJson(),
          );
          
          return Right(updatedUser);
        },
      );
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, User>> updateAvatar(String avatarPath) async {
    try {
      // Get current user
      final Either<Failure, User> userResult = await getCurrentUser();
      
      return userResult.fold(
        (failure) => Left(failure),
        (user) async {
          // Update avatar
          final UserModel updatedUser = UserModel.fromEntity(user).copyWith(
            avatarUrl: avatarPath,
            updatedAt: DateTime.now(),
          );
          
          // Save updated user
          await _storageService.putObject<UserModel>(
            AppConstants.userBoxName,
            AppConstants.userProfileKey,
            updatedUser,
            (user) => user.toJson(),
          );
          
          return Right(updatedUser);
        },
      );
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, User>> createUser() async {
    try {
      // Create a new default user
      final now = DateTime.now();
      final UserModel newUser = UserModel(
        id: now.millisecondsSinceEpoch.toString(),
        username: AppConstants.defaultUsername,
        avatarUrl: null,
        createdAt: now,
        updatedAt: now,
      );
      
      // Save new user
      await _storageService.putObject<UserModel>(
        AppConstants.userBoxName,
        AppConstants.userProfileKey,
        newUser,
        (user) => user.toJson(),
      );
      
      return Right(newUser);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUserData() async {
    try {
      // Delete user profile
      await _storageService.delete(
        AppConstants.userBoxName,
        AppConstants.userProfileKey,
      );
      
      return const Right(true);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }
}