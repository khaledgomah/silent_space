import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';

/// Contract for session persistence operations.
abstract class SessionRepository {
  Future<Either<Failure, void>> saveSession(SessionEntity session);
  Future<Either<Failure, List<SessionEntity>>> getSessions();
  Future<Either<Failure, void>> clearSessions();
}
