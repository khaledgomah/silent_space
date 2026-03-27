---
name: networking-api
description: 'Configure Dio networking, handle interceptors, manage API requests/responses, and implement network error handling. Use for setting up API clients, adding auth headers, retrying failed requests, and managing timeouts.'
argument-hint: 'API or endpoint (e.g., firebase-auth, rest-api, real-time-data)'
---

# Networking & API Integration

## When to Use
- Setting up new API endpoints
- Adding authentication headers to requests
- Handling network errors and retries
- Configuring request/response interceptors
- Managing API timeouts
- Logging network traffic

## File Structure

```
lib/core/network/
├── dio_client.dart          # Dio configuration + interceptors
├── network_info.dart        # Check internet connectivity
└── api_constants.dart       # Base URLs, endpoints
```

## Step-by-Step Setup

### 1. **Configure Dio Client**

Create `lib/core/network/dio_client.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/security/secure_storage_service.dart';

class DioClient {
  final SecureStorageService _secureStorage;
  late final Dio dio;

  DioClient({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage {
    // Base configuration
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      _authInterceptor(),
      _unauthorizedInterceptor(),
      _errorInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[Dio] $obj'),
      ),
    ]);
  }

  /// Add JWT token to requests
  QueuedInterceptorsWrapper _authInterceptor() {
    return QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    );
  }

  /// Handle 401 Unauthorized (token expired, etc.)
  QueuedInterceptorsWrapper _unauthorizedInterceptor() {
    return QueuedInterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, try to refresh
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry original request
            return handler.resolve(await _retry(error.requestOptions));
          } else {
            // Refresh failed, redirect to login
            throw AuthException(
              message: 'Session expired',
              code: 'TOKEN_EXPIRED',
            );
          }
        }
        return handler.next(error);
      },
    );
  }

  /// Map API errors to exceptions
  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          throw TimeoutException(message: 'Request timeout');
        } else if (error.type == DioExceptionType.unknown) {
          throw NetworkException(
            message: error.message ?? 'Network error',
            originalError: error.error,
          );
        } else if (error.response != null) {
          throw ServerException(
            message: error.response?.data['message'] ?? 'Server error',
            statusCode: error.response?.statusCode,
            originalError: error,
          );
        }
        return handler.next(error);
      },
    );
  }

  /// Refresh expired token
  Future<bool> _refreshToken() async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        options: Options(
          headers: {'Authorization': null},  // Don't include current token
        ),
      );

      final newToken = response.data['token'];
      await _secureStorage.saveToken(newToken);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retry a failed request
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
```

### 2. **Check Internet Connectivity**

Create `lib/core/network/network_info.dart`:

```dart
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectionStatus;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);
  }

  @override
  Stream<bool> get connectionStatus {
    return connectivity.onConnectivityChanged
        .map((result) =>
            result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi) ||
            result.contains(ConnectivityResult.ethernet))
        .distinct();  // Only emit when changed
  }
}
```

### 3. **Define API Constants**

Create `lib/core/network/api_constants.dart`:

```dart
class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.example.com/v1';
  static const String firebaseUrl = 'https://firestore.googleapis.com/v1';

  // Endpoints
  static const String authSignIn = '/auth/signin';
  static const String authSignUp = '/auth/signup';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';

  static const String users = '/users';
  static String userById(String id) => '/users/$id';

  static const String sessions = '/sessions';
  static String sessionById(String id) => '/sessions/$id';

  // Timeouts
  static const int connectTimeout = 30;  // seconds
  static const int receiveTimeout = 30;  // seconds
  static const int sendTimeout = 30;     // seconds

  // Retry strategy
  static const int maxRetries = 3;
  static const int retryDelayMs = 1000;  // Initial delay
}
```

### 4. **Register in Service Locator**

Update `lib/core/utils/service_locator.dart`:

```dart
// External services
getIt.registerLazySingleton<SecureStorageService>(
  () => const SecureStorageService(),
);

getIt.registerLazySingleton<Connectivity>(
  () => Connectivity(),
);

getIt.registerLazySingleton<Dio>(
  () => DioClient(secureStorage: getIt<SecureStorageService>()).dio,
);

getIt.registerLazySingleton<NetworkInfo>(
  () => NetworkInfoImpl(connectivity: getIt<Connectivity>()),
);
```

## API Integration Patterns

### Pattern 1: REST API Integration

```dart
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
  Future<UserModel> updateUser(String id, UserModel user);
  Future<void> deleteUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> getUser(String id) async {
    try {
      final response = await dio.get('/users/$id');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException(
          message: 'User not found',
          statusCode: 404,
        );
      }
      throw ServerException(message: e.message ?? 'Error');
    }
  }

  @override
  Future<UserModel> updateUser(String id, UserModel user) async {
    try {
      final response = await dio.put(
        '/users/$id',
        data: user.toJson(),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Error');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await dio.delete('/users/$id');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Error');
    }
  }
}
```

### Pattern 2: Retry with Exponential Backoff

```dart
class RetryInterceptor extends QueuedInterceptorsWrapper {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, this.maxRetries = 3});

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // Retryable errors: timeout, network, 5xx
    final retryable = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.unknown ||
        err.response?.statusCode == 500 ||
        err.response?.statusCode == 503;

    if (!retryable) return handler.next(err);

    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Exponential backoff: 1s, 2s, 4s, 8s...
        await Future.delayed(Duration(seconds: 1 << retryCount));

        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(method: err.requestOptions.method),
        );

        return handler.resolve(response);
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) rethrow;
      }
    }
  }
}
```

### Pattern 3: Check Connectivity Before Requests

```dart
class OfflineFirstDataSource {
  final Dio dio;
  final NetworkInfo networkInfo;

  OfflineFirstDataSource({
    required this.dio,
    required this.networkInfo,
  });

  Future<List<SessionModel>> getSessions() async {
    // Check if online
    if (!await networkInfo.isConnected) {
      throw NetworkException(
        message: 'No internet connection',
      );
    }

    try {
      final response = await dio.get('/sessions');
      return (response.data as List)
          .map((s) => SessionModel.fromJson(s))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Error');
    }
  }
}
```

### Pattern 4: Stream Real-Time Updates

```dart
abstract class NotificationRemoteDataSource {
  Stream<List<NotificationModel>> getNotificationsStream();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  @override
  Stream<List<NotificationModel>> getNotificationsStream() async* {
    try {
      // Use Server-Sent Events (SSE) or WebSocket
      final response = await dio.get(
        '/notifications/stream',
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      // Parse stream
      await for (final line in response.data.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (line.isEmpty) continue;
        
        final data = jsonDecode(line);
        yield (data['notifications'] as List)
            .map((n) => NotificationModel.fromJson(n))
            .toList();
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Stream error');
    }
  }
}
```

## Testing Network Requests

```dart
void main() {
  late MockDio mockDio;
  late UserRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = UserRemoteDataSourceImpl(dio: mockDio);
  });

  test('getUser_WhenSuccess_ReturnsUserModel', () async {
    // Arrange
    final tUserModel = UserModel(id: '1', name: 'Ahmed', email: 'test@test.com');
    when(() => mockDio.get('/users/1'))
        .thenAnswer((_) async => Response(
          data: tUserModel.toJson(),
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/1'),
        ));

    // Act
    final result = await dataSource.getUser('1');

    // Assert
    expect(result, equals(tUserModel));
  });

  test('getUser_WhenNotFound_ThrowsServerException', () async {
    // Arrange
    when(() => mockDio.get('/users/1'))
        .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/users/1'),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/users/1'),
          ),
        ));

    // Act & Assert
    expect(
      () => dataSource.getUser('1'),
      throwsA(isA<ServerException>()),
    );
  });
}
```

## Networking Checklist

- [ ] Dio client configured with base URL
- [ ] Auth interceptor adds JWT tokens
- [ ] Unauthorized interceptor handles 401 responses
- [ ] Error interceptor maps Dio exceptions to custom exceptions
- [ ] Network connectivity checked before requests
- [ ] Timeouts configured appropriately
- [ ] Retry logic with exponential backoff
- [ ] Logging enabled for debugging
- [ ] Request/response models validated
- [ ] Tests mock Dio responses

## Best Practices

✅ **Check connectivity first** — Avoid timeouts with offline checks
✅ **Implement retry logic** — Transient errors (timeout, 5xx) are retryable
✅ **Use interceptors** — Centralize auth, logging, error handling
✅ **Cache tokens securely** — Use `flutter_secure_storage`
✅ **Handle 401 gracefully** — Refresh token or redirect to login
✅ **Log for debugging** — But don't expose sensitive data
✅ **Validate responses** — Check content-type, parse JSON carefully
✅ **Use distinct timeouts** — Different for connectivity, receive, send

## Anti-Patterns

❌ **Hardcoded base URLs** — Use environment variables or constants
❌ **No timeout configuration** — Requests can hang indefinitely
❌ **Silently ignoring errors** — Always propagate or log
❌ **Storing tokens in plain text** — Use secure storage
❌ **No retry logic** — Transient failures will fail permanently
❌ **Mixing business logic and networking** — Keep in data sources
