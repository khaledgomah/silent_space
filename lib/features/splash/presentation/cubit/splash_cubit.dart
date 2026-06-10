import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/splash/presentation/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._isLoggedInUseCase, this._authCubit) : super(SplashInitial());
  final IsLoggedInUseCase _isLoggedInUseCase;
  final AuthCubit _authCubit;

  Future<void> checkAuth() async {
    final results = await Future.wait([
      Future.delayed(const Duration(milliseconds: 1500)),
      _isLoggedInUseCase(NoParams()),
    ]);

    final result = results[1] as Either<Failure, bool>;

    result.fold(
      (failure) => emit(SplashError(failure.message)),
      (isLoggedIn) async {
        if (isLoggedIn) {
          await _authCubit.checkAuthStatus();
          emit(Authenticated());
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }
}
