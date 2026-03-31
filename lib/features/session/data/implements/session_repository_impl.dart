import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/session/data/models/session_model.dart';
import 'package:silent_space/features/session/data/sources/session_local_data_source.dart';
import 'package:silent_space/features/session/data/sources/session_remote_data_source.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });
  final SessionLocalDataSource localDataSource;
  final SessionRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, void>> saveSession(FocusSession session) async {
    try {
      final model = SessionModel.fromEntity(session);
      // Save locally for offline access
      await localDataSource.saveSession(model);
      // Save remotely to Firestore
      await remoteDataSource.saveSession(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FocusSession>>> getSessionsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    try {
      // Fetch from remote for accurate range filtering
      final models = await remoteDataSource.getSessionsByDateRange(userId, start, end);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearSessions() async {
    try {
      await localDataSource.clearSessions();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to clear local sessions: $e'));
    }
  }
}
