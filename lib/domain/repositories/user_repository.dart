import 'package:dartz/dartz.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/user.dart';

/// User Repository Interface
/// 
/// This interface defines methods for managing user data.
abstract class UserRepository {
  /// Gets the current user
  /// 
  /// Returns a [User] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, User>> getCurrentUser();
  
  /// Updates the user profile
  /// 
  /// [user] is the updated user entity.
  /// Returns the updated [User] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, User>> updateUser(User user);
  
  /// Updates the user's username
  /// 
  /// [username] is the new username.
  /// Returns the updated [User] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, User>> updateUsername(String username);
  
  /// Updates the user's avatar
  /// 
  /// [avatarPath] is the path to the new avatar image.
  /// Returns the updated [User] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, User>> updateAvatar(String avatarPath);
  
  /// Creates a new user
  /// 
  /// Returns the created [User] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, User>> createUser();
  
  /// Deletes the user's data
  /// 
  /// Returns [true] if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, bool>> deleteUserData();
}