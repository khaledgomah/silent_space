# 🧘 Silent Space - Technical Debt Registry

This file acts as a ledger of all technical debt in the Silent Space codebase. It classifies issues by severity and outlines action plans to fix them.

---

## 🚨 Critical Priority Issues

### 1. Memory Leak in `FeedbackScreen`
*   **File**: [feedback.dart](file:///H:/flutter%20old/silent_space/lib/features/setting/presentation/feedback.dart)
*   **Issue**: Instantiates `TextEditingController` objects as final variables inside a `StatelessWidget`. Since it is a stateless widget, it cannot override `dispose()`, meaning the controllers are never freed from memory when the page is popped.
*   **Impact**: Memory footprint grows every time the user visits the feedback page.
*   **Remediation**: Convert `FeedbackScreen` to a `StatefulWidget` and dispose both controllers in the `dispose()` method.

---

## ⚠️ High Priority Issues

### 1. Massive Testing Gaps (Core Cubits & Auth Usecases)
*   **Issues**:
    *   **6 out of 7 Cubits are completely untested** (including `AuthCubit`, `ForgotPasswordCubit`, `TimerCubit`, `ThemeCubit`, `LanguageCubit`, and `SplashCubit`). Only `SessionCubit` is covered.
    *   **3 critical Auth UseCases are completely untested** (`SignInAnonymouslyUseCase`, `SignInWithGoogleUseCase`, and `LinkAccountUseCase`).
*   **Impact**: Critical business logic changes could easily break core application features without triggering test failures.
*   **Remediation**: Write comprehensive unit tests for all six cubits and three use cases using `bloc_test` and `mocktail`.

### 2. Direct Backend Import in Presentation Cubit
*   **File**: [timer_cubit.dart](file:///H:/flutter%20old/silent_space/lib/features/time/presentation/manager/timer_cubit/timer_cubit.dart#L91)
*   **Issue**: Queries `FirebaseAuth.instance.currentUser` directly inside the presentation layer manager to get the active user ID. This bypasses the domain repository layer and couples the cubit directly to Firebase Auth.
*   **Impact**: Violates strict Clean Architecture import constraints. Makes unit testing `TimerCubit` dependent on initializing Firebase Core.
*   **Remediation**: Pass the active user ID as a parameter to the `completeSession(..., String userId)` method from the UI layer, or observe the `AuthCubit` state.

### 3. Missing iOS Notification Details
*   **File**: [notification_service.dart](file:///H:/flutter%20old/silent_space/lib/core/notifications/notification_service.dart#L34)
*   **Issue**: `NotificationDetails` is constructed only with `android: androidDetails`. The `iOS` field is omitted.
*   **Impact**: iOS devices will fail to show notifications with custom titles/bodies, showing blank or default alerts.
*   **Remediation**: Add `iOS: const DarwinNotificationDetails()` inside the `NotificationDetails` initialization block.

### 4. Startup Token Refresh Bypass
*   **File**: [auth_repository_impl.dart](file:///H:/flutter%20old/silent_space/lib/features/auth/data/implements/auth_repository_impl.dart#L155-L171)
*   **Issue**: The remote validation is bypassed if a local token is cached. The token is never checked online on session startup.
*   **Impact**: Users with disabled or deleted Firebase accounts could still be treated as logged in locally.
*   **Remediation**: Call `remoteDataSource.isLoggedIn()` to validate and refresh the token online at startup, and clear local state if invalid.

---

## ⚡ Medium Priority Issues

### 1. Untested Main User Views (LoginPage, RegisterPage, SplashView, TimerView)
*   **Issue**: Major user-facing pages have **zero widget tests**.
*   **Impact**: UI regressions can go unnoticed.
*   **Remediation**: Implement widget testing using Flutter's test package to ensure core elements render and submit properly.

### 2. Category Management Bypassing CA Layers
*   **File**: [category_functions.dart](file:///H:/flutter%20old/silent_space/lib/features/setting/helper/category_functions.dart)
*   **Issue**: Settings categories are retrieved and written directly from the UI layer calling raw functions wrapping `SharedPreferencesWithCache`.
*   **Impact**: Violates Clean Architecture by skipping Domain contracts, Data repositories, and Usecases.
*   **Remediation**: Implement a `SettingRepository` contract in the Domain layer, a local setting data source, and settings UseCases (e.g. `SaveCategoriesUseCase`, `GetCategoriesUseCase`).

### 3. Broken Offline-First Fetch & Sync
*   **File**: [session_repository_impl.dart](file:///H:/flutter%20old/silent_space/lib/features/session/data/implements/session_repository_impl.dart)
*   **Issue**: `getSessionsByDateRange` queries Firestore directly. If offline, the stats screen fails to load instead of falling back to the Hive local cache.
*   **Remediation**: Implement repository fallbacks to read Hive cached sessions if Firestore calls fail.

---

## 🟢 Low Priority Issues

### 1. Ignored Username during SignUp
*   **File**: [register_form.dart](file:///H:/flutter%20old/silent_space/lib/features/auth/presentation/widgets/register_form.dart)
*   **Issue**: The user enters their name, but the submit function only passes email and password to the registry use case. The name is completely lost.
*   **Remediation**: Extend `SignUpUseCase` and `AuthRepository` to accept an optional name parameter and update the user profile in Firebase.

### 2. Missing "Remember Me" Implementation
*   **File**: [login_form.dart](file:///H:/flutter%20old/silent_space/lib/features/auth/presentation/widgets/login_form.dart)
*   **Issue**: The remember me checkbox callback is empty.
*   **Remediation**: Use `SharedPreferences` to write the user email if Checked, and read it on page load to prefill the email field.

### 3. Dead / Duplicate Test Directory Structure
*   **Folder**: `test/features/forgot_password`
*   **Issue**: A redundant folder structure containing empty `data`, `domain/usecases`, and `presentation/pages` directories exists because all forgot password tests are actually written in `test/features/auth`.
*   **Remediation**: Safely remove the empty `test/features/forgot_password` folder structure.
