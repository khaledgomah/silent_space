import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';

class RequestPasswordResetUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  RequestPasswordResetUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String email) {
    return repository.requestPasswordReset(email);
  }
}
