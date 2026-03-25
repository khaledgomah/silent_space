import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/session/data/models/session_model.dart';
import 'package:silent_space/features/session/data/sources/session_local_data_source.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionLocalDataSource localDataSource;

  const SessionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveSession(SessionEntity session) async {
    try {
      await localDataSource.saveSession(SessionModel.fromEntity(session));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<SessionEntity>>> getSessions() async {
    try {
      final models = await localDataSource.getSessions();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearSessions() async {
    try {
      await localDataSource.clearSessions();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
