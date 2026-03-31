import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';

class VerifyResetTokenUseCase implements UseCase<ForgotPasswordEntity, String> {
  VerifyResetTokenUseCase(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, ForgotPasswordEntity>> call(String token) {
    return repository.verifyResetToken(token);
  }
}
