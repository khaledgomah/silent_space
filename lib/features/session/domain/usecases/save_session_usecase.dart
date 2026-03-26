import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';

class SaveSessionUseCase extends UseCase<void, FocusSession> {
  final SessionRepository repository;

  SaveSessionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(FocusSession params) {
    return repository.saveSession(params);
  }
}
