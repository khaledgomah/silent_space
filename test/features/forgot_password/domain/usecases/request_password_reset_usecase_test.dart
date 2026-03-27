import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:silent_space/features/forgot_password/domain/usecases/request_password_reset_usecase.dart';

class MockForgotPasswordRepository extends Mock implements ForgotPasswordRepository {}

void main() {
  late RequestPasswordResetUseCase useCase;
  late MockForgotPasswordRepository mockRepository;

  setUp(() {
    mockRepository = MockForgotPasswordRepository();
    useCase = RequestPasswordResetUseCase(mockRepository);
  });

  group('RequestPasswordResetUseCase', () {
    const tEmail = 'test@example.com';

    test('requestPasswordReset_WhenSuccessful_ReturnsRightNull', () async {
      when(() => mockRepository.requestPasswordReset(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await useCase(tEmail);

      expect(result, const Right(null));
      verify(() => mockRepository.requestPasswordReset(tEmail)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('requestPasswordReset_WhenFailed_ReturnsFailure', () async {
      when(() => mockRepository.requestPasswordReset(any()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));

      final result = await useCase(tEmail);

      expect(result, const Left(ServerFailure(message: 'Error')));
    });
  });
}