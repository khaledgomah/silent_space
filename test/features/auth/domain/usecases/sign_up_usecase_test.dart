import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_up_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignUpUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpUseCase(mockRepository);
  });

  const tEmail = 'eve.holt@reqres.in';
  const tPassword = 'pistol';
  const tParams = SignUpParams(email: tEmail, password: tPassword);
  const tUser = UserEntity(id: '4', email: tEmail, token: 'QpwL5tke4Pnpja7X4');

  group('SignUpUseCase', () {
    test('should return UserEntity when registration is successful', () async {
      // arrange
      when(() => mockRepository.registerWithEmailAndPassword(
          email: tEmail,
          password: tPassword)).thenAnswer((_) async => const Right(tUser));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Right(tUser));
      verify(() => mockRepository.registerWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when registration fails', () async {
      // arrange
      const tFailure =
          ServerFailure(message: 'Missing email or password', statusCode: 400);
      when(() => mockRepository.registerWithEmailAndPassword(
          email: tEmail,
          password: tPassword)).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.registerWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
    });
  });
}
