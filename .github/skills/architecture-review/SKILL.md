---
name: architecture-review
description: 'Review code for Clean Architecture compliance. Validates domain layer isolation, repository patterns, dependency injection registration, state management, and layer violations. Use for PR reviews, refactoring guidance, and architectural validation.'
argument-hint: 'File path or feature name to review (e.g., features/auth, lib/features/session/presentation/cubit/session_cubit.dart)'
---

# Architecture Review Checklist

## When to Use
- Code review: Verify new code follows Clean Architecture
- Refactoring: Ensure changes maintain architectural boundaries
- Onboarding: Validate new team members understand the patterns
- Before merging: Catch violations early

## Architecture Principles

```
┌─────────────────────────────────────────────────────────┐
│              PRESENTATION LAYER (UI)                    │
│  • Pages, Widgets, Cubits, States                       │
│  • Imports: Domain (repos, use cases)                   │
│  • Depends on: Domain only                              │
└─────────────────────────────────────────────────────────┘
                        ↑
                   depends on
                        ↑
┌─────────────────────────────────────────────────────────┐
│                 DATA LAYER (Repository)                 │
│  • Models, DataSources (Remote/Local), Repositories     │
│  • Imports: Domain, Core                                │
│  • Implements: Abstract repos from domain               │
│  • Never imports: Presentation                          │
└─────────────────────────────────────────────────────────┘
                        ↑
                   depends on
                        ↑
┌─────────────────────────────────────────────────────────┐
│               DOMAIN LAYER (Pure Dart)                  │
│  • Entities, Repositories (abstract), UseCases          │
│  • Zero dependencies on Data or Presentation            │
│  • Pure business logic                                  │
└─────────────────────────────────────────────────────────┘
```

## Step-by-Step Review Procedure

### 1. **Domain Layer Validation**

✅ **PASS**: Domain layer has ZERO external dependencies:
```dart
// ✅ Correct - Pure Dart
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

class UserEntity extends Equatable { ... }

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUser(String id);
}
```

❌ **FAIL**: Domain imports from data or presentation:
```dart
// ❌ VIOLATION - Domain importing Dio (data layer)
import 'package:dio/dio.dart';

class UserRepository {
  final Dio dio;  // This should NOT be in domain
}
```

**Checklist:**
- [ ] No imports from `data/`, `presentation/`, or external packages (only `equatable`, `dartz`)
- [ ] Repository contracts are abstract
- [ ] Entities are immutable (extend `Equatable`)
- [ ] Use cases extend `UseCase<T, Params>`
- [ ] All methods return `Either<Failure, T>`

### 2. **Data Layer Validation**

✅ **PASS**: Data imports domain, implements repos, maps exceptions:
```dart
// ✅ Correct - Proper layering
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  @override
  Future<Either<Failure, UserEntity>> signIn(...) async {
    try {
      final user = await remoteDataSource.signIn(...);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
```

❌ **FAIL**: Data layer directly used in presentation:
```dart
// ❌ VIOLATION - Presentation importing data sources
import 'package:silent_space/features/auth/data/sources/auth_remote_data_source.dart';

class LoginPage extends StatelessWidget {
  final AuthRemoteDataSource dataSource;  // Should be repository
}
```

**Checklist:**
- [ ] Models implement entities (`.toEntity()` method)
- [ ] All exceptions caught and mapped to `Failure` objects
- [ ] Repository implementations are in `data/implements/`
- [ ] Data sources are abstract (interface segregation)
- [ ] No presentation imports from data layer

### 3. **Presentation Layer Validation**

✅ **PASS**: Presentation imports repositories, not data sources:
```dart
// ✅ Correct - UI never touches data sources
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_usecase.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),  // Injected, not created here
      child: ...,
    );
  }
}
```

❌ **FAIL**: Presentation directly creates repositories:
```dart
// ❌ VIOLATION - UI creating data source directly
class LoginPage extends StatelessWidget {
  final dio = Dio();  // Should be injected
  
  void login() {
    final user = dio.post('/auth/login');  // Data access in UI
  }
}
```

**Checklist:**
- [ ] Pages use `BlocProvider` to inject Cubits
- [ ] Cubits injected from `getIt<ServiceLocator>`, not created in widget
- [ ] No Dio, Hive, Firebase calls in presentation
- [ ] States are immutable, extend `Equatable`
- [ ] Cubits only depend on use cases
- [ ] Loading, Empty, Success, Error states handled
- [ ] No `setState` — use BLoC/Cubit exclusively
- [ ] Widget nesting depth ≤ 3 in `build()`

### 4. **Dependency Injection Validation**

✅ **PASS**: All deps registered, layer separation enforced:
```dart
// ✅ Correct - service_locator.dart
// 1. External services
getIt.registerLazySingleton<Dio>(() => DioClient(...).dio);
getIt.registerLazySingleton<HiveService>(() => HiveService());

// 2. Data sources → repositories
getIt.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
);
getIt.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: getIt<AuthRemoteDataSource>(),
    localDataSource: getIt<AuthLocalDataSource>(),
  ),
);

// 3. Use cases
getIt.registerLazySingleton<SignInUseCase>(
  () => SignInUseCase(getIt<AuthRepository>()),
);

// 4. Presentation
getIt.registerFactory<LoginCubit>(
  () => LoginCubit(signInUseCase: getIt<SignInUseCase>()),
);
```

❌ **FAIL**: Direct data source injection to presentation:
```dart
// ❌ VIOLATION - Data source in presentation
getIt.registerFactory<LoginCubit>(
  () => LoginCubit(
    dataSource: getIt<AuthRemoteDataSource>(),  // ❌ Should be repository
  ),
);
```

**Checklist:**
- [ ] All new use cases registered in `service_locator.dart`
- [ ] All new repositories registered in `service_locator.dart`
- [ ] All new Cubits registered in `service_locator.dart`
- [ ] Presentation only receives repositories and use cases, never data sources
- [ ] Data sources never exposed outside data layer

### 5. **State Management Validation**

✅ **PASS**: Immutable states, clean emission:
```dart
// ✅ Correct - Cubit best practices
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;

  AuthCubit({required this.signInUseCase}) : super(const AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(const AuthLoading());
    
    final result = await signInUseCase(
      SignInParams(email: email, password: password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }
}

// State classes are immutable, extend Equatable
part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}
```

❌ **FAIL**: Mutable Cubit state:
```dart
// ❌ VIOLATION - Mutable field in Cubit
class AuthCubit extends Cubit<AuthState> {
  UserEntity? currentUser;  // ❌ Mutable field

  void setUser(UserEntity user) {
    currentUser = user;  // ❌ Mutation instead of emit
  }
}
```

**Checklist:**
- [ ] All state classes extend `Equatable`
- [ ] State classes are const and immutable
- [ ] Cubit methods emit new states, never mutate
- [ ] All states (Loading, Success, Error, Empty) defined
- [ ] Use `BlocBuilder` or `BlocSelector` in UI, never direct field access

### 6. **Widget Structure Validation**

✅ **PASS**: Clean composition, shallow nesting:
```dart
// ✅ Correct - Modular widget structure
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const HomeContent(),  // Extracted widget
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        if (state is SessionLoading) {
          return const _LoadingWidget();
        } else if (state is SessionLoaded) {
          return _SessionList(sessions: state.sessions);
        } else if (state is SessionError) {
          return _ErrorWidget(message: state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
```

❌ **FAIL**: Monolithic widget with deep nesting:
```dart
// ❌ VIOLATION - Deep nesting, mixed concerns
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Image(...),
                  Column(
                    children: [
                      Text(...),
                      BlocBuilder<SessionCubit, SessionState>(
                        builder: (_) => ...
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Checklist:**
- [ ] Max nesting depth 3 in `build()` method
- [ ] Complex widgets extracted to separate `StatelessWidget` classes
- [ ] State handled via `BlocBuilder` / `BlocSelector`, not helper methods
- [ ] All widgets are const (const constructors)
- [ ] No hardcoded strings — use `AppStrings.key.tr()`
- [ ] No hardcoded colors — use `AppTheme` or `Theme.of(context)`

### 7. **Error Handling Validation**

✅ **PASS**: Exceptions mapped to Failure objects:
```dart
// ✅ Correct - Exception → Failure mapping
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, UserEntity>> signIn(...) async {
    try {
      final user = await remoteDataSource.signIn(...);
      return Right(user.toEntity());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
```

❌ **FAIL**: Exceptions leaking to UI:
```dart
// ❌ VIOLATION - Unhandled exception
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserEntity> signIn(...) async {
    final user = await remoteDataSource.signIn(...);  // ❌ No try-catch
    return user.toEntity();
  }
}
```

**Checklist:**
- [ ] All repository methods return `Either<Failure, T>`
- [ ] Exception types mapped to domain `Failure` objects
- [ ] Use cases never throw, only return `Either`
- [ ] Cubits handle `Failure` via `fold()`, emit appropriate state

## Automated Review Checklist

Use this before submitting PRs:

```dart
// Domain Layer
- [ ] No imports from `data/`, `presentation/`, or `flutter`
- [ ] All repositories are abstract
- [ ] All entities extend `Equatable` with `const` constructors
- [ ] All use cases extend `UseCase<T, Params>`

// Data Layer
- [ ] Implements domain repository contracts
- [ ] Models have `.toEntity()` method
- [ ] All exceptions caught and mapped to `Failure`
- [ ] All methods return `Either<Failure, T>`
- [ ] No direct imports from presentation layer

// Presentation Layer
- [ ] Only imports domain (repos, use cases), never data sources
- [ ] All Cubits injected from `getIt`, not created in widgets
- [ ] All states immutable, extend `Equatable`
- [ ] Max nesting depth 3 in `build()`
- [ ] No hardcoded strings or colors

// Dependency Injection
- [ ] All use cases registered in `service_locator.dart`
- [ ] All repositories registered in `service_locator.dart`
- [ ] All Cubits registered in `service_locator.dart`
- [ ] No data sources exposed outside `service_locator`

// State Management
- [ ] Cubits never mutate internal state, only emit
- [ ] All state transitions covered (Loading, Success, Error, Empty)
- [ ] States use immutable `Equatable`
- [ ] UI uses `BlocBuilder` / `BlocSelector`

// Error Handling
- [ ] All exceptions caught at data layer
- [ ] Exceptions mapped to typed `Failure` objects
- [ ] No exceptions in UI layer
```

## Common Violations & Fixes

| Violation | Example | Fix |
|----------|---------|-----|
| Data source in presentation | `LoginCubit(dataSource: ...)` | `LoginCubit(useCase: ...)` |
| Direct Dio/Hive in widgets | `final dio = Dio()` | Inject via `getIt<Repository>` |
| Mutable Cubit fields | `userEntity = entity` | `emit(SuccessState(entity))` |
| Deep widget nesting | 5+ levels in `build()` | Extract to separate `StatelessWidget` |
| Hardcoded strings | `Text("Login")` | `Text(AppStrings.login.tr())` |
| Exception in UI | API call in widget | Map in repository to `Failure` |

## Red Flags 🚩

If you see these, request changes:

1. **Presentation importing data sources** → Architectural violation
2. **Mutable Cubit state** → State management broken
3. **Exception thrown from use case** → Error handling broken
4. **Data layer calling presentation** → Dependency inversion violation
5. **Complex UI nesting** → Maintenance nightmare

## PR Review Template

```markdown
## Architecture Review Result ✅

- [x] Domain layer isolated (zero external deps)
- [x] Data layer implements domain contracts
- [x] Presentation imports only domain
- [x] All dependencies registered in service_locator
- [x] State management follows Cubit pattern
- [x] Exceptions mapped to Failure objects
- [x] Widget nesting ≤ 3 levels
- [x] No hardcoded strings/colors

**Status**: Ready to merge ✅
```
