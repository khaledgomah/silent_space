import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String email;
  final String? token;

  const UserEntity({
    this.id,
    required this.email,
    this.token,
  });

  @override
  List<Object?> get props => [id, email, token];
}
