import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';

/// Contract for authentication operations.
/// Repository implementations live in the data layer.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInAnonymously();

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> linkAccountWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, bool>> isLoggedIn();

  // Forgot Password
  Future<Either<Failure, void>> requestPasswordReset(String email);
  Future<Either<Failure, ForgotPasswordEntity>> verifyResetToken(String token);
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);
}
