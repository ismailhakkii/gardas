import 'package:equatable/equatable.dart';
import 'package:gardas/core/constants/app_constants.dart';

/// User entity
/// 
/// Represents a user in the application.
class User extends Equatable {
  /// Unique identifier for the user
  final String id;
  
  /// Username of the user
  final String username;
  
  /// Avatar image URL/path of the user
  final String? avatarUrl;
  
  /// Date when the user was created
  final DateTime createdAt;
  
  /// Date when the user was last updated
  final DateTime updatedAt;

  /// Constructor for User entity
  const User({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new User instance with default values
  factory User.defaultUser() {
    final now = DateTime.now();
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: AppConstants.defaultUsername,
      avatarUrl: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Creates a copy of this User with the given fields replaced with new values
  User copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, username, avatarUrl, createdAt, updatedAt];
}