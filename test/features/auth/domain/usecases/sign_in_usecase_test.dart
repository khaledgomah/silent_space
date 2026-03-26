import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCase(mockRepository);
  });

  const tEmail = 'eve.holt@reqres.in';
  const tPassword = 'cityslicka';
  const tParams = SignInParams(email: tEmail, password: tPassword);
  const tUser = UserEntity(id: '4', email: tEmail, token: 'QpwL5tke4Pnpja7X4');

  group('SignInUseCase', () {
    test('should return UserEntity when sign in is successful', () async {
      // arrange
      when(() => mockRepository.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => const Right(tUser));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Right(tUser));
      verify(() => mockRepository.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when sign in fails', () async {
      // arrange
      const tFailure = ServerFailure(message: 'user not found', statusCode: 400);
      when(() => mockRepository.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .called(1);
    });

    test('should return NetworkFailure when offline', () async {
      // arrange
      const tFailure = NetworkFailure();
      when(() => mockRepository.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Left(tFailure));
    });
  });
}
