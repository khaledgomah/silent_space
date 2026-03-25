import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';

/// Contract for authentication operations.
/// Repository implementations live in the data layer.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<bool> isLoggedIn();
}
