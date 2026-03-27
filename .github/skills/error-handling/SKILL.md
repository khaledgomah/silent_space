---
name: error-handling
description: 'Map exceptions to typed Failure objects and handle errors gracefully. Use for exception design, failure type hierarchy, error propagation, and ensuring no exceptions leak to UI.'
argument-hint: 'Layer being implemented (domain, data, presentation)'
---

# Error Handling & Exception Mapping

## When to Use
- Catching exceptions in data layers
- Designing new Failure types
- Mapping domain-specific errors
- Propagating errors up through layers
- Handling errors in Cubits/UI

## Architecture Principle

**Errors MUST be transformed at layer boundaries:**

```
Data Layer (Remote API)
    ↓ (catch exception)
    ↓ map to Failure
Data Layer (Repository)
    ↓ (Either<Failure, T>)
Use Case
    ↓ (Either<Failure, T>)
Cubit (state emission)
    ↓ (ErrorState with message)
UI (error display)
```

**Critical Rule:** Exceptions MUST NOT reach presentation layer.

## File Structure

```
lib/core/errors/
├── failures.dart        # Failure base class + types
├── exceptions.dart      # Exception types by origin
└── error_mapper.dart    # (Optional) Mapping logic
```

## Step-by-Step Implementation

### 1. **Define Failure Types** (Domain-Agnostic)

Create `lib/core/errors/failures.dart`:

```dart
import 'package:equatable/equatable.dart';

/// Base class for all failures across the app
abstract class Failure extends Equatable {
  final String? message;

  const Failure({this.message});

  @override
  List<Object?> get props => [message];
}

// ── Network Failures ──
class NetworkFailure extends Failure {
  const NetworkFailure({String? message})
      : super(message: message ?? 'No internet connection');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({String? message})
      : super(message: message ?? 'Request timeout');
}

class ServerFailure extends Failure {
  const ServerFailure({String? message})
      : super(message: message ?? 'Server error');
}

// ── Authentication Failures ──
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String? message})
      : super(message: message ?? 'Unauthorized');
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({String? message})
      : super(message: message ?? 'Authentication failed');
}

// ── Cache/Local Storage Failures ──
class CacheFailure extends Failure {
  const CacheFailure({String? message})
      : super(message: message ?? 'Cache error');
}

class ValidationFailure extends Failure {
  const ValidationFailure({String? message})
      : super(message: message ?? 'Validation error');
}

// ── Generic Failures ──
class UnknownFailure extends Failure {
  const UnknownFailure({String? message})
      : super(message: message ?? 'Unknown error occurred');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({String? message})
      : super(message: message ?? 'Resource not found');
}

class ConflictFailure extends Failure {
  const ConflictFailure({String? message})
      : super(message: message ?? 'Conflict');
}

// Utility extension to get human-readable message
extension FailureMessage on Failure {
  String get displayMessage {
    return message ?? 'An error occurred';
  }
}
```

### 2. **Define Exception Types** (Layer-Specific)

Create `lib/core/errors/exceptions.dart`:

```dart
/// Exceptions represent the PROBLEM
/// Failures represent the RESPONSE to that problem

// ── Server Exceptions (from API) ──
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ServerException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ServerException: $message (Code: $statusCode)';
}

// ── Network Exceptions ──
class NetworkException implements Exception {
  final String message;
  final dynamic originalError;

  NetworkException({
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'NetworkException: $message';
}

class TimeoutException implements Exception {
  final String message;

  TimeoutException({this.message = 'Request timeout'});

  @override
  String toString() => 'TimeoutException: $message';
}

// ── Cache Exceptions (from Hive) ──
class CacheException implements Exception {
  final String message;
  final dynamic originalError;

  CacheException({
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'CacheException: $message';
}

// ── Authentication Exceptions (from Firebase) ──
class AuthException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AuthException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AuthException($code): $message';
}

// ── Validation Exceptions ──
class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  ValidationException({
    required this.message,
    this.fieldErrors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

// ── Generic Exception ──
class UnexpectedException implements Exception {
  final String message;
  final dynamic originalError;

  UnexpectedException({
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'UnexpectedException: $message';
}
```

### 3. **Map Exceptions in Remote Data Source**

Example: `lib/features/auth/data/sources/auth_remote_data_source.dart`

```dart
abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/signin',
        data: {'email': email, 'password': password},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException();
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Unknown error',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Dio can throw various exceptions
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException();
      } else if (e.type == DioExceptionType.unknown) {
        throw NetworkException(
          message: 'Network error: ${e.message}',
          originalError: e,
        );
      } else {
        throw ServerException(
          message: e.message ?? 'Server error',
          originalError: e,
        );
      }
    } on TimeoutException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(
        message: 'Unexpected error: $e',
        originalError: e,
      );
    }
  }
}
```

### 4. **Map Exceptions in Repository**

Example: `lib/features/auth/data/implements/auth_repository_impl.dart`

Repository is the BRIDGE — it converts exceptions to failures:

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
    // Check network first
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      // Call remote data source
      final user = await remoteDataSource.signIn(email, password);

      // Cache the user locally for offline access
      await localDataSource.cacheUser(user);

      // Return success
      return Right(user.toEntity());
    }
    // Map specific exceptions to failures
    on TimeoutException {
      return const Left(TimeoutFailure());
    }
    on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
    on ServerException catch (e) {
      // Handle specific status codes
      if (e.statusCode == 401) {
        return const Left(UnauthorizedFailure());
      } else if (e.statusCode == 404) {
        return const Left(NotFoundFailure());
      } else {
        return Left(ServerFailure(message: e.message));
      }
    }
    on AuthException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    }
    on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    }
    on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
    catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
```

### 5. **Handle Failures in Use Cases**

Use cases pass failures through unchanged:

```dart
class SignInUseCase extends UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) {
    // Use case just delegates to repository
    return repository.signIn(params.email, params.password);
  }
}
```

### 6. **Handle Failures in Cubits**

Cubits translate failures to user-friendly state:

```dart
class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;

  AuthCubit({required this.signInUseCase}) : super(const AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(const AuthLoading());

    final result = await signInUseCase(
      SignInParams(email: email, password: password),
    );

    result.fold(
      // Failure: Emit error state with user-readable message
      (failure) {
        final message = _mapFailureToMessage(failure);
        emit(AuthError(message: message));
      },
      // Success: Emit success state
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check and try again.';
    } else if (failure is TimeoutFailure) {
      return 'Request took too long. Please try again.';
    } else if (failure is UnauthorizedFailure) {
      return 'Invalid email or password.';
    } else if (failure is ServerFailure) {
      return failure.displayMessage;
    } else if (failure is CacheFailure) {
      return 'Local storage error. Please try again.';
    } else {
      return 'An unexpected error occurred.';
    }
  }
}
```

### 7. **Display Errors in UI**

Widgets show error messages from Cubit state:

```dart
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator();
        } else if (state is AuthError) {
          return Column(
            children: [
              const ErrorIcon(),
              SizedBox(height: 16),
              Text(state.message),  // User-friendly message
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _retryLogin(context),
                child: const Text('Retry'),
              ),
            ],
          );
        } else if (state is AuthSuccess) {
          return const HomePage();
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _retryLogin(BuildContext context) {
    context.read<AuthCubit>().signIn(email, password);
  }
}
```

## Error Handling Patterns

### Pattern 1: Retry Logic

```dart
class AuthCubit extends Cubit<AuthState> {
  int _retryCount = 0;
  static const int _maxRetries = 3;

  Future<void> signInWithRetry(String email, String password) async {
    emit(const AuthLoading());
    _retryCount = 0;
    
    while (_retryCount < _maxRetries) {
      final result = await signInUseCase(...);
      
      final canRetry = result.fold(
        (failure) => failure is NetworkFailure || failure is TimeoutFailure,
        (_) => false,
      );

      if (!canRetry) {
        result.fold(
          (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
          (user) => emit(AuthSuccess(user: user)),
        );
        return;
      }

      _retryCount++;
      if (_retryCount < _maxRetries) {
        await Future.delayed(Duration(seconds: _retryCount * 2));  // Exponential backoff
      }
    }

    emit(const AuthError(message: 'Failed after 3 retries'));
  }
}
```

### Pattern 2: Graceful Degradation (Offline-First)

```dart
@override
Future<Either<Failure, List<SessionEntity>>> getSessions() async {
  // Try remote first
  if (await networkInfo.isConnected) {
    try {
      final sessions = await remoteDataSource.getSessions();
      await localDataSource.cacheSessions(sessions);
      return Right(sessions.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // Fallback to local cache
  try {
    final cachedSessions = await localDataSource.getCachedSessions();
    return Right(cachedSessions.map((m) => m.toEntity()).toList());
  } on CacheException {
    return const Left(CacheFailure());
  }
}
```

### Pattern 3: Custom Error Context

```dart
// Add context to failures for better debugging
class ServerFailure extends Failure {
  final String endpoint;
  final int? statusCode;

  const ServerFailure({
    String? message,
    required this.endpoint,
    this.statusCode,
  }) : super(message: message);

  @override
  List<Object?> get props => [message, endpoint, statusCode];
}

// Usage in data source
catch (e) {
  throw ServerException(
    message: 'Sign in failed',
    statusCode: 401,
    originalError: e,
  );
}

// In repository
catch (e as ServerException) {
  return Left(ServerFailure(
    message: e.message,
    endpoint: '/auth/signin',
    statusCode: e.statusCode,
  ));
}
```

## Validation Checklist

Before merging:

- [ ] All exceptions caught at data layer
- [ ] All exceptions mapped to Failure objects
- [ ] No exceptions thrown from use cases
- [ ] Repository methods return `Either<Failure, T>`
- [ ] Cubit handles all failure types
- [ ] Error messages are user-friendly
- [ ] Error states displayed in UI
- [ ] No exception stack traces shown to users
- [ ] Specific failures for different error cases

## Best Practices

✅ **Catch specific exceptions** — Not generic `catch(e)`
✅ **Map at layer boundaries** — Use cases shouldn't catch exceptions
✅ **Name failures descriptively** — Clear intent from class name
✅ **Include context** — What failed, why, where
✅ **User-friendly messages** — "Network error" not "SocketException: Connection refused"
✅ **Retry strategies** — Transient errors (timeout, network) are retryable
✅ **Log errors** — For debugging, but don't expose to users
✅ **Test error paths** — As important as happy paths

## Anti-Patterns

❌ **Generic catch-all:** `catch(e)` without mapping
❌ **Throwing exceptions from use cases:** Use Either<Failure, T> instead
❌ **Technical error messages in UI:** "DioException" not user-friendly
❌ **Swallowing errors silently:** Always emit error state
❌ **Re-throwing mapped failures:** Map once, pass through thereafter
