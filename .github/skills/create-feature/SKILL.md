---
name: create-feature
description: 'Create a new feature with complete Clean Architecture layers (domain → data → presentation), including entities, use cases, repositories, data sources, Cubits, and pages. Use for building new features like notifications, reports, advanced settings.'
argument-hint: 'Feature name (e.g., notifications, focus-goals, session-analytics)'
---

# Create a New Feature

## When to Use
- Building a new feature (e.g., notifications, analytics, goals)
- Extending existing features with major new functionality
- Ensuring Clean Architecture is properly applied from the start

## Architecture Overview

```
features/{feature_name}/
├── domain/                       # Pure Dart, no external dependencies
│   ├── entities/                # Domain models
│   │   └── {entity}.dart        # e.g., NotificationEntity
│   ├── repositories/            # Abstract contracts
│   │   └── {feature}_repository.dart
│   └── usecases/               # Business logic
│       ├── get_{feature}s_usecase.dart
│       └── {action}_{feature}_usecase.dart
├── data/                        # Implementation layer
│   ├── models/                 # JSON serialization
│   │   └── {entity}_model.dart
│   ├── sources/                # Remote + Local data access
│   │   ├── {feature}_remote_data_source.dart
│   │   └── {feature}_local_data_source.dart
│   └── implements/             # Repository orchestration
│       └── {feature}_repository_impl.dart
└── presentation/               # UI Layer
    ├── cubit/                 # State management
    │   ├── {feature}_cubit.dart
    │   └── {feature}_state.dart
    ├── pages/                 # Routable screens
    │   └── {feature}_page.dart
    └── widgets/               # Reusable UI components
        ├── {feature}_item.dart
        └── {feature}_list.dart
```

## Step-by-Step Procedure

### 1. **Define Domain Layer** (Pure Dart)

Create `features/{feature}/domain/entities/{entity}.dart`:
```dart
import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  @override
  List<Object?> get props => [id, title, message, createdAt, isRead];
}
```

Create abstract repository in `features/{feature}/domain/repositories/{feature}_repository.dart`:
```dart
import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/{feature}/domain/entities/{entity}.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAsRead(String notificationId);
}
```

Create use cases in `features/{feature}/domain/usecases/`:
```dart
import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/{feature}/domain/repositories/{feature}_repository.dart';

class GetNotificationsUseCase extends UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) {
    return repository.getNotifications();
  }
}
```

### 2. **Implement Data Layer**

Create model in `features/{feature}/data/models/{entity}_model.dart`:
```dart
import 'package:silent_space/features/{feature}/domain/entities/{entity}.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.createdAt,
    required super.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
  };

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    title: title,
    message: message,
    createdAt: createdAt,
    isRead: isRead,
  );
}
```

Create data sources in `features/{feature}/data/sources/{feature}_{type}_data_source.dart`:
```dart
import 'package:silent_space/features/{feature}/data/models/{entity}_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
}

abstract class NotificationLocalDataSource {
  Future<void> cacheNotifications(List<NotificationModel> notifications);
  Future<List<NotificationModel>> getCachedNotifications();
}

// Implementations
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await dio.get('/notifications');
      return (response.data as List)
          .map((n) => NotificationModel.fromJson(n as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to fetch notifications');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await dio.patch('/notifications/$notificationId', data: {'isRead': true});
    } catch (e) {
      throw ServerException(message: 'Failed to mark as read');
    }
  }
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final HiveService hiveService;

  NotificationLocalDataSourceImpl({required this.hiveService});

  @override
  Future<void> cacheNotifications(List<NotificationModel> notifications) async {
    await hiveService.saveNotifications(notifications);
  }

  @override
  Future<List<NotificationModel>> getCachedNotifications() async {
    return hiveService.getNotifications();
  }
}
```

Create repository implementation in `features/{feature}/data/implements/{feature}_repository_impl.dart`:
```dart
import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/features/{feature}/data/models/{entity}_model.dart';
import 'package:silent_space/features/{feature}/data/sources/{feature}_{type}_data_source.dart';
import 'package:silent_space/features/{feature}/domain/repositories/{feature}_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    if (!await networkInfo.isConnected) {
      try {
        final cached = await localDataSource.getCachedNotifications();
        return Right(cached.map((m) => m.toEntity()).toList());
      } on CacheException {
        return const Left(CacheFailure());
      }
    }

    try {
      final notifications = await remoteDataSource.getNotifications();
      await localDataSource.cacheNotifications(notifications);
      return Right(notifications.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
```

### 3. **Create Presentation Layer**

Create Cubit in `features/{feature}/presentation/cubit/{feature}_cubit.dart`:
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/{feature}/domain/entities/{entity}.dart';
import 'package:silent_space/features/{feature}/domain/usecases/get_notifications_usecase.dart';

part '{feature}_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationCubit({required this.getNotificationsUseCase})
      : super(const NotificationInitial());

  Future<void> loadNotifications() async {
    emit(const NotificationLoading());
    final result = await getNotificationsUseCase(NoParams());
    
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (notifications) {
        if (notifications.isEmpty) {
          emit(const NotificationEmpty());
        } else {
          emit(NotificationLoaded(notifications: notifications));
        }
      },
    );
  }
}
```

Create states in `features/{feature}/presentation/cubit/{feature}_state.dart`:
```dart
part of '{feature}_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationLoaded({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}

class NotificationEmpty extends NotificationState {
  const NotificationEmpty();
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object?> get props => [message];
}
```

Create page in `features/{feature}/presentation/pages/{feature}_page.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/features/{feature}/presentation/cubit/{feature}_cubit.dart';
import 'package:silent_space/features/{feature}/presentation/widgets/{feature}_list.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationCubit>()..loadNotifications(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              return NotificationList(notifications: state.notifications);
            } else if (state is NotificationEmpty) {
              return const Center(child: Text('No notifications'));
            } else if (state is NotificationError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

### 4. **Register Dependencies in Service Locator**

Update `lib/core/utils/service_locator.dart`:
```dart
// Data Layer
getIt.registerLazySingleton<NotificationRemoteDataSource>(
  () => NotificationRemoteDataSourceImpl(dio: getIt<Dio>()),
);

getIt.registerLazySingleton<NotificationLocalDataSource>(
  () => NotificationLocalDataSourceImpl(hiveService: getIt<HiveService>()),
);

// Repository
getIt.registerLazySingleton<NotificationRepository>(
  () => NotificationRepositoryImpl(
    remoteDataSource: getIt<NotificationRemoteDataSource>(),
    localDataSource: getIt<NotificationLocalDataSource>(),
    networkInfo: getIt<NetworkInfo>(),
  ),
);

// Use Cases
getIt.registerLazySingleton<GetNotificationsUseCase>(
  () => GetNotificationsUseCase(getIt<NotificationRepository>()),
);

// Presentation
getIt.registerFactory<NotificationCubit>(
  () => NotificationCubit(
    getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
  ),
);
```

### 5. **Write Tests**

Create unit tests for domain layer:
```dart
// test/features/{feature}/domain/usecases/get_{feature}s_usecase_test.dart
void main() {
  late GetNotificationsUseCase useCase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    useCase = GetNotificationsUseCase(mockRepository);
  });

  test('getNotifications_WhenSuccessful_ReturnsNotificationList', () async {
    // Arrange
    final tNotifications = [
      const NotificationEntity(id: '1', title: 'Test', message: 'msg', ...),
    ];
    when(() => mockRepository.getNotifications())
        .thenAnswer((_) async => Right(tNotifications));

    // Act
    final result = await useCase(NoParams());

    // Assert
    expect(result, Right(tNotifications));
    verify(() => mockRepository.getNotifications()).called(1);
  });
}
```

Create widget tests for presentation layer:
```dart
// test/features/{feature}/presentation/pages/{feature}_page_test.dart
void main() {
  late MockNotificationCubit mockCubit;

  setUp(() {
    mockCubit = MockNotificationCubit();
  });

  testWidgets('NotificationPage_ShowsLoading_WhenStateIsLoading', (tester) async {
    when(() => mockCubit.state).thenReturn(const NotificationLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<NotificationCubit>.value(
          value: mockCubit,
          child: const NotificationPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

## Validation Checklist

- [ ] Domain layer has **zero** external dependencies
- [ ] Repository is abstract in domain, concrete in data
- [ ] All exceptions mapped to typed `Failure` objects
- [ ] Repository methods return `Either<Failure, T>`
- [ ] States are immutable and extend `Equatable`
- [ ] Cubit emits new states, never mutates fields
- [ ] Presentation imports domain, never data sources directly
- [ ] All dependencies registered in `service_locator.dart`
- [ ] Unit tests cover domain + data layers
- [ ] Widget tests verify UI state changes
- [ ] No hardcoded strings — use `easy_localization` where applicable
- [ ] No hardcoded colors — use `AppTheme` or `Theme.of(context)`

## Common Pitfalls

❌ **Importing data sources in presentation** — Always use repository contracts
❌ **Mutating Cubit fields** — Emit new states instead  
❌ **Skipping tests** — Unit + widget tests are mandatory
❌ **Monolithic widgets** — Extract complex UI into separate `StatelessWidget` classes
❌ **Not registering dependencies** — Every use case and Cubit must be in `service_locator.dart`

## Tips

✅ **Start with domain** — Define entities and use cases before implementation
✅ **Use Either<Failure, T>** — Consistent error handling across layers
✅ **Test behavior, not implementation** — Focus on what, not how
✅ **Keep widgets small** — Max nesting depth of 3 in `build()`
✅ **Use `const` constructors** — Aggressively optimize widget rebuilds
