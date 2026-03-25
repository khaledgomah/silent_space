import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/features/auth/data/implements/auth_repository_impl.dart';
import 'package:silent_space/features/auth/data/models/user_model.dart';
import 'package:silent_space/features/auth/data/sources/auth_local_data_source.dart';
import 'package:silent_space/features/auth/data/sources/auth_remote_data_source.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tEmail = 'eve.holt@reqres.in';
  const tPassword = 'cityslicka';
  const tUserModel = UserModel(
    id: 4,
    email: tEmail,
    token: 'QpwL5tke4Pnpja7X4',
  );

  group('signIn', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.cacheToken(any()))
          .thenAnswer((_) async {});

      // act
      await repository.signIn(email: tEmail, password: tPassword);

      // assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    test('should return NetworkFailure when device is offline', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result =
          await repository.signIn(email: tEmail, password: tPassword);

      // assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should have returned Left'),
      );
    });

    test(
        'should return UserEntity and cache token when remote call is successful',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signIn(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.cacheToken(any()))
          .thenAnswer((_) async {});

      // act
      final result =
          await repository.signIn(email: tEmail, password: tPassword);

      // assert
      expect(result, const Right(tUserModel));
      verify(() => mockLocalDataSource.cacheToken('QpwL5tke4Pnpja7X4'))
          .called(1);
    });

    test('should return ServerFailure when remote call throws ServerException',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signIn(
            email: tEmail,
            password: tPassword,
          )).thenThrow(
        const ServerException(message: 'user not found', statusCode: 400),
      );

      // act
      final result =
          await repository.signIn(email: tEmail, password: tPassword);

      // assert
      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'user not found');
        },
        (_) => fail('Should have returned Left'),
      );
    });
  });

  group('signOut', () {
    test('should clear token and return Right(null)', () async {
      // arrange
      when(() => mockLocalDataSource.clearToken()).thenAnswer((_) async {});

      // act
      final result = await repository.signOut();

      // assert
      expect(result, const Right(null));
      verify(() => mockLocalDataSource.clearToken()).called(1);
    });

    test('should return CacheFailure when clearing token fails', () async {
      // arrange
      when(() => mockLocalDataSource.clearToken())
          .thenThrow(const CacheException(message: 'Failed to clear token'));

      // act
      final result = await repository.signOut();

      // assert
      expect(result, isA<Left>());
    });
  });

  group('isLoggedIn', () {
    test('should return true when token exists', () async {
      // arrange
      when(() => mockLocalDataSource.hasToken())
          .thenAnswer((_) async => true);

      // act
      final result = await repository.isLoggedIn();

      // assert
      expect(result, true);
    });

    test('should return false when no token', () async {
      // arrange
      when(() => mockLocalDataSource.hasToken())
          .thenAnswer((_) async => false);

      // act
      final result = await repository.isLoggedIn();

      // assert
      expect(result, false);
    });
  });
}
