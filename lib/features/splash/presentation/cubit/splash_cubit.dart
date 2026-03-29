import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:silent_space/features/splash/presentation/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final IsLoggedInUseCase _isLoggedInUseCase;

  SplashCubit(this._isLoggedInUseCase) : super(SplashInitial());

  Future<void> checkAuth() async {
    // Ensuring a minimum 2-second delay for the splash animation
    await Future.delayed(const Duration(seconds: 2));
    
    final result = await _isLoggedInUseCase(NoParams());

    result.fold(
      (failure) => emit(Unauthenticated()),
      (isLoggedIn) {
        if (isLoggedIn) {
          emit(Authenticated());
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }
}
