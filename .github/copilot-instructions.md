---
description: Workspace instructions for Silent Space - Flutter productivity app with Clean Architecture
---

# Silent Space — Workspace Instructions

## 📋 Quick Context

**Silent Space** is a production-quality Flutter focus timer app featuring:
- **Clean Architecture** with feature-based isolation (Domain → Data → Presentation)
- **Flutter BLoC** state management using Cubit pattern
- **Firebase** integration for remote auth/data + **Hive** for local persistence
- **Internationalization** (English + Arabic) with `easy_localization`
- **Networking** with Dio interceptors (auth, error handling, logging)
- **Dependency Injection** via `get_it` — all dependencies registered in `core/utils/service_locator.dart`

## 🏗️ Architecture — Three Layers Per Feature

```
features/
├── {feature}/
│   ├── domain/           ← Entities, Repository contracts, Use Cases
│   │   ├── entities/     (Pure Dart: no framework deps)
│   │   ├── repositories/ (Abstract contracts)
│   │   └── usecases/     (Business logic wrapped in UseCase<T, Params>)
│   ├── data/             ← Models, DataSources, Repository implementations
│   │   ├── models/       (Convert to/from JSON, implement entities)
│   │   ├── sources/      (Remote: Dio/Firebase, Local: Hive/SharedPrefs)
│   │   └── implements/   (Repository impl: orchestrate domain logic)
│   └── presentation/     ← UI, Cubits, States, Pages, Widgets
│       ├── cubit/        (State management: Cubit + State classes)
│       ├── pages/        (Routable screens)
│       └── widgets/      (Reusable, stateless UI components)
```

**Core Principles:**
- Domain has **zero dependencies** on Data or Presentation
- Data depends on Domain (via repository contracts)
- Presentation depends on Domain (via repositories & use cases) — never directly on Data sources
- All errors become `Failure` objects before reaching UI
- Repository methods return `Either<Failure, T>` (dartz package)

## 📁 Core Folder Structure & Responsibilities

| Folder | Purpose | Key Files |
|--------|---------|-----------|
| `core/usecases/` | Base UseCase<T, Params> abstract class | `usecase.dart` |
| `core/errors/` | Failure types, Exceptions | `failures.dart`, `exceptions.dart` |
| `core/network/` | Dio client, NetworkInfo, interceptors | `dio_client.dart`, `network_info.dart` |
| `core/security/` | Secure storage (JWT tokens, secrets) | `secure_storage_service.dart` |
| `core/cache/` | Hive setup, persistence logic | `hive_service.dart` |
| `core/utils/` | **Constants, routes, service locator** | `service_locator.dart`, `app_strings.dart`, `on_generate_route.dart` |
| `core/theme/` | App colors, typography, Cubit for dark mode | `app_theme.dart`, `theme_cubit.dart` |
| `core/cubits/` | App-level state (language, theme) | `language_cubit/`, `theme_cubit.dart` |
| `core/widgets/` | Reusable shared widgets | (_Inventory in implementation_) |
| `assets/translations/` | Localization files | `en.json`, `ar.json` |

## 🔑 Agent Role & Behavior

Adopt these behaviors when implementing changes:

### **Senior Architect Mindset**
- **Enforce Clean Architecture** — No presentation logic in domain, no domain logic in data sources
- **Validate service_locator.dart** — All new dependencies must be registered here
- **Refuse monolithic code** — Split large widgets/files into modular, reusable units
- **Ask for clarification** if requirements are ambiguous — never assume

### **Code Quality Standards**
- **Defensive & preventive** — Catch architectural violations early
- **No duplication** — Reuse existing patterns, widgets, and utilities
- **Production-ready** — No hacks, temporary code, or "TODO" placeholders without context
- **All immutable state** — Cubits emit new states; never mutate fields

## 🎨 Style & Naming Conventions

**Source:** [.ai/style.md](../.ai/style.md) — See also [AGENTS.md](../AGENTS.md)

### File & Folder Naming
- All files and folders: **`snake_case`**  
  Examples: `auth_cubit.dart`, `show_data_container.dart`, `core/network/`, `features/auth/`

### Identifier Naming
- **Classes, Enums, Typedefs, Extensions:** `UpperCamelCase` (e.g., `AuthCubit`, `SessionModel`, `NetworkFailure`)
- **Variables, Functions, Parameters, Instances:** `lowerCamelCase` (e.g., `isLoading`, `signInUser`, `userId`)
- **File-private:** prefix with underscore `_privateVar`, `_helperFunction()`

### Widget & UI Rules
- **Composition over inheritance** — Prefer composing smaller widgets over subclassing
- **Stateless prioritized** — Use `StatelessWidget` unless mutable state is required
- **UI nesting depth ≤ 3** in single `build()` — Extract nested widgets into separate classes
- **NO hardcoded strings** — Use `AppStrings.key.tr()` from `easy_localization`
- **NO hardcoded colors** — Use `Theme.of(context)` or `AppTheme` constants
- **Const constructors mandatory** — Applied aggressively to all widgets for optimization

### Code Formatting
- **Trailing commas required** for multi-line lists, functions, constructors
- **Example:**
  ```dart
  const AuthCubit(
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
  );
  ```

## ✅ Strict DO / DON'T Rules

**See also:** [.ai/rules.md](../.ai/rules.md)

### Architecture
- ✅ **DO** preserve Clean Architecture boundaries (domain → data → presentation)
- ✅ **DO** map exceptions to typed `Failure` objects in repository implementations
- ✅ **DO** use `Either<Failure, T>` return types for all repository methods
- ❌ **DON'T** import data sources directly in presentation layer
- ❌ **DON'T** break feature isolation — no cross-feature domain imports

### State Management
- ✅ **DO** use `Cubit` from `flutter_bloc`
- ✅ **DO** make states immutable and extend `Equatable`
- ✅ **DO** emit new states from Cubit methods — never mutate fields
- ✅ **DO** handle Loading, Error, Success, Empty states in UI via `BlocBuilder` / `BlocSelector`
- ❌ **DON'T** use `setState` in presentation — rely on BLoC/Cubit
- ❌ **DON'T** store mutable fields in Cubit as source of truth

### Code Quality
- ✅ **DO** reuse widgets and utilities from `core/widgets/` and `core/utils/`
- ✅ **DO** extract complex UI logic into separate stateless widgets
- ✅ **DO** create unit tests for business logic (domain, data)
- ✅ **DO** create widget tests for presentation layer
- ❌ **DON'T** create unnecessary or duplicate files
- ❌ **DON'T** write quick hacks — everything is production-quality
- ❌ **DON'T** use helper functions for complex UI — extract to widget classes

## 🛠️ Build, Run & Test Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run app in debug mode
flutter run

# Build APK (Android)
flutter build apk --split-per-abi

# Build iOS
flutter build ios
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run tests for a specific file
flutter test test/features/auth/

# Run tests with verbose output
flutter test -v
```

### Code Analysis
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format lib/ test/

# Create test coverage report
lcov -r coverage/lcov.info '*/freezed.dart' '*.g.dart' -o coverage/lcov_filtered.info
```

## 📦 Dependency Injection — Service Locator

**File:** `core/utils/service_locator.dart`

All external dependencies (APIs, DBs, services) and business logic (repositories, use cases, cubits) are registered here.

**Pattern:**
```dart
// Data Layer
getIt.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
);

// Domain Layer (Repository contracts)
getIt.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: getIt<AuthRemoteDataSource>(),
    localDataSource: getIt<AuthLocalDataSource>(),
  ),
);

// Use Cases
getIt.registerLazySingleton<SignInUseCase>(
  () => SignInUseCase(getIt<AuthRepository>()),
);

// Presentation Layer (Cubits)
getIt.registerFactory<AuthCubit>(
  () => AuthCubit(
    signInUseCase: getIt<SignInUseCase>(),
    signUpUseCase: getIt<SignUpUseCase>(),
  ),
);
```

**When adding new features:**
1. Define abstract repository in `domain/repositories/`
2. Register both the abstract contract and implementation in `service_locator.dart`
3. Register use cases that depend on the repository
4. Register Cubits that depend on use cases

**Never** inject concrete data sources into presentation layer — always go through repository contracts.

## 🧪 Testing Strategy

- **Unit Tests** (Domain & Data): Test business logic, repositories, data source behavior
- **Widget Tests** (Presentation): Test UI layouts, interactions, state changes
- **Mocktail** for mocking: Mock repositories, cubits, and external services
- **BDD style** test naming: `testWhen_ShouldExpectWhat`

**Example:**
```dart
group('AuthRepositoryImpl', () {
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  test('signIn_WhenSuccessful_ReturnsUserEntity', () async {
    // Arrange
    final expectedUser = UserModel(...);
    when(() => mockRemote.signIn(...))
        .thenAnswer((_) async => expectedUser);

    // Act
    final result = await repository.signIn(...);

    // Assert
    expect(result, Right(expectedUser.toEntity()));
  });
});
```

## 🌐 Localization & Internationalization

**Files:** `assets/translations/{en,ar}.json`

**Pattern:** Use `easy_localization` with `AppStrings` constants.

```dart
// ✅ Correct
import 'package:silent_space/core/utils/app_strings.dart';

Text(AppStrings.welcomeTitle.tr())

// ❌ Wrong
Text("Welcome to Silent Space")  // hardcoded
```

Currently supported: **English (en)** and **Arabic (ar)**

## 🔒 Security Best Practices

- **JWT Tokens:** Store in `flutter_secure_storage` via `SecureStorageService`
- **API Secrets:** Never commit to version control; use environment variables
- **Firebase Rules:** Enforce authentication and data ownership in Firestore
- **Network Interceptors:** `DioClient` handles auth headers, error mapping, logging

## 📝 Feature Template — Quick Checklist

When creating a new feature (e.g., `features/notifications/`):

```json
{
  "feature_name": "notifications",
  "domain": {
    "create": ["entities/notification.dart", "repositories/notification_repository.dart"],
    "use_cases": ["get_notifications_usecase.dart", "mark_as_read_usecase.dart"]
  },
  "data": {
    "models": ["notification_model.dart"],
    "sources": ["notification_remote_data_source.dart"],
    "implementations": ["notification_repository_impl.dart"]
  },
  "presentation": {
    "cubit": ["notification_cubit.dart", "notification_state.dart"],
    "pages": ["notifications_page.dart"],
    "widgets": ["notification_tile.dart", "notification_list.dart"]
  },
  "tests": [
    "test/features/notifications/domain/usecases/**_test.dart",
    "test/features/notifications/data/repositories/**_test.dart",
    "test/features/notifications/presentation/**_test.dart"
  ]
}
```

1. Define domain entities and repository contract
2. Implement data models and data sources
3. Implement repository to orchestrate data fetching
4. Create use cases wrapping repository logic
5. Build Cubit + state classes for presentation
6. Create UI pages and widgets
7. Write tests at each layer
8. Register dependencies in `service_locator.dart`

## 📚 References & Documentation

- [AGENTS.md](../AGENTS.md) — AI agent role definition and enforcement strategy
- [.ai/context.md](../.ai/context.md) — Repository context and tech stack details
- [.ai/rules.md](../.ai/rules.md) — Strict do/don't coding rules
- [.ai/style.md](../.ai/style.md) — Style and naming conventions
- [README.md](../README.md) — Project structure, setup, and screenshots
- `pubspec.yaml` — Dependency versions and package info

## 🎯 When to Ask for Clarification

You **must** ask the user before proceeding if:
- Requirements are ambiguous or incomplete
- The feature impacts multiple layers or crosses feature boundaries
- API/data model design is unclear
- State management strategy is not obvious
- Performance or architectural trade-offs need discussion

## 📊 Workspace Health Checklist

Periodically review:
- [ ] All features follow three-layer Clean Architecture
- [ ] No presentation imports from data sources (checked in `service_locator.dart`)
- [ ] All new dependencies registered in `service_locator.dart`
- [ ] Test coverage ≥ 70% for domain and data layers
- [ ] No hardcoded strings or colors in widgets
- [ ] Widget nesting ≤ 3 levels in `build()` methods
- [ ] State classes are immutable and use `Equatable`
- [ ] BLoC/Cubit used consistently (no mixture of patterns)

---

**Last Updated:** March 2026  
**Maintainer:** Silent Space Team  
**Questions?** Refer to AGENTS.md for AI behavior guidelines or create an issue.
