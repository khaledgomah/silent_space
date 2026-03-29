import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/is_logged_in_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late IsLoggedInUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = IsLoggedInUseCase(mockAuthRepository);
  });

  test('should get bool from the repository', () async {
    // arrange
    when(() => mockAuthRepository.isLoggedIn())
        .thenAnswer((_) async => const Right(true));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right(true));
    verify(() => mockAuthRepository.isLoggedIn());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
