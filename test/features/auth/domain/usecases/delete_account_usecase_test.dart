import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/delete_account_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late DeleteAccountUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = DeleteAccountUseCase(mockAuthRepository);
  });

  test('deleteAccount_WhenRepositorySucceeds_ReturnsRightVoid', () async {
    when(() => mockAuthRepository.deleteAccount()).thenAnswer((_) async => const Right(null));

    final result = await useCase(NoParams());

    expect(result, const Right(null));
    verify(() => mockAuthRepository.deleteAccount()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('deleteAccount_WhenRepositoryFails_ReturnsAuthFailure', () async {
    const failure = AuthFailure(message: 'Could not delete account');
    when(() => mockAuthRepository.deleteAccount()).thenAnswer((_) async => const Left(failure));

    final result = await useCase(NoParams());

    expect(result, const Left(failure));
    verify(() => mockAuthRepository.deleteAccount()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
