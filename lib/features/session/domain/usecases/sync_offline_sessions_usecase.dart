import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';

class SyncOfflineSessionsUseCase extends UseCase<void, String> {
  SyncOfflineSessionsUseCase(this.repository);
  final SessionRepository repository;

  @override
  Future<Either<Failure, void>> call(String userId) {
    return repository.syncOfflineSessions(userId);
  }
}
