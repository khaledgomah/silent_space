import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';

/// Contract for session persistence operations.
abstract class SessionRepository {
  Future<Either<Failure, void>> saveSession(FocusSession session);
  Future<Either<Failure, List<FocusSession>>> getSessionsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  );
  Future<Either<Failure, void>> clearSessions();
}
