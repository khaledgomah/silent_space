import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/errors/failure_mapper.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/verify_reset_token_usecase.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final RequestPasswordResetUseCase requestPasswordResetUseCase;
  final VerifyResetTokenUseCase verifyResetTokenUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordCubit({
    required this.requestPasswordResetUseCase,
    required this.verifyResetTokenUseCase,
    required this.resetPasswordUseCase,
  }) : super(ForgotPasswordInitial());

  Future<void> requestPasswordReset(String email) async {
    emit(ForgotPasswordLoading());
    final result = await requestPasswordResetUseCase(email);
    result.fold(
      (failure) => emit(ForgotPasswordFailure(error: FailureMapper.map(failure))),
      (_) => emit(ForgotPasswordRequestSuccess(
          message: AppStrings.passwordResetLinkSent.tr())),
    );
  }

  Future<void> verifyResetToken(String token) async {
    emit(ForgotPasswordLoading());
    final result = await verifyResetTokenUseCase(token);
    result.fold(
      (failure) => emit(ForgotPasswordFailure(error: FailureMapper.map(failure))),
      (entity) => emit(ForgotPasswordVerifySuccess(entity: entity)),
    );
  }

  Future<void> resetPassword(String token, String newPassword) async {
    emit(ForgotPasswordLoading());
    final result = await resetPasswordUseCase(
        ResetPasswordParams(token: token, newPassword: newPassword));
    result.fold(
      (failure) => emit(ForgotPasswordFailure(error: FailureMapper.map(failure))),
      (_) => emit(ForgotPasswordResetSuccess(
          message: AppStrings.passwordResetSuccess.tr())),
    );
  }
}
