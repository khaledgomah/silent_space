import 'package:silent_space/features/auth/domain/entities/user_entity.dart';

/// Data model for authentication — contains JSON serialization.
class UserModel {
  const UserModel({
    this.id,
    required this.email,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String? ?? '',
      token: json['token'] as String?,
    );
  }

  /// Creates a [UserModel] from a Firebase User object.
  factory UserModel.fromFirebaseUser({
    required String uid,
    required String? email,
    String? token,
  }) {
    return UserModel(
      id: uid,
      email: email ?? '',
      token: token,
    );
  }
  final String? id;
  final String email;
  final String? token;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      token: token,
    );
  }
}
