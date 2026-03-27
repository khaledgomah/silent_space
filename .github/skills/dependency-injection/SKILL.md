---
name: dependency-injection
description: 'Manage dependency injection with get_it service locator. Use for registering services, repositories, use cases, and Cubits; avoiding circular dependencies; and maintaining clean separation of concerns.'
argument-hint: 'Component to register (e.g., AuthRepository, TimerCubit, NotificationUseCase)'
---

# Dependency Injection with get_it

## When to Use
- Adding new services, repositories, or use cases
- Wiring up dependencies after creating new features
- Debugging "provider not found" errors
- Restructuring service registration
- Avoiding circular dependencies

## File Location

**Primary:** `lib/core/utils/service_locator.dart`

This is the single source of truth for all dependencies.

## Architecture Layers & Registration Order

```
┌─────────────────────────────────────────────┐
│     EXTERNAL SERVICES (Bottom Layer)        │
│  • Firebase, Dio, Hive, SharedPreferences   │
│  • Registered FIRST                         │
└─────────────────────────────────────────────┘
                    ↓ depends on
┌─────────────────────────────────────────────┐
│         DATA LAYER DEPENDENCIES             │
│  • DataSources (Remote/Local)               │
│  • Repositories & implements                │
│  • Models                                   │
└─────────────────────────────────────────────┘
                    ↓ depends on
┌─────────────────────────────────────────────┐
│       DOMAIN LAYER DEPENDENCIES             │
│  ✗ NOTHING — pure Dart, no registration    │
│  (Domain is dependency-free)                │
└─────────────────────────────────────────────┘
                    ↓ depends on
┌─────────────────────────────────────────────┐
│    PRESENTATION LAYER DEPENDENCIES          │
│  • Use Cases                                │
│  • Cubits/BLoCs                             │
│  • Registered LAST                          │
└─────────────────────────────────────────────┘
```

## Step-by-Step Registration Procedure

### 1. **Register External Services First**

These are the foundation. Register Firebase, Dio, local storage, etc.:

```dart
Future<void> locatorSetup() async {
  // ── 1. External Services (NO DEPENDENCIES) ──
  
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  
  // Network
  getIt.registerLazySingleton<Dio>(
    () => DioClient(secureStorage: getIt<SecureStorageService>()).dio,
  );
  
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: Connectivity()),
  );
  
  // Local Storage
  getIt.registerLazySingleton<SecureStorageService>(
    () => const SecureStorageService(),
  );
  
  getIt.registerLazySingleton<HiveService>(
    () => HiveService(),
  );
  
  getIt.registerLazySingleton<SharedPreferences>(
    () => await SharedPreferences.getInstance(),
  );
}
```

### 2. **Register Data Layer: Data Sources**

Data sources implement access patterns (remote API calls, local reads):

```dart
// Remote Data Sources (depend on Dio)
getIt.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
);

getIt.registerLazySingleton<SessionRemoteDataSource>(
  () => SessionRemoteDataSourceImpl(
    firestore: getIt<FirebaseFirestore>(),
  ),
);

// Local Data Sources (depend on Hive, SharedPreferences)
getIt.registerLazySingleton<AuthLocalDataSource>(
  () => AuthLocalDataSourceImpl(
    secureStorage: getIt<SecureStorageService>(),
  ),
);

getIt.registerLazySingleton<SessionLocalDataSource>(
  () => SessionLocalDataSourceImpl(hiveService: getIt<HiveService>()),
);

// Register Hive adapters before using them
Hive.registerAdapter(SessionModelAdapter());
Hive.registerAdapter(UserModelAdapter());
```

### 3. **Register Data Layer: Repositories**

Repositories orchestrate data sources and implement domain contracts:

```dart
// Repositories (depend on data sources + NetworkInfo)
getIt.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: getIt<AuthRemoteDataSource>(),
    localDataSource: getIt<AuthLocalDataSource>(),
    networkInfo: getIt<NetworkInfo>(),
  ),
);

getIt.registerLazySingleton<SessionRepository>(
  () => SessionRepositoryImpl(
    remoteDataSource: getIt<SessionRemoteDataSource>(),
    localDataSource: getIt<SessionLocalDataSource>(),
    networkInfo: getIt<NetworkInfo>(),
  ),
);
```

### 4. **Register Domain Layer: Use Cases**

Use cases depend only on repository contracts (abstract classes):

```dart
// Use Cases (depend on repositories only)
getIt.registerLazySingleton<SignInUseCase>(
  () => SignInUseCase(getIt<AuthRepository>()),
);

getIt.registerLazySingleton<SignUpUseCase>(
  () => SignUpUseCase(getIt<AuthRepository>()),
);

getIt.registerLazySingleton<SignOutUseCase>(
  () => SignOutUseCase(getIt<AuthRepository>()),
);

getIt.registerLazySingleton<GetSessionsUseCase>(
  () => GetSessionsUseCase(getIt<SessionRepository>()),
);

getIt.registerLazySingleton<SaveSessionUseCase>(
  () => SaveSessionUseCase(getIt<SessionRepository>()),
);
```

### 5. **Register Presentation Layer: Cubits**

Cubits depend on use cases. Use `registerFactory()` for Cubits (new instance each time):

```dart
// Cubits — use registerFactory() (new instance per request)
getIt.registerFactory<AuthCubit>(
  () => AuthCubit(
    signInUseCase: getIt<SignInUseCase>(),
    signUpUseCase: getIt<SignUpUseCase>(),
    signOutUseCase: getIt<SignOutUseCase>(),
  ),
);

getIt.registerFactory<SessionCubit>(
  () => SessionCubit(
    getSessionsUseCase: getIt<GetSessionsUseCase>(),
    saveSessionUseCase: getIt<SaveSessionUseCase>(),
  ),
);

// App-level Cubits — use registerLazySingleton() (single instance)
getIt.registerLazySingleton<ThemeCubit>(
  () => ThemeCubit(),
);

getIt.registerLazySingleton<LanguageCubit>(
  () => LanguageCubit(),
);
```

## Key Patterns

### Pattern 1: Singleton vs Factory

```dart
// ✅ registerLazySingleton — One instance for entire app
// Use for: Expensive resources (Dio, Firebase, Hive)
// Use for: App-level state (ThemeCubit, LanguageCubit)
getIt.registerLazySingleton<Dio>(
  () => DioClient(...).dio,
);

// ✅ registerFactory — New instance each time
// Use for: Cubits tied to pages/features
// Use for: Lightweight objects needing isolation
getIt.registerFactory<AuthCubit>(
  () => AuthCubit(
    signInUseCase: getIt<SignInUseCase>(),
  ),
);
```

### Pattern 2: Injection in Widgets

**✅ Correct — Injected from service locator:**
```dart
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),  // ✅ Get from service locator
      child: Scaffold(...),
    );
  }
}
```

**❌ Wrong — Created in widget:**
```dart
class LoginPage extends StatelessWidget {
  final authCubit = AuthCubit(...);  // ❌ Direct instantiation
  
  @override
  Widget build(BuildContext context) { ... }
}
```

### Pattern 3: Lazy Initialization

```dart
// ✅ Lazy — Dependencies created ONLY when first accessed
getIt.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(...),  // Called only on first getIt<AuthRepository>()
);

// ❌ Eager — All dependencies created immediately
final dio = DioClient(...).dio;  // Created at import time
```

## Common Circular Dependency Issues

### Issue: Repository A depends on Repository B, B depends on A

**❌ Problem:**
```dart
// This creates a circular dependency
getIt.registerLazySingleton<FeatureARepository>(
  () => FeatureARepositoryImpl(
    repositoryB: getIt<FeatureBRepository>(),  // ← B depends on A
  ),
);

getIt.registerLazySingleton<FeatureBRepository>(
  () => FeatureBRepositoryImpl(
    repositoryA: getIt<FeatureARepository>(),  // ← A depends on B
  ),
);
```

**✅ Solution: Extract common dependency**
```dart
// Create a shared service both depend on
getIt.registerLazySingleton<SharedService>(
  () => SharedServiceImpl(),
);

getIt.registerLazySingleton<FeatureARepository>(
  () => FeatureARepositoryImpl(
    sharedService: getIt<SharedService>(),  // Shared dependency
  ),
);

getIt.registerLazySingleton<FeatureBRepository>(
  () => FeatureBRepositoryImpl(
    sharedService: getIt<SharedService>(),  // Shared dependency
  ),
);
```

## Accessing Registered Dependencies

### In Widgets (BlocProvider):
```dart
BlocProvider(
  create: (_) => getIt<YourCubit>(),
  child: ...,
)
```

### In Use Cases:
```dart
class MyUseCase extends UseCase<String, MyParams> {
  final MyRepository repository;
  
  MyUseCase(this.repository);
  
  @override
  Future<Either<Failure, String>> call(MyParams params) {
    return repository.doSomething();
  }
}
```

### In Tests:
```dart
void main() {
  setUp(() {
    // Override with mock for testing
    getIt.registerSingleton<MyRepository>(
      MockMyRepository(),
      override: true,
    );
  });

  tearDown(() => getIt.reset());
}
```

## Registration Checklist

Before merging a new feature:

- [ ] All data sources registered
- [ ] All repositories registered
- [ ] All use cases registered
- [ ] All Cubits registered with correct scope (singleton/factory)
- [ ] No circular dependencies
- [ ] External services registered first
- [ ] No hardcoded service creation in widgets
- [ ] Tests can override dependencies with mocks

## Anti-Patterns

❌ **Creating services in widgets:**
```dart
class HomePage extends StatelessWidget {
  final repository = AuthRepositoryImpl(...);  // ❌
}
```

❌ **Mixing registration logic across files:**
```dart
// ❌ service_locator.dart registers half
// ❌ main.dart registers the other half
```

❌ **Singleton for stateful objects:**
```dart
// ❌ Wrong — Cubits should be factory (new instance per page)
getIt.registerSingleton<AuthCubit>(AuthCubit(...));
```

❌ **Registering everything as singleton:**
```dart
// ❌ Uses unnecessary memory, creates tight coupling
getIt.registerSingleton<EverySmallClass>(...);
```

## Debugging Service Locator Issues

### Error: "No instance of type XYZ found"

**Cause:** Dependency not registered

**Fix:**
```dart
// Add to service_locator.dart
getIt.registerLazySingleton<XYZ>(
  () => XYZImpl(...),
);
```

### Error: "MissingPluginException"

**Cause:** Async initialization not awaited

**Fix:**
```dart
// In main()
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(...);  // ✅ Await async
  await locatorSetup();              // ✅ Await locator setup
  
  runApp(...);
}
```

### Error: Circular dependency detected

**Fix:**
1. Identify the circular reference (A → B → A)
2. Extract common functionality to separate service
3. Both A and B depend on shared service

## Best Practices

✅ **Organize by layer** — External → Data → Domain → Presentation
✅ **Use descriptive names** — `AuthRepositoryImpl`, not `AuthRepo1`
✅ **Register once during startup** — All in `locatorSetup()`
✅ **Lazy-load expensive services** — Use `registerLazySingleton`
✅ **Factory for page-scoped Cubits** — New instance per page
✅ **Singleton for app-level services** — Shared state, Dio, Firebase
✅ **Never create services in widgets** — Always use `getIt<T>()`
✅ **Test with mocks** — Override with `override: true`
