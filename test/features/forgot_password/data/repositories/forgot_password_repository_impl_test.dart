import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/features/forgot_password/data/implements/forgot_password_repository_impl.dart';
import 'package:silent_space/features/forgot_password/data/sources/forgot_password_remote_data_source.dart';

class MockForgotPasswordRemoteDataSource extends Mock
    implements ForgotPasswordRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ForgotPasswordRepositoryImpl repository;
  late MockForgotPasswordRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockForgotPasswordRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ForgotPasswordRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('ForgotPasswordRepositoryImpl', () {
    const tEmail = 'test@example.com';

    test('requestPasswordReset_WhenConnectedAndSuccessful_ReturnsRightNull',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.requestPasswordReset(any()))
          .thenAnswer((_) async => Future.value());

      final result = await repository.requestPasswordReset(tEmail);

      expect(result, const Right(null));
    });

    test('requestPasswordReset_WhenConnectedAndFails_ReturnsServerFailure',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.requestPasswordReset(any()))
          .thenThrow(const ServerException(message: 'Error'));

      final result = await repository.requestPasswordReset(tEmail);

      expect(result, const Left(ServerFailure(message: 'Error')));
    });

    test('requestPasswordReset_WhenDisconnected_ReturnsNetworkFailure',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.requestPasswordReset(tEmail);

      expect(result,
          const Left(NetworkFailure(message: 'No internet connection.')));
    });
  });
}
