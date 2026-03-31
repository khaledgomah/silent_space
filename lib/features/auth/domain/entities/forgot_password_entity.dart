import 'package:equatable/equatable.dart';

class ForgotPasswordEntity extends Equatable {
  const ForgotPasswordEntity({
    required this.email,
    this.token,
    this.expiresAt,
  });
  final String email;
  final String? token;
  final DateTime? expiresAt;

  @override
  List<Object?> get props => [email, token, expiresAt];
}
