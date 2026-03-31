import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({
    required this.token,
    required this.newPassword,
  });
  final String token;
  final String newPassword;

  @override
  List<Object?> get props => [token, newPassword];
}

class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  ResetPasswordUseCase(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return repository.resetPassword(params.token, params.newPassword);
  }
}
