import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/reset_password_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ResetPasswordUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ResetPasswordUseCase(mockRepository);
  });

  group('ResetPasswordUseCase', () {
    const tParams =
        ResetPasswordParams(token: 'token', newPassword: 'password123');

    test('resetPassword_WhenSuccessful_ReturnsRightNull', () async {
      when(() => mockRepository.resetPassword(any(), any()))
          .thenAnswer((_) async => const Right(null));

      final result = await useCase(tParams);

      expect(result, const Right(null));
      verify(() =>
              mockRepository.resetPassword(tParams.token, tParams.newPassword))
          .called(1);
    });

    test('resetPassword_WhenFailed_ReturnsFailure', () async {
      when(() => mockRepository.resetPassword(any(), any()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));

      final result = await useCase(tParams);

      expect(result, const Left(ServerFailure(message: 'Error')));
    });
  });
}
