---
name: debugging-architecture
description: 'Find and fix architecture violations. Use for identifying layer leaks, catching violations early, debugging "provider not found" errors, and validating Clean Architecture compliance at runtime.'
argument-hint: 'Layer or component (e.g., presentation layer, auth feature, service locator)'
---

# Debugging Architecture Violations

## When to Use
- "Provider not found" or "Type not found" errors
- Suspecting layer violations (presentation importing data)
- Circular dependency errors
- Understanding unexpected behaviors
- Runtime errors during app startup
- Verifying fixes after refactoring

## Common Errors & Solutions

### Error 1: "No instance of type XYZ found in service locator"

**Root Cause:** Dependency not registered or circular dependency

**Debugging Steps:**

```dart
// Step 1: Check if dependency is registered
void debugServiceLocator() {
  // Try to get the dependency
  try {
    final instance = getIt<AuthRepository>();
    print('✅ AuthRepository registered');
  } catch (e) {
    print('❌ AuthRepository NOT registered: $e');
  }

  // Check all registered instances
  print('Registered types: ${getIt.registeredSingletons}');
  print('Factory types: ${getIt._factories.keys.toList()}');
}
```

**Solution Checklist:**
```dart
// ✅ In service_locator.dart
locatorSetup() async {
  // 1. Register external services first
  getIt.registerLazySingleton<Dio>((...) => ...);
  
  // 2. Register data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),  // ← Use getIt<>()
  );
  
  // 3. Register repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),  // ← Exists?
    ),
  );
  
  // 4. Call in main()
  await locatorSetup();  // ← Called before runApp?
}

// ❌ Missing in main()
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await locatorSetup();  // ❌ If not called, dependencies not registered
  runApp(const SilentSpace());
}
```

---

### Error 2: "Dependency cycle detected"

**Root Cause:** A → B → A circular dependency

**Debugging Steps:**

```dart
// Find the cycle
// 1. List what each depends on:
//    AuthRepository depends on: [AuthRemoteDataSource, AuthLocalDataSource]
//    AuthRemoteDataSource depends on: [Dio]
//    AuthLocalDataSource depends on: [SecureStorageService]
//    ✓ No cycle

//    FeatureA depends on: [FeatureB]
//    FeatureB depends on: [FeatureA]
//    ❌ CYCLE DETECTED

// 2. Visualize the dependency graph
// 3. Extract common functionality
```

**Solution:**

```dart
// ❌ Before: Circular dependency
class FeatureARepository {
  final FeatureBRepository featureB;  // ← B depends on A
}

class FeatureBRepository {
  final FeatureARepository featureA;  // ← A depends on B
}

// ✅ After: Extract shared dependency
class SharedService {
  // Common logic both need
}

class FeatureARepository {
  final SharedService sharedService;  // ← Both use shared service
}

class FeatureBRepository {
  final SharedService sharedService;  // ← Both use shared service
}
```

---

### Error 3: "Presentation importing from data layer"

**Root Cause:** Direct access to data source or concrete implementation

**Detection:**

```dart
// ❌ Wrong import in presentation
import 'package:silent_space/features/auth/data/sources/auth_remote_data_source.dart';

class LoginCubit {
  final AuthRemoteDataSource dataSource;  // ❌ Should not import from data/
}

// ✅ Correct
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_usecase.dart';

class LoginCubit {
  final SignInUseCase signInUseCase;  // ✅ Use domain contracts
}
```

**Automated Detection:**

```bash
# In CI/CD, check for prohibited imports
grep -r "from 'silent_space/features/.*/data/" lib/features/*/presentation/ && \
  echo "❌ VIOLATION: Presentation imports data layer" || \
  echo "✅ Clean: No data imports in presentation"
```

---

### Error 4: "Unimplemented abstract method"

**Root Cause:** Repository implementation missing required methods

**Debugging:**

```dart
// ❌ Incomplete implementation
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, UserEntity>> signIn(...) async => ...;
  
  // ❌ Missing signUp(), signOut(), etc.
}

// ✅ Complete implementation
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, UserEntity>> signIn(...) async => ...;
  
  @override
  Future<Either<Failure, UserEntity>> signUp(...) async => ...;
  
  @override
  Future<Either<Failure, void>> signOut() async => ...;
}
```

**Fix:** Implement all abstract methods from the repository contract.

---

### Error 5: "setState called after dispose"

**Root Cause:** Async operation completing after widget disposal

**Debugging:**

```dart
// ❌ Wrong: Updating mutable state in Cubit
class AuthCubit extends Cubit<AuthState> {
  late UserEntity? _currentUser;  // ❌ Mutable field
  
  void login() {
    _currentUser = null;  // ❌ Mutation
  }
}

// ✅ Correct: Emit new state
class AuthCubit extends Cubit<AuthState> {
  @override
  Future<void> login(...) async {
    emit(const AuthLoading());
    // ... async work ...
    emit(AuthSuccess(user: user));  // ✅ Emit state
  }
}
```

---

## Architecture Validation Checklist

### 1. **Domain Layer Isolation**

```dart
// lib/features/{feature}/domain/

// ✅ Correct: Pure Dart
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

// ❌ Wrong: Imports from data
import 'package:silent_space/features/auth/data/models/user_model.dart';

// ❌ Wrong: Imports from Flutter/external packages
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
```

**Check:** Run analysis
```bash
flutter analyze lib/features/*/domain/
# Should have zero errors importing data/presentation
```

### 2. **Data Layer Contracts**

```dart
// lib/features/{feature}/data/

// ✅ Repositories implement domain contracts
class AuthRepositoryImpl implements AuthRepository {
  // Implements all methods from AuthRepository
}

// ✅ Data sources are abstract
abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(...);
}

// ❌ Casting to concrete implementation in presentation
final repo = getIt<AuthRepository>() as AuthRepositoryImpl;  // Never!
```

### 3. **Presentation Layer Dependencies**

```dart
// lib/features/{feature}/presentation/

// ✅ Only imports domain
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_usecase.dart';

// ❌ Never imports data
import 'package:silent_space/features/auth/data/implements/auth_repository_impl.dart';

// ❌ Never creates services directly
final dio = Dio();  // Should be injected from getIt
```

### 4. **Dependency Injection Registration**

```dart
// lib/core/utils/service_locator.dart

// Check registration order
locatorSetup() async {
  // Layer 1: External services (first)
  getIt.registerLazySingleton<Dio>(...);
  
  // Layer 2: Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(...);
  
  // Layer 3: Repositories
  getIt.registerLazySingleton<AuthRepository>(...);
  
  // Layer 4: Use cases
  getIt.registerLazySingleton<SignInUseCase>(...);
  
  // Layer 5: Presentation (last)
  getIt.registerFactory<AuthCubit>(...);
}

// ✅ Verify all dependencies are registered
print('Registered: ${getIt.registeredSingletons.length} singletons');
print('Factories: ${getIt._factories.length} factories');
```

---

## Three-Layer Validation Diagram

```
┌────────────────────────────────────┐
│    PRESENTATION (Pages, Cubits)    │  ← Imports: Domain (repos, use cases)
│  ❌ Never imports: Data layer      │
└────────────────────────────────────┘
              ↓
┌────────────────────────────────────┐
│    DOMAIN (Entities, Use Cases)    │  ← Pure Dart
│  ❌ Never imports: Data, Flutter   │
└────────────────────────────────────┘
              ↓
┌────────────────────────────────────┐
│  DATA (Models, DataSources, Repos) │  ← Implements domain contracts
│  ❌ Never imports: Presentation    │
└────────────────────────────────────┘
```

---

## Debugging Checklist

When something breaks, validate in order:

- [ ] **Startup errors** → Check service_locator.dart registration
  - Is `locatorSetup()` called at startup?
  - Are all types registered before use?
  - Any async initialization missing?

- [ ] **Provider not found** → Check getIt usage
  - Is the type registered?
  - Is the import correct in the page?
  - Spelling of class name?

- [ ] **Unexpected behavior** → Check state management
  - Is Cubit emitting new states or mutating?
  - Is UI listening to correct Cubit?
  - Are side effects in BlocListener?

- [ ] **Layer violations** → Check imports
  - Does presentation import data layer?
  - Does domain import Flutter or external packages?
  - Is data source injected or created directly?

- [ ] **Test failures** → Check mocking
  - Are mocks registered with `override: true`?
  - Is service locator reset between tests?
  - Are dependencies properly mocked?

---

## Quick Debugging Commands

```dart
// Check all registered types
void printServiceLocator() {
  print('Singletons: ${getIt.registeredSingletons}');
  print('Factories: ${getIt._factories.keys.toList()}');
}

// Verify a type is registered
bool isRegistered<T>() {
  try {
    getIt<T>();
    return true;
  } catch (_) {
    return false;
  }
}

// Safe get with fallback
T? getSafe<T>() {
  try {
    return getIt<T>();
  } catch (e) {
    print('⚠️  Type not registered: $T - $e');
    return null;
  }
}
```

---

## Anti-Patterns to Avoid

❌ **Importing concrete types in presentation:**
```dart
import 'package:silent_space/features/auth/data/implements/auth_repository_impl.dart';
```

❌ **Creating dependencies in widgets:**
```dart
class LoginPage {
  final dio = Dio();  // Never do this
}
```

❌ **Async initialization without awaiting:**
```dart
void main() {
  locatorSetup();  // ❌ Not awaited
  runApp(...);
}
```

❌ **Mutable state in Cubits:**
```dart
class AuthCubit {
  late UserEntity user;  // ❌ Mutable
  void setUser(...) => user = ...;  // ❌ Mutation
}
```

---

## Testing with Mocks

```dart
void main() {
  setUp(() {
    // Register mocks
    getIt.registerSingleton<AuthRepository>(
      MockAuthRepository(),
      override: true,  // Override default
    );
  });

  tearDown(() {
    getIt.reset();  // Clear all
  });

  test('AuthCubit_WhenSuccess_EmitsLoaded', () {
    // Test uses mocked AuthRepository
    final cubit = AuthCubit(signInUseCase: getIt<SignInUseCase>());
    // ...
  });
}
```
