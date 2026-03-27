import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/verify_reset_token_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late VerifyResetTokenUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = VerifyResetTokenUseCase(mockRepository);
  });

  group('VerifyResetTokenUseCase', () {
    const tToken = 'some_token';
    const tEntity =
        ForgotPasswordEntity(email: 'test@example.com', token: tToken);

    test('verifyResetToken_WhenSuccessful_ReturnsEntity', () async {
      when(() => mockRepository.verifyResetToken(any()))
          .thenAnswer((_) async => const Right(tEntity));

      final result = await useCase(tToken);

      expect(result, const Right(tEntity));
      verify(() => mockRepository.verifyResetToken(tToken)).called(1);
    });

    test('verifyResetToken_WhenFailed_ReturnsFailure', () async {
      when(() => mockRepository.verifyResetToken(any()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));

      final result = await useCase(tToken);

      expect(result, const Left(ServerFailure(message: 'Error')));
    });
  });
}
