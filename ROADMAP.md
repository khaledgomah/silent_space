# 🧘 Silent Space - Project Roadmap

This roadmap lists chronological improvement tasks categorized by urgency (NOW, NEXT, LATER).

---

## 📅 NOW (Immediate Fixes & Critical Debt)
Tasks that must be fixed immediately to stabilize the current implementation and restore architectural clean-ness:

1.  **Resolve Presentation Memory Leak**:
    *   Refactor [feedback.dart](file:///H:/flutter%20old/silent_space/lib/features/setting/presentation/feedback.dart) into a `StatefulWidget` and implement the `dispose()` method to dispose controllers.
2.  **Fix Clean Architecture Violation in TimerCubit**:
    *   Remove `FirebaseAuth.instance` from [timer_cubit.dart](file:///H:/flutter%20old/silent_space/lib/features/time/presentation/manager/timer_cubit/timer_cubit.dart#L91). Pass the active user ID from the UI widget using the BLoC provider state.
3.  **Restore iOS Notifications**:
    *   Add `iOS: const DarwinNotificationDetails()` to [notification_service.dart](file:///H:/flutter%20old/silent_space/lib/core/notifications/notification_service.dart) to fix iOS notifications.
4.  **Complete Testing Coverage for Core Cubits**:
    *   Write unit tests for `AuthCubit`, `ForgotPasswordCubit`, `TimerCubit`, `ThemeCubit`, `LanguageCubit`, and `SplashCubit` to bring Cubit coverage to 100%.
5.  **Test Missing Auth UseCases**:
    *   Add tests for `SignInAnonymouslyUseCase`, `SignInWithGoogleUseCase`, and `LinkAccountUseCase`.

---

## 📅 NEXT (Feature Enhancements & Offline Support)
Tasks that improve functionality and robustness:

1.  **Resolve Startup Token Refresh Bypass**:
    *   Update `isLoggedIn()` in [auth_repository_impl.dart](file:///H:/flutter%20old/silent_space/lib/features/auth/data/implements/auth_repository_impl.dart) to validate tokens online against Firebase Auth, rather than bypassing online validation if a cached token exists.
2.  **Implement Offline fallbacks for Sessions**:
    *   Update [session_repository_impl.dart](file:///H:/flutter%20old/silent_space/lib/features/session/data/implements/session_repository_impl.dart) to read from Hive cache when Firestore database queries fail.
    *   Modify `saveSession` to complete successfully even if Firestore is offline, scheduling background sync when network returns.
3.  **Move Category persistence to CA Layers**:
    *   Implement settings repository contracts and use cases to manage categories. Eliminate direct calls to shared preferences in widgets.
4.  **Connect Ignored Name & Remember Me Fields**:
    *   Wire up username saving in signup and pre-fill email field in login.

---

## 📅 LATER (Polishing & Production Deployment)
Nice-to-have features for future expansion:

1.  **Widget UI testing**:
    *   Implement widget tests for `LoginPage`, `RegisterPage`, `SplashView`, and `TimerView`.
2.  **Background ticking Support**:
    *   Implement a native background service so the timer keeps running reliably when the app is backgrounded.
3.  **Onboarding Slider Sequence**:
    *   Build `OnboardingPage` with custom slide controllers explaining the focus timer philosophy.
4.  **Asset compression**:
    *   Compress the MP3 audio assets in `assets/sounds/` to reduce final bundle size.
