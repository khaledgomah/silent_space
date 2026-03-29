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
    id: '4',
    email: tEmail,
    token: 'QpwL5tke4Pnpja7X4',
  );

  group('signIn', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.cacheToken(any())).thenAnswer((_) async {});

      // act
      await repository.signInWithEmailAndPassword(email: tEmail, password: tPassword);

      // assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    test('should return NetworkFailure when device is offline', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result =
          await repository.signInWithEmailAndPassword(email: tEmail, password: tPassword);

      // assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should have returned Left'),
      );
    });

    test('should return UserEntity and cache token when remote call is successful', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.cacheToken(any())).thenAnswer((_) async {});

      // act
      final result =
          await repository.signInWithEmailAndPassword(email: tEmail, password: tPassword);

      // assert
      expect(result, Right(tUserModel.toEntity()));
      verify(() => mockLocalDataSource.cacheToken(tUserModel.token!)).called(1);
    });

    test('should return AuthFailure when remote call throws ServerException', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).thenThrow(
        const ServerException(message: 'user not found', statusCode: 400),
      );

      // act
      final result =
          await repository.signInWithEmailAndPassword(email: tEmail, password: tPassword);

      // assert
      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'user not found');
        },
        (_) => fail('Should have returned Left'),
      );
    });
  });

  group('signOut', () {
    test('should clear token and return Right(null)', () async {
      // arrange
      when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async {});
      when(() => mockLocalDataSource.clearToken()).thenAnswer((_) async {});

      // act
      final result = await repository.signOut();

      // assert
      expect(result, const Right(null));
      verify(() => mockRemoteDataSource.signOut()).called(1);
      verify(() => mockLocalDataSource.clearToken()).called(1);
    });

    test('should return AuthFailure when remote call throws ServerException', () async {
      // arrange
      when(() => mockRemoteDataSource.signOut())
          .thenThrow(const ServerException(message: 'Sign out failed'));

      // act
      final result = await repository.signOut();

      // assert
      expect(result, isA<Left>());
    });
  });

  group('isLoggedIn', () {
    test('should return Right(true) when token exists', () async {
      // arrange
      when(() => mockRemoteDataSource.isLoggedIn()).thenAnswer((_) async => true);

      // act
      final result = await repository.isLoggedIn();

      // assert
      expect(result, const Right(true));
    });

    test('should return Right(false) when no token', () async {
      // arrange
      when(() => mockRemoteDataSource.isLoggedIn()).thenAnswer((_) async => false);

      // act
      final result = await repository.isLoggedIn();

      // assert
      expect(result, const Right(false));
    });
  });

  group('deleteAccount', () {
    test('should call remote deleteAccount and clear local token', () async {
      // arrange
      when(() => mockRemoteDataSource.deleteAccount()).thenAnswer((_) async {});
      when(() => mockLocalDataSource.clearToken()).thenAnswer((_) async {});

      // act
      final result = await repository.deleteAccount();

      // assert
      expect(result, const Right(null));
      verify(() => mockRemoteDataSource.deleteAccount()).called(1);
      verify(() => mockLocalDataSource.clearToken()).called(1);
    });

    test('should return AuthFailure when remote deleteAccount fails', () async {
      // arrange
      when(() => mockRemoteDataSource.deleteAccount())
          .thenThrow(const ServerException(message: 'Delete failed'));

      // act
      final result = await repository.deleteAccount();

      // assert
      expect(result, isA<Left>());
    });
  });
}
