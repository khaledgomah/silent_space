---
name: networking-api
description: 'Implement remote data calls, API integrations, and networking logic using Dio, Retrofit, or Firebase services.'
argument-hint: 'Optional API endpoint or service type'
---

# Networking and API Integrations

## When to Use
- When fetching data from a REST API or integrating Firebase Auth, Firestore, or Cloud Functions.
- When creating network requests with Dio or similar HTTP clients.

## Principles

### 1. Network Info Verification
- Always check connectivity status before making network requests using the `NetworkInfo` interface.
- Return a `NetworkFailure` if the device is offline.

### 2. Encapsulated API Clients
- Do not instantiate network clients directly inside data sources. Inject Dio, Firebase clients, or custom HTTP wrappers.

### 3. Handle Status Codes
- Catch client exceptions (e.g. `DioException`, `FirebaseAuthException`) and throw customized `ServerException` objects with relevant error codes and statuses.

---

## Step-by-Step Procedure

### 1. Implement API Call in Source
```dart
class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  final Dio dio;
  FeatureRemoteDataSourceImpl({required this.dio});

  @override
  Future<FeatureModel> fetchData() async {
    try {
      final response = await dio.get('/api/feature');
      return FeatureModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
```

### 2. Guard with NetworkInfo in Repository
```dart
  @override
  Future<Either<Failure, FeatureEntity>> getData() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await remoteDataSource.fetchData();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
```
