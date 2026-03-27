import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/forgot_password/domain/entities/forgot_password_entity.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, void>> requestPasswordReset(String email);
  Future<Either<Failure, ForgotPasswordEntity>> verifyResetToken(String token);
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);
}
