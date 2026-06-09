# 🤖 Silent Space - AI Developer Onboarding Context

This file serves as the permanent system context for future AI coding agents working on Silent Space. It outlines architectural standards, key files, dependencies, known issues, and guidelines.

---

## 🏗️ Architecture System

Silent Space implements **Clean Architecture** on a per-feature basis.

```
lib/
├── core/                  # Shared utilities, constants, errors, and widgets
└── features/              # Feature-first domain modules
    └── {feature}/
        ├── domain/        # Entities, Use Cases, Repositories contracts
        ├── data/          # Models, Data Sources, Repositories implementations
        └── presentation/  # Cubits, Pages, Widgets
```

### 1. Import Rules
*   **Domain**: Must not import Flutter packages, Firebase, Hive, or anything outside of Dart core and Equatable/Dartz.
*   **Data**: May import Domain. Orchestrates DataSources. Translates exceptions to standard `Failure` classes.
*   **Presentation**: Imports Domain (UseCases, Contracts). Never imports Data sources or Models. Handles State using Cubits.

### 2. Functional Error Contract
All Domain UseCases and Repository functions return `Future<Either<Failure, T>>`. Failures are mapped to user-friendly messages using `FailureMapper`.

---

## 🛠️ Tech Stack & Key Dependencies

*   **State Management**: `flutter_bloc` (Cubit pattern)
*   **Service Locator**: `get_it` (lazy lifecycle singletons configured in [service_locator.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/service_locator.dart))
*   **Local Caching**: `hive` and `hive_flutter` (Adapters registered in service locator)
*   **Secure Storage**: `flutter_secure_storage` (used for session tokens)
*   **Audio Engine**: `just_audio` (ambient noise playback)
*   **Localization**: `easy_localization` (EN/AR JSON files in `assets/translations/`)

---

## 📂 Key File Registry

*   [service_locator.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/service_locator.dart): Main DI setup registering UseCases, repositories, and BLoC cubits.
*   [on_generate_route.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/on_generate_route.dart): Centralized application routing structure.
*   [silent_space.dart](file:///H:/flutter%20old/silent_space/lib/core/app/silent_space.dart): Root widget hosting MultiBlocProviders and Material Theme wrappers.
*   [session_model.dart](file:///H:/flutter%20old/silent_space/lib/features/session/data/models/session_model.dart): Hive object mapping for focus sessions.
*   [timer_cubit.dart](file:///H:/flutter%20old/silent_space/lib/features/time/presentation/manager/timer_cubit/timer_cubit.dart): Audio playback state and timer setup.

---

## ⚠️ Known Structural Issues & Technical Debt

Future AI sessions should address the following issues immediately:

1.  **Massive Testing Gaps**:
    *   **6 out of 7 Cubits are completely untested** (`AuthCubit`, `ForgotPasswordCubit`, `TimerCubit`, `ThemeCubit`, `LanguageCubit`, and `SplashCubit`). Only `SessionCubit` is covered.
    *   **3 critical Auth UseCases are completely untested** (`SignInAnonymouslyUseCase`, `SignInWithGoogleUseCase`, and `LinkAccountUseCase`).
    *   Almost all views (`LoginPage`, `RegisterPage`, `SplashView`, `TimerView`) have **zero widget tests**.
2.  **Memory Leak in Settings Feedback**:
    *   **File**: [feedback.dart](file:///H:/flutter%20old/silent_space/lib/features/setting/presentation/feedback.dart)
    *   **Issue**: `TextEditingController` objects inside `StatelessWidget` are never disposed. Convert to `StatefulWidget` and call `dispose()`.
3.  **Firebase Client Leak in Presentation**:
    *   **File**: [timer_cubit.dart](file:///H:/flutter%20old/silent_space/lib/features/time/presentation/manager/timer_cubit/timer_cubit.dart#L91)
    *   **Issue**: Presentation Cubit references `FirebaseAuth.instance` directly. Pass user ID as a parameter to the completion method from the UI.
4.  **Startup Token Refresh Bypass**:
    *   **File**: [auth_repository_impl.dart](file:///H:/flutter%20old/silent_space/lib/features/auth/data/implements/auth_repository_impl.dart#L155-L171)
    *   **Issue**: Remote isLoggedIn checks are bypassed if a local token exists, allowing stale session state.
5.  **Bypassing Layers for Setting Screen Categories**:
    *   **File**: [category_functions.dart](file:///H:/flutter%20old/silent_space/lib/features/setting/helper/category_functions.dart)
    *   **Issue**: Renders direct shared preference caching operations in the UI helper. Move to clean architecture repository wrappers.
6.  **Offline Database Read Fallback**:
    *   **File**: [session_repository_impl.dart](file:///H:/flutter%20old/silent_space/lib/features/session/data/implements/session_repository_impl.dart)
    *   **Issue**: Fetches history directly from Firestore without Hive fallback. When offline, stats views fail.
