import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
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
      // Save locally first for offline access
      await localDataSource.saveSession(model);
      
      try {
        // Try saving remotely to Firestore
        await remoteDataSource.saveSession(model);
      } catch (e) {
        // Flag local session as needing sync and return success
        debugPrint('Failed to save to Firestore. Marking as unsynced: $e');
        await localDataSource.saveSession(model.copyWith(needsSync: true));
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FocusSession>>> getSessionsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    try {
      // Try to fetch from remote
      final models = await remoteDataSource.getSessionsByDateRange(userId, start, end);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      debugPrint('Firestore load failed, falling back to Hive cache: $e');
      try {
        final localSessions = await localDataSource.getSessions();
        final filtered = localSessions
            .where((s) => s.userId == userId &&
                s.startTime.millisecondsSinceEpoch >= start.millisecondsSinceEpoch &&
                s.startTime.millisecondsSinceEpoch <= end.millisecondsSinceEpoch)
            .map((m) => m.toEntity())
            .toList();
        return Right(filtered);
      } catch (cacheError) {
        return Left(CacheFailure(message: 'Failed to retrieve local sessions: $cacheError'));
      }
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

  @override
  Future<Either<Failure, void>> syncOfflineSessions(String userId) async {
    try {
      final localSessions = await localDataSource.getSessions();
      final unsynced = localSessions.where((s) => s.userId == userId && s.needsSync).toList();
      
      for (final model in unsynced) {
        try {
          await remoteDataSource.saveSession(model);
          await localDataSource.saveSession(model.copyWith(needsSync: false));
        } catch (e) {
          debugPrint('Sync failed for session ${model.id}: $e');
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed during offline sync: $e'));
    }
  }
}
