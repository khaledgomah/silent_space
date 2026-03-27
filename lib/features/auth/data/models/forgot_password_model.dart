import 'package:silent_space/features/auth/domain/entities/forgot_password_entity.dart';

class ForgotPasswordModel extends ForgotPasswordEntity {
  const ForgotPasswordModel({
    required super.email,
    super.token,
    super.expiresAt,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      email: json['email'] as String? ?? '',
      token: json['token'] as String?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  ForgotPasswordEntity toEntity() {
    return ForgotPasswordEntity(
      email: email,
      token: token,
      expiresAt: expiresAt,
    );
  }
}
