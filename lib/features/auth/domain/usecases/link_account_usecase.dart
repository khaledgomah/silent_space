import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';

class LinkAccountUseCase extends UseCase<UserEntity, LinkAccountParams> {
  final AuthRepository repository;

  LinkAccountUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LinkAccountParams params) async {
    return await repository.linkAccountWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LinkAccountParams extends Equatable {
  final String email;
  final String password;

  const LinkAccountParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
