---
name: testing-flutter
description: 'Write Flutter unit and widget tests following project patterns. Use for testing domain use cases, repository behavior, and presentation widgets with mocktail mocking. Includes BDD naming conventions and coverage strategies.'
argument-hint: 'File/component to test (e.g., AuthRepository, LoginPage, TimerCubit)'
---

# Flutter Testing Strategy

## When to Use
- Adding unit tests for domain use cases and repositories
- Adding widget tests for pages and complex UI components
- Verifying state changes in Cubits
- Mocking external dependencies (repos, data sources, Cubits)

## Testing Pyramid

```
      / \  Widget Tests (Presentation UI)
     / _ \ ---
    / ___ \  Unit Tests (Domain + Data)
   /_______\ ---
   Integration Tests (E2E)
```

**Coverage Target**: ≥ 70% for domain and data layers

## Test Structure

```
test/
├── features/
│   └── {feature}/
│       ├── domain/
│       │   └── usecases/
│       │       └── {usecase}_test.dart
│       ├── data/
│       │   ├── models/
│       │   │   └── {model}_test.dart
│       │   └── repositories/
│       │       └── {repository}_impl_test.dart
│       └── presentation/
│           ├── cubit/
│           │   └── {cubit}_test.dart
│           └── pages/
│               └── {page}_test.dart
├── fixtures/
│   └── {feature}_fixtures.dart
└── helpers/
    └── test_helpers.dart
```

## BDD Naming Convention

```dart
// Pattern: testWhen_ShouldExpectWhat

void main() {
  test('signIn_WhenCredentialsValid_ReturnsUserEntity', () { ... });
  test('signIn_WhenNetworkError_ReturnsNetworkFailure', () { ... });
  test('saveSession_WhenHiveError_ReturnsCacheFailure', () { ... });
}
```

## Step-by-Step Procedure

### 1. **Unit Test: Use Case**

Create `test/features/{feature}/domain/usecases/{usecase}_test.dart`:

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/{feature}/domain/entities/{entity}.dart';
import 'package:silent_space/features/{feature}/domain/repositories/{feature}_repository.dart';
import 'package:silent_space/features/{feature}/domain/usecases/get_{feature}s_usecase.dart';

// Mock the repository
class Mock{Feature}Repository extends Mock implements {Feature}Repository {}

void main() {
  late GetNotificationsUseCase useCase;
  late Mock{Feature}Repository mockRepository;

  setUp(() {
    mockRepository = Mock{Feature}Repository();
    useCase = GetNotificationsUseCase(mockRepository);
  });

  group('GetNotificationsUseCase', () {
    final tNotifications = [
      const NotificationEntity(
        id: '1',
        title: 'Test Notification',
        message: 'This is a test',
        createdAt: '2026-03-27',
        isRead: false,
      ),
    ];

    test('getNotifications_WhenSuccessful_ReturnsNotificationList', () async {
      // Arrange
      when(() => mockRepository.getNotifications())
          .thenAnswer((_) async => Right(tNotifications));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, Right(tNotifications));
      verify(() => mockRepository.getNotifications()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('getNotifications_WhenRepositoryFails_ReturnsFailure', () async {
      // Arrange
      when(() => mockRepository.getNotifications())
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(
        result,
        const Left(ServerFailure(message: 'Error')),
      );
    });
  });
}
```

### 2. **Unit Test: Repository Implementation**

Create `test/features/{feature}/data/repositories/{feature}_repository_impl_test.dart`:

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/features/{feature}/data/implements/{feature}_repository_impl.dart';
import 'package:silent_space/features/{feature}/data/models/{entity}_model.dart';
import 'package:silent_space/features/{feature}/data/sources/{feature}_local_data_source.dart';
import 'package:silent_space/features/{feature}/data/sources/{feature}_remote_data_source.dart';

class Mock{Feature}RemoteDataSource extends Mock
    implements {Feature}RemoteDataSource {}

class Mock{Feature}LocalDataSource extends Mock
    implements {Feature}LocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late {Feature}RepositoryImpl repository;
  late Mock{Feature}RemoteDataSource mockRemoteDataSource;
  late Mock{Feature}LocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = Mock{Feature}RemoteDataSource();
    mockLocalDataSource = Mock{Feature}LocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = {Feature}RepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('{Feature}RepositoryImpl', () {
    final tNotificationModel = NotificationModel(
      id: '1',
      title: 'Test',
      message: 'Message',
      createdAt: DateTime(2026, 3, 27),
      isRead: false,
    );

    test('getNotifications_WhenConnected_ReturnsRemoteData', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getNotifications())
          .thenAnswer((_) async => [tNotificationModel]);
      when(() => mockLocalDataSource.cacheNotifications([tNotificationModel]))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.getNotifications();

      // Assert
      expect(result, Right([tNotificationModel.toEntity()]));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getNotifications()).called(1);
      verify(
        () => mockLocalDataSource.cacheNotifications([tNotificationModel]),
      ).called(1);
    });

    test('getNotifications_WhenOffline_ReturnsCachedData', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedNotifications())
          .thenAnswer((_) async => [tNotificationModel]);

      // Act
      final result = await repository.getNotifications();

      // Assert
      expect(result, Right([tNotificationModel.toEntity()]));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyNever(() => mockRemoteDataSource.getNotifications());
    });

    test('getNotifications_WhenServerError_ReturnsServerFailure', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getNotifications())
          .thenThrow(ServerException(message: 'Server error'));

      // Act
      final result = await repository.getNotifications();

      // Assert
      expect(
        result,
        const Left(ServerFailure(message: 'Server error')),
      );
    });
  });
}
```

### 3. **Unit Test: Cubit**

Create `test/features/{feature}/presentation/cubit/{feature}_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/{feature}/domain/entities/{entity}.dart';
import 'package:silent_space/features/{feature}/domain/usecases/get_{feature}s_usecase.dart';
import 'package:silent_space/features/{feature}/presentation/cubit/{feature}_cubit.dart';

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

void main() {
  late NotificationCubit cubit;
  late MockGetNotificationsUseCase mockGetNotificationsUseCase;

  setUp(() {
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
    cubit = NotificationCubit(
      getNotificationsUseCase: mockGetNotificationsUseCase,
    );
  });

  tearDown(() => cubit.close());

  group('NotificationCubit', () {
    final tNotifications = [
      const NotificationEntity(
        id: '1',
        title: 'Test',
        message: 'Message',
        createdAt: '2026-03-27',
        isRead: false,
      ),
    ];

    blocTest<NotificationCubit, NotificationState>(
      'loadNotifications_WhenSuccessful_EmitsLoadingThenLoaded',
      build: () {
        when(() => mockGetNotificationsUseCase(NoParams()))
            .thenAnswer((_) async => Right(tNotifications));
        return cubit;
      },
      act: (cubit) => cubit.loadNotifications(),
      expect: () => [
        const NotificationLoading(),
        NotificationLoaded(notifications: tNotifications),
      ],
      verify: (_) {
        verify(() => mockGetNotificationsUseCase(NoParams())).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'loadNotifications_WhenEmpty_EmitsLoadingThenEmpty',
      build: () {
        when(() => mockGetNotificationsUseCase(NoParams()))
            .thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.loadNotifications(),
      expect: () => [
        const NotificationLoading(),
        const NotificationEmpty(),
      ],
    );

    blocTest<NotificationCubit, NotificationState>(
      'loadNotifications_WhenError_EmitsLoadingThenError',
      build: () {
        when(() => mockGetNotificationsUseCase(NoParams()))
            .thenAnswer(
              (_) async =>
                  const Left(ServerFailure(message: 'Backend error')),
            );
        return cubit;
      },
      act: (cubit) => cubit.loadNotifications(),
      expect: () => [
        const NotificationLoading(),
        const NotificationError(message: 'Backend error'),
      ],
    );
  });
}
```

### 4. **Widget Test: Page**

Create `test/features/{feature}/presentation/pages/{feature}_page_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/features/{feature}/domain/entities/{entity}.dart';
import 'package:silent_space/features/{feature}/presentation/cubit/{feature}_cubit.dart';
import 'package:silent_space/features/{feature}/presentation/pages/{feature}_page.dart';

class MockNotificationCubit extends Mock implements NotificationCubit {
  @override
  Stream<NotificationState> get stream => Stream.value(state);

  @override
  NotificationState get state => const NotificationInitial();
}

void main() {
  late MockNotificationCubit mockCubit;

  setUp(() {
    mockCubit = MockNotificationCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<NotificationCubit>.value(
        value: mockCubit,
        child: const NotificationPage(),
      ),
    );
  }

  group('NotificationPage', () {
    testWidgets('showsLoadingIndicator_WhenStateIsLoading', (tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(const NotificationLoading());
      when(() => mockCubit.stream)
          .thenAnswer((_) => Stream.value(const NotificationLoading()));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displaysList_WhenStateIsLoaded', (tester) async {
      // Arrange
      final tNotifications = [
        const NotificationEntity(
          id: '1',
          title: 'Test',
          message: 'Message',
          createdAt: '2026-03-27',
          isRead: false,
        ),
      ];
      when(() => mockCubit.state)
          .thenReturn(NotificationLoaded(notifications: tNotifications));
      when(() => mockCubit.stream)
          .thenAnswer(
            (_) =>
                Stream.value(NotificationLoaded(notifications: tNotifications)),
          );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('Message'), findsOneWidget);
    });

    testWidgets('showsEmptyState_WhenNoNotifications', (tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(const NotificationEmpty());
      when(() => mockCubit.stream)
          .thenAnswer((_) => Stream.value(const NotificationEmpty()));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('No notifications'), findsOneWidget);
    });

    testWidgets('showsErrorMessage_WhenStateIsError', (tester) async {
      // Arrange
      const tErrorMessage = 'Failed to load';
      when(() => mockCubit.state)
          .thenReturn(const NotificationError(message: tErrorMessage));
      when(() => mockCubit.stream).thenAnswer(
        (_) => Stream.value(
          const NotificationError(message: tErrorMessage),
        ),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text(tErrorMessage), findsOneWidget);
    });
  });
}
```

## Dependencies Required

Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
  bloc_test: ^9.0.0
```

## Running Tests

```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Specific file
flutter test test/features/auth/data/repositories/auth_repository_impl_test.dart

# Verbose output
flutter test -v

# Watch mode (if supported)
flutter test --watch
```

## Coverage Goals

| Layer | Target | Approach |
|-------|--------|----------|
| **Domain (Use Cases)** | 100% | Test happy path + all failure cases |
| **Data (Repositories)** | 100% | Test all branches (online, offline, errors) |
| **Presentation (Cubits)** | 90%+ | Use `bloc_test` for state emission |
| **Presentation (Widgets)** | 70%+ | Test critical paths, state changes |

## Testing Best Practices

✅ **Arrange-Act-Assert** — Clear test structure
✅ **Mock external dependencies** — Isolate the code under test
✅ **Test behavior, not implementation** — Focus on public contracts
✅ **One assertion per test** (or related group) — Easy debugging
✅ **Descriptive test names** — Tests document expected behavior
✅ **Use fixtures for test data** — Reusable test entities in `test/fixtures/`
✅ **Test error cases** — Don't just test happy path

## Common Pitfalls

❌ **Testing implementation details** — Break when internals change
❌ **Over-mocking** — If you mock the whole class, what are you testing?
❌ **Flaky tests** — Avoid time-dependent assertions
❌ **Not testing error paths** — Use cases must handle failures gracefully
❌ **Copy-paste test code** — Extract shared mocks to `test_helpers.dart`
