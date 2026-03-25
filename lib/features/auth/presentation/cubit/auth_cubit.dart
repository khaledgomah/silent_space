import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:silent_space/core/usecases/usecase.dart';
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

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _signInUseCase(
      SignInParams(email: email, password: password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
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
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());

    final result = await _signOutUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthLoggedOut()),
    );
  }
}
