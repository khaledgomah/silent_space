---
name: caching-persistence
description: 'Implement or review caching and local storage policies using SharedPreferences, Hive, or other local storage options.'
argument-hint: 'Optional cache key or model to persist'
---

# Caching and Persistence

## When to Use
- When caching remote responses to enable offline-first capabilities.
- When managing persistent user settings or local session data.
- When storing keys, tokens, or lightweight status values using `SharedPreferences`.

## Principles

### 1. Abstract Storage Contracts
- Do not make direct calls to `SharedPreferences` or database libraries in data repositories.
- Define a data source interface in the data layer (e.g., `AuthLocalDataSource` or `SessionLocalDataSource`) that abstracts the persistent implementation.

### 2. Error Mapping
- Always wrap database/storage read/write operations in `try-catch` blocks in repository implementations.
- Map any local database errors to a subclass of `Failure` (e.g., `CacheFailure`).

---

## Step-by-Step Procedure

### 1. Define local contract
In `/data/sources/` define the interface:
```dart
abstract class FeatureLocalDataSource {
  Future<void> cacheData(FeatureModel model);
  Future<FeatureModel> getLastData();
}
```

### 2. Implement the local data source
Using `SharedPreferences`, `Hive`, or SQLite:
```dart
class FeatureLocalDataSourceImpl implements FeatureLocalDataSource {
  final SharedPreferences sharedPreferences;
  FeatureLocalDataSourceImpl({required this.sharedPreferences});
  // ... implementation using sharedPreferences
}
```

### 3. Integrate with Repository
Call the local data source inside repository implementation, wrapping with exception handling:
```dart
try {
  await localDataSource.cacheData(model);
} catch (e) {
  throw CacheException();
}
```

### 4. Register Dependency
Register the data source and database dependencies in [service_locator.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/service_locator.dart).
