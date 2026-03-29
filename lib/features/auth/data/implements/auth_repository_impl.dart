import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/features/auth/data/sources/auth_local_data_source.dart';
import 'package:silent_space/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:silent_space/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final SessionRepository sessionRepository;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.sessionRepository,
  });

  @override
  Future<Either<Failure, UserEntity>> signInAnonymously() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final user = await remoteDataSource.signInAnonymously();
      if (user.token != null) {
        await localDataSource.cacheToken(user.token!);
      }
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.token != null) {
        await localDataSource.cacheToken(user.token!);
      }
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final user = await remoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.token != null) {
        await localDataSource.cacheToken(user.token!);
      }
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> linkAccountWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final user = await remoteDataSource.linkAccountWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.token != null) {
        await localDataSource.cacheToken(user.token!);
      }
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearToken();
      await sessionRepository.clearSessions();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      await localDataSource.clearToken();
      await sessionRepository.clearSessions();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      // Priority 1: Check local token cache
      final hasLocalToken = await localDataSource.hasToken();
      if (hasLocalToken) return const Right(true);

      // Priority 2: Check remote Firebase state if online
      final result = await remoteDataSource.isLoggedIn();
      return Right(result);
    } on ServerException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await remoteDataSource.requestPasswordReset(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordEntity>> verifyResetToken(String token) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await remoteDataSource.verifyResetToken(token);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String token, String newPassword) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await remoteDataSource.resetPassword(token, newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    }
  }
}
