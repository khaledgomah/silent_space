import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.id,
    required this.email,
    this.token,
  });
  final String? id;
  final String email;
  final String? token;

  @override
  List<Object?> get props => [id, email, token];
}
