---
name: error-handling
description: 'Implement error mapping and error handling strategies across the domain, data, and presentation layers.'
argument-hint: 'Optional class or exception type to handle'
---

# Error Handling

## When to Use
- When making network API requests, local database queries, or native device actions that could throw exceptions.
- When transforming technical raw exceptions into user-friendly error messages.

## Principles

### 1. Layers & Failure Contracts
- **Data Source Layer**: Throws raw exceptions (e.g. `ServerException`, `CacheException`, `FirebaseAuthException`).
- **Repository Implementation Layer**: Catches exceptions and returns an `Either<Failure, T>`.
- **Domain Layer**: Operates with `Either<Failure, T>` and propagates it upwards.
- **Presentation Layer**: Consumes `Either<Failure, T>` and translates it into UI error states using `FailureMapper`.

### 2. User-Friendly Failures
Ensure `Failure` objects contain clear, non-technical messages suitable for display to users.

---

## Step-by-Step Procedure

### 1. Define Custom Failure
If a new type of failure is required, define it in `lib/core/errors/failures.dart`:
```dart
class FeatureFailure extends Failure {
  const FeatureFailure({required super.message, super.statusCode});
}
```

### 2. Implement Try-Catch in Repository
Map exceptions to failure types:
```dart
  @override
  Future<Either<Failure, Model>> getModelData() async {
    try {
      final data = await remoteDataSource.getData();
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
```

### 3. Handle Failure in Cubit
Map failure messages in cubits using `FailureMapper`:
```dart
result.fold(
  (failure) => emit(FeatureError(message: FailureMapper.map(failure))),
  (data) => emit(FeatureLoaded(data: data)),
);
```
