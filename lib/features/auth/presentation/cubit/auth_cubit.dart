import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:silent_space/core/errors/failure_mapper.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_up_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  AuthCubit({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        super(AuthInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _signInUseCase(
      SignInParams(email: email, password: password),
    );

    result.fold(
      (failure) => emit(AuthError(message: FailureMapper.map(failure))),
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
      (failure) => emit(AuthError(message: FailureMapper.map(failure))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());

    final result = await _signOutUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: FailureMapper.map(failure))),
      (_) => emit(AuthLoggedOut()),
    );
  }

  Future<void> deleteAccount() async {
    emit(AuthLoading());

    final result = await _deleteAccountUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: FailureMapper.map(failure))),
      (_) => emit(AuthLoggedOut()),
    );
  }
}
