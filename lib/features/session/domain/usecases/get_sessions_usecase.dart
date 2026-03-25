import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';

class GetSessionsUseCase extends UseCase<List<SessionEntity>, NoParams> {
  final SessionRepository repository;

  GetSessionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SessionEntity>>> call(NoParams params) {
    return repository.getSessions();
  }
}
