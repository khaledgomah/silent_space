# 🧘 Silent Space - Missed Findings Report

This report documents features, technical debt, architectural issues, and testing gaps that were not identified in the initial project audits.

---

## 🧪 1. Testing Gaps (Critical Gaps Identified)

During our verification re-audit, we identified massive testing gaps that were initially misreported as covered:

### A. Untested Cubits (6 out of 7 Cubits Untested)
The codebase implements 7 core Cubits, but only **one** (`SessionCubit`) has unit tests. The following Cubits have **zero test coverage**:
1.  `AuthCubit` - Manages all registry, login, logout, and deletion states.
2.  `ForgotPasswordCubit` - Manages token verification and resets.
3.  `TimerCubit` - Manages focus/break ticking state and audio controls.
4.  `ThemeCubit` - Manages dark/light theme switching.
5.  `LanguageCubit` - Manages translation locale states.
6.  `SplashCubit` - Manages startup authentication routing.

### B. Untested Use Cases (3 Auth Use Cases Untested)
The following use cases under domain have **zero test coverage**:
1.  `SignInAnonymouslyUseCase`
2.  `SignInWithGoogleUseCase`
3.  `LinkAccountUseCase`

### C. Untested Core Screens (Zero Widget Tests)
Almost all main screens are completely untested. The following have **zero widget tests**:
1.  `SplashView`
2.  `LoginPage`
3.  `RegisterPage`
4.  `HomeView`
5.  `TimerView`
6.  `SettingScreen`
7.  `CategoriesScreen`
8.  `FeedbackScreen`
9.  `HowToUseScreen`
10. `AboutAppScreen`

---

## 🏗️ 2. Architectural Issues (Newly Identified)

### A. Dynamic Service Locator Lookups in Cubits
*   **File**: [timer_cubit.dart](file:///H:/flutter%20old/silent_space/lib/features/time/presentation/manager/timer_cubit/timer_cubit.dart#L17-L25)
*   **Issue**: Instantiates `_prefs = getIt<SharedPreferences>()` directly inside the constructor body instead of passing it as a constructor parameter.
*   **Impact**: Makes unit testing difficult because dependencies must be stubbed inside the global GetIt container rather than injected directly during instantiation.

### B. Apple Sign-In UI Presence with Zero Implementation
*   **File**: [social_login_buttons.dart](file:///H:/flutter%20old/silent_space/lib/features/auth/presentation/widgets/social_login_buttons.dart#L26)
*   **Issue**: Apple Sign-In button is rendered in the UI and accepts a callback, but there is no Apple sign-in implementation in repositories or remote data sources.

---

## 🚨 3. Technical Debt & UI Bugs

### A. Redundant Forgot Password Test Directory Structure
*   **Folder**: `test/features/forgot_password`
*   **Issue**: Contains empty `data`, `domain/usecases`, and `presentation/pages` folders. All actual forgot password tests reside inside `test/features/auth`. This structure is redundant dead weight.

### B. Ignored Feedback Email Input
*   **File**: [feedback.dart](file:///H:/flutter%20old/silent_space/lib/features/setting/presentation/feedback.dart)
*   **Issue**: The user's input email (`_emailController.text`) is checked for validation, but it is never passed to `FlutterEmailSender.send(email)`. The sent email contains only the feedback text body, throwing away the user's return address.
