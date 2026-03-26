import 'package:silent_space/features/auth/domain/entities/user_entity.dart';

/// Data model extending [UserEntity] with JSON serialization.
class UserModel extends UserEntity {
  const UserModel({
    super.id,
    required super.email,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String? ?? '',
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
    };
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
}
