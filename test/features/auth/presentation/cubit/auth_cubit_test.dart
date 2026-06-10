import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}
class MockSignUpUseCase extends Mock implements SignUpUseCase {}
class MockSignOutUseCase extends Mock implements SignOutUseCase {}
class MockDeleteAccountUseCase extends Mock implements DeleteAccountUseCase {}
class MockSignInWithGoogleUseCase extends Mock implements SignInWithGoogleUseCase {}
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class FakeSignInParams extends Fake implements SignInParams {}
class FakeSignUpParams extends Fake implements SignUpParams {}

void main() {
  late AuthCubit cubit;
  late MockSignInUseCase mockSignInUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late MockDeleteAccountUseCase mockDeleteAccountUseCase;
  late MockSignInWithGoogleUseCase mockSignInWithGoogleUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;

  setUpAll(() {
    registerFallbackValue(FakeSignInParams());
    registerFallbackValue(FakeSignUpParams());
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    mockDeleteAccountUseCase = MockDeleteAccountUseCase();
    mockSignInWithGoogleUseCase = MockSignInWithGoogleUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();

    cubit = AuthCubit(
      signInUseCase: mockSignInUseCase,
      signUpUseCase: mockSignUpUseCase,
      signOutUseCase: mockSignOutUseCase,
      deleteAccountUseCase: mockDeleteAccountUseCase,
      signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  const tUser = UserEntity(id: '123', email: 'test@example.com', token: 'token');

  group('AuthCubit', () {
    test('initial state should be AuthInitial', () {
      expect(cubit.state, equals(AuthInitial()));
    });

    group('signIn', () {
      test('should emit [AuthLoading, AuthSuccess] when successful', () async {
        when(() => mockSignInUseCase(any()))
            .thenAnswer((_) async => const Right(tUser));

        final expected = [
          AuthLoading(),
          const AuthSuccess(user: tUser),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.signIn(email: 'test@example.com', password: 'password');
      });

      test('should emit [AuthLoading, AuthError] when failure occurs', () async {
        when(() => mockSignInUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Invalid Credentials')));

        final expected = [
          AuthLoading(),
          const AuthError(message: 'Invalid Credentials'),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.signIn(email: 'test@example.com', password: 'password');
      });
    });

    group('signUp', () {
      test('should emit [AuthLoading, AuthSuccess] when successful', () async {
        when(() => mockSignUpUseCase(any()))
            .thenAnswer((_) async => const Right(tUser));

        final expected = [
          AuthLoading(),
          const AuthSuccess(user: tUser),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.signUp(email: 'test@example.com', password: 'password');
      });

      test('should emit [AuthLoading, AuthError] when failure occurs', () async {
        when(() => mockSignUpUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Server Error')));

        final expected = [
          AuthLoading(),
          const AuthError(message: 'Server Error'),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.signUp(email: 'test@example.com', password: 'password');
      });
    });

    group('signOut', () {
      test('should emit [AuthLoading, AuthLoggedOut] when successful', () async {
        when(() => mockSignOutUseCase(any()))
            .thenAnswer((_) async => const Right(null));

        final expected = [
          AuthLoading(),
          AuthLoggedOut(),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.signOut();
      });

      test('should emit [AuthLoading, AuthError] when failure occurs', () async {
        when(() => mockSignOutUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Sign Out Error')));

        final expected = [
          AuthLoading(),
          const AuthError(message: 'Sign Out Error'),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.signOut();
      });
    });

    group('deleteAccount', () {
      test('should emit [AuthLoading, AuthLoggedOut] when successful', () async {
        when(() => mockDeleteAccountUseCase(any()))
            .thenAnswer((_) async => const Right(null));

        final expected = [
          AuthLoading(),
          AuthLoggedOut(),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.deleteAccount();
      });

      test('should emit [AuthLoading, AuthError] when failure occurs', () async {
        when(() => mockDeleteAccountUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Delete Error')));

        final expected = [
          AuthLoading(),
          const AuthError(message: 'Delete Error'),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.deleteAccount();
      });
    });

    group('signInWithGoogle', () {
      test('should emit [AuthLoading, AuthSuccess] when successful', () async {
        when(() => mockSignInWithGoogleUseCase(any()))
            .thenAnswer((_) async => const Right(tUser));

        final expected = [
          AuthLoading(),
          const AuthSuccess(user: tUser),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.signInWithGoogle();
      });

      test('should emit [AuthLoading, AuthError] when failure occurs', () async {
        when(() => mockSignInWithGoogleUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Google Sign In Cancelled')));

        final expected = [
          AuthLoading(),
          const AuthError(message: 'Google Sign In Cancelled'),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.signInWithGoogle();
      });
    });

    group('checkAuthStatus', () {
      test('should emit [AuthLoading, AuthSuccess] when user is logged in', () async {
        when(() => mockGetCurrentUserUseCase(any()))
            .thenAnswer((_) async => const Right(tUser));

        final expected = [
          AuthLoading(),
          const AuthSuccess(user: tUser),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.checkAuthStatus();
      });

      test('should emit [AuthLoading, AuthLoggedOut] when user is not logged in', () async {
        when(() => mockGetCurrentUserUseCase(any()))
            .thenAnswer((_) async => const Right(null));

        final expected = [
          AuthLoading(),
          AuthLoggedOut(),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.checkAuthStatus();
      });

      test('should emit [AuthLoading, AuthError] when check fails', () async {
        when(() => mockGetCurrentUserUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Database Error')));

        final expected = [
          AuthLoading(),
          const AuthError(message: 'Database Error'),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.checkAuthStatus();
      });
    });
  });
}
