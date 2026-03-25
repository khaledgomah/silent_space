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
      id: json['id'] as int?,
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

  /// Creates a [UserModel] from a login/register response + the
  /// original email (since reqres.in doesn't echo it back).
  factory UserModel.fromLoginResponse(
    Map<String, dynamic> json, {
    required String email,
  }) {
    return UserModel(
      id: json['id'] as int?,
      email: email,
      token: json['token'] as String?,
    );
  }
}
