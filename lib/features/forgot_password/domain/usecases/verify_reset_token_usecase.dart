import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/forgot_password/domain/entities/forgot_password_entity.dart';
import 'package:silent_space/features/forgot_password/domain/repositories/forgot_password_repository.dart';

class VerifyResetTokenUseCase implements UseCase<ForgotPasswordEntity, String> {
  final ForgotPasswordRepository repository;

  VerifyResetTokenUseCase(this.repository);

  @override
  Future<Either<Failure, ForgotPasswordEntity>> call(String token) {
    return repository.verifyResetToken(token);
  }
}
