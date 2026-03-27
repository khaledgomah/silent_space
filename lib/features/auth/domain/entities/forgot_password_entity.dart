import 'package:equatable/equatable.dart';

class ForgotPasswordEntity extends Equatable {
  final String email;
  final String? token;
  final DateTime? expiresAt;

  const ForgotPasswordEntity({
    required this.email,
    this.token,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [email, token, expiresAt];
}
