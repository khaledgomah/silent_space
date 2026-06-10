---
name: dependency-injection
description: 'Register or review dependency injections in the service locator, ensuring correct lifecycle configurations.'
argument-hint: 'Optional class/service name to register'
---

# Dependency Injection

## When to Use
- When adding a new service, database client, data source, repository, use case, or bloc/cubit that must be accessed within the app.
- When configuring test mocks.

## Principles

### 1. Unified Registration
- Register all dependencies in [service_locator.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/service_locator.dart).
- Never instantiate dependencies directly inside pages, widgets, or use cases.

### 2. Dependency Ordering (Bottom-Up)
Dependencies must be registered in this order:
1. **External Services**: (`SharedPreferences`, `Firebase`, `Dio`, `AudioPlayer`, etc.)
2. **Local & Remote Data Sources**: Depends on external services.
3. **Repository Implementations**: Depends on local/remote data sources.
4. **Use Cases**: Depends on Repository contracts.
5. **Blocs / Cubits**: Depends on Use Cases.

### 3. Lifecycle Selection
- **Singletons (`registerLazySingleton`)**: Use for classes that hold global/shared state (data sources, repositories, use cases).
- **Factories (`registerFactory`)**: Use for blocs and cubits since they are screen-specific and need a fresh instance created when a user enters a screen.

---

## Step-by-Step Procedure

### 1. Register a Cubit
```dart
sl.registerFactory(() => FeatureCubit(
      useCase: sl(),
    ));
```

### 2. Register a Use Case
```dart
sl.registerLazySingleton(() => FeatureUseCase(sl()));
```

### 3. Register a Repository
```dart
sl.registerLazySingleton<FeatureRepository>(() => FeatureRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ));
```

### 4. Verify in Widget Tree
Verify that cubits are accessed using BlocProvider:
```dart
BlocProvider(
  create: (context) => getIt<FeatureCubit>(),
  child: const FeaturePage(),
)
```
