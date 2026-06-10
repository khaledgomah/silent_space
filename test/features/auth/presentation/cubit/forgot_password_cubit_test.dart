import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:silent_space/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/verify_reset_token_usecase.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_state.dart';

class MockRequestPasswordResetUseCase extends Mock implements RequestPasswordResetUseCase {}
class MockVerifyResetTokenUseCase extends Mock implements VerifyResetTokenUseCase {}
class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class FakeResetPasswordParams extends Fake implements ResetPasswordParams {}

void main() {
  late ForgotPasswordCubit cubit;
  late MockRequestPasswordResetUseCase mockRequestPasswordResetUseCase;
  late MockVerifyResetTokenUseCase mockVerifyResetTokenUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;

  setUpAll(() {
    registerFallbackValue(FakeResetPasswordParams());
  });

  setUp(() {
    mockRequestPasswordResetUseCase = MockRequestPasswordResetUseCase();
    mockVerifyResetTokenUseCase = MockVerifyResetTokenUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();

    cubit = ForgotPasswordCubit(
      requestPasswordResetUseCase: mockRequestPasswordResetUseCase,
      verifyResetTokenUseCase: mockVerifyResetTokenUseCase,
      resetPasswordUseCase: mockResetPasswordUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ForgotPasswordCubit', () {
    test('initial state should be ForgotPasswordInitial', () {
      expect(cubit.state, equals(ForgotPasswordInitial()));
    });

    group('requestPasswordReset', () {
      test('should emit [ForgotPasswordLoading, ForgotPasswordRequestSuccess] when successful', () async {
        when(() => mockRequestPasswordResetUseCase(any()))
            .thenAnswer((_) async => const Right(null));

        final expected = [
          ForgotPasswordLoading(),
          isA<ForgotPasswordRequestSuccess>(),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.requestPasswordReset('test@example.com');
      });

      test('should emit [ForgotPasswordLoading, ForgotPasswordFailure] when failure occurs', () async {
        when(() => mockRequestPasswordResetUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Email not found')));

        final expected = [
          ForgotPasswordLoading(),
          const ForgotPasswordFailure(error: 'Email not found'),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.requestPasswordReset('test@example.com');
      });
    });

    group('verifyResetToken', () {
      const tEntity = ForgotPasswordEntity(email: 'test@example.com', token: 'token');

      test('should emit [ForgotPasswordLoading, ForgotPasswordVerifySuccess] when successful', () async {
        when(() => mockVerifyResetTokenUseCase(any()))
            .thenAnswer((_) async => const Right(tEntity));

        final expected = [
          ForgotPasswordLoading(),
          const ForgotPasswordVerifySuccess(entity: tEntity),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.verifyResetToken('token');
      });

      test('should emit [ForgotPasswordLoading, ForgotPasswordFailure] when failure occurs', () async {
        when(() => mockVerifyResetTokenUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Invalid token')));

        final expected = [
          ForgotPasswordLoading(),
          const ForgotPasswordFailure(error: 'Invalid token'),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.verifyResetToken('token');
      });
    });

    group('resetPassword', () {
      test('should emit [ForgotPasswordLoading, ForgotPasswordResetSuccess] when successful', () async {
        when(() => mockResetPasswordUseCase(any()))
            .thenAnswer((_) async => const Right(null));

        final expected = [
          ForgotPasswordLoading(),
          isA<ForgotPasswordResetSuccess>(),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.resetPassword('token', 'newPassword');
      });

      test('should emit [ForgotPasswordLoading, ForgotPasswordFailure] when failure occurs', () async {
        when(() => mockResetPasswordUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Weak password')));

        final expected = [
          ForgotPasswordLoading(),
          const ForgotPasswordFailure(error: 'Weak password'),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.resetPassword('token', 'newPassword');
      });
    });
  });
}
