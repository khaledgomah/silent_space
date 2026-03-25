import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase extends UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) {
    return repository.signIn(email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
