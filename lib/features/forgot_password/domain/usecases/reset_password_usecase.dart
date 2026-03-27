import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/forgot_password/domain/repositories/forgot_password_repository.dart';

class ResetPasswordParams extends Equatable {
  final String token;
  final String newPassword;

  const ResetPasswordParams({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}

class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  final ForgotPasswordRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return repository.resetPassword(params.token, params.newPassword);
  }
}
