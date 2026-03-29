import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_up_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthCubit({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        super(AuthInitial());

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) return AppStrings.noConnection.tr();

    if (failure is AuthFailure || failure is ServerFailure) {
      // Map common Firebase/Server error codes to translations
      final code = failure.errorCode;

      if (code == 'invalid-credential' ||
          code == 'wrong-password' ||
          code == 'user-not-found') {
        return AppStrings.invalidCredentials.tr();
      }

      if (code == 'invalid-email') {
        return AppStrings.invalidEmail.tr();
      }

      if (code == 'email-already-in-use') {
        return AppStrings.emailAlreadyInUse.tr();
      }

      if (code == 'weak-password') {
        return AppStrings.weakPassword.tr();
      }

      if (failure.statusCode == 400 &&
          (failure.message.isEmpty || failure.message == 'null')) {
        return AppStrings.invalidCredentials.tr();
      }

      return failure.message.isNotEmpty && failure.message != 'null'
          ? failure.message
          : AppStrings.unknownError.tr();
    }

    return AppStrings.unknownError.tr();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _signInUseCase(
      SignInParams(email: email, password: password),
    );

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _signUpUseCase(
      SignUpParams(email: email, password: password),
    );

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());

    final result = await _signOutUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(AuthLoggedOut()),
    );
  }
}
