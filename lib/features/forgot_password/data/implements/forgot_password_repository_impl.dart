import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/features/forgot_password/data/sources/forgot_password_remote_data_source.dart';
import 'package:silent_space/features/forgot_password/domain/entities/forgot_password_entity.dart';
import 'package:silent_space/features/forgot_password/domain/repositories/forgot_password_repository.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ForgotPasswordRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.requestPasswordReset(email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return const Left(ServerFailure(message: 'Unexpected error occurred.'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordEntity>> verifyResetToken(String token) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.verifyResetToken(token);
        return Right(result.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return const Left(ServerFailure(message: 'Unexpected error occurred.'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String token, String newPassword) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(token, newPassword);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return const Left(ServerFailure(message: 'Unexpected error occurred.'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
  }
}
