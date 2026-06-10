import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:silent_space/features/splash/presentation/cubit/splash_state.dart';

class MockIsLoggedInUseCase extends Mock implements IsLoggedInUseCase {}

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late SplashCubit cubit;
  late MockIsLoggedInUseCase mockIsLoggedInUseCase;
  late MockAuthCubit mockAuthCubit;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockIsLoggedInUseCase = MockIsLoggedInUseCase();
    mockAuthCubit = MockAuthCubit();
    cubit = SplashCubit(mockIsLoggedInUseCase, mockAuthCubit);
  });

  tearDown(() {
    cubit.close();
  });

  group('SplashCubit', () {
    test('initial state should be SplashInitial', () {
      expect(cubit.state, equals(SplashInitial()));
    });

    test('checkAuth - should emit Authenticated when user is logged in', () async {
      // arrange
      when(() => mockIsLoggedInUseCase(any())).thenAnswer((_) async => const Right(true));
      when(() => mockAuthCubit.checkAuthStatus()).thenAnswer((_) async => {});

      // assert later
      final expected = [
        Authenticated(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      // act
      await cubit.checkAuth();

      // verify
      verify(() => mockIsLoggedInUseCase(any())).called(1);
      verify(() => mockAuthCubit.checkAuthStatus()).called(1);
    });

    test('checkAuth - should emit Unauthenticated when user is not logged in', () async {
      // arrange
      when(() => mockIsLoggedInUseCase(any())).thenAnswer((_) async => const Right(false));

      // assert later
      final expected = [
        Unauthenticated(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      // act
      await cubit.checkAuth();

      // verify
      verify(() => mockIsLoggedInUseCase(any())).called(1);
      verifyZeroInteractions(mockAuthCubit);
    });

    test('checkAuth - should emit SplashError when check fails', () async {
      // arrange
      when(() => mockIsLoggedInUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Auth Error')));

      // assert later
      final expected = [
        const SplashError('Auth Error'),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      // act
      await cubit.checkAuth();

      // verify
      verify(() => mockIsLoggedInUseCase(any())).called(1);
      verifyZeroInteractions(mockAuthCubit);
    });
  });
}
