import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';

class SaveSessionUseCase extends UseCase<void, SessionEntity> {
  final SessionRepository repository;

  SaveSessionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SessionEntity params) {
    return repository.saveSession(params);
  }
}
