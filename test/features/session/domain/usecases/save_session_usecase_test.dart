import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';
import 'package:silent_space/features/session/domain/usecases/save_session_usecase.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late SaveSessionUseCase useCase;
  late MockSessionRepository mockRepository;

  setUp(() {
    mockRepository = MockSessionRepository();
    useCase = SaveSessionUseCase(mockRepository);
  });

  final tSession = FocusSession(
    id: '1',
    userId: 'user123',
    startTime: DateTime(2026, 3, 24, 10, 0),
    endTime: DateTime(2026, 3, 24, 10, 25),
    durationInSeconds: 25 * 60,
    category: 'Focus',
  );

  group('SaveSessionUseCase', () {
    test('should save session successfully', () async {
      // arrange
      when(() => mockRepository.saveSession(tSession))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(tSession);

      // assert
      expect(result, const Right(null));
      verify(() => mockRepository.saveSession(tSession)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when saving fails', () async {
      // arrange
      const tFailure = ServerFailure(message: 'Failed to save session');
      when(() => mockRepository.saveSession(tSession))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tSession);

      // assert
      expect(result, const Left(tFailure));
    });
  });
}
