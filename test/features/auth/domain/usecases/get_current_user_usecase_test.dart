import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/get_current_user_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetCurrentUserUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUserUseCase(mockAuthRepository);
  });

  const tUser = UserEntity(id: '123', email: 'test@example.com', token: 'token');

  test('should get user from repository when user is logged in', () async {
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => const Right(tUser));

    final result = await usecase(NoParams());

    expect(result, const Right(tUser));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should get null from repository when no user is logged in', () async {
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(NoParams());

    expect(result, const Right(null));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
