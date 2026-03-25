# 🧘 Silent Space

A production-quality Flutter focus timer application built with **Clean Architecture**, **BLoC state management**, and modern best practices.

> Built to demonstrate real-world Flutter engineering — not a tutorial demo.

## 🏗️ Architecture

```
Clean Architecture (3 layers per feature)
├── Domain    → Entities, Repository contracts, Use Cases
├── Data      → Models, Data Sources (remote/local), Repository implementations
└── Presentation → Cubits/BLoCs, Pages, Widgets
```

| Principle | How It's Applied |
|-----------|-----------------|
| **SOLID** | Each use case has a single responsibility; repositories are injected via abstract contracts |
| **Dependency Inversion** | Domain layer has zero dependencies on data/presentation |
| **Either Pattern** | All repository methods return `Either<Failure, T>` — no exceptions leak to the UI |

## 📁 Folder Structure

```
lib/
├── app/
│   ├── cubits/language_cubit/     # Language switching (en/ar)
│   └── silent_space.dart          # Root MaterialApp
├── core/
│   ├── cache/                     # HiveService
│   ├── errors/                    # Failures & Exceptions
│   ├── network/                   # DioClient, NetworkInfo
│   ├── security/                  # SecureStorageService
│   ├── theme/                     # AppTheme, ThemeCubit
│   ├── usecases/                  # Base UseCase<T, Params>
│   ├── utils/                     # Constants, Routes, ServiceLocator
│   └── widgets/                   # Shared widgets
├── features/
│   ├── auth/                      # Login/Register (reqres.in API)
│   │   ├── data/
│   │   │   ├── implements/        # AuthRepositoryImpl
│   │   │   ├── models/            # UserModel
│   │   │   └── sources/           # Remote (Dio) + Local (SecureStorage)
│   │   ├── domain/
│   │   │   ├── entities/          # UserEntity
│   │   │   ├── repositories/      # AuthRepository (abstract)
│   │   │   └── usecases/          # SignIn, SignUp, SignOut
│   │   └── presentation/
│   │       ├── cubit/             # AuthCubit + AuthState
│   │       └── pages/             # LoginPage, RegisterPage
│   ├── session/                   # Focus session history (Hive)
│   │   ├── data/
│   │   │   ├── implements/
│   │   │   ├── models/            # SessionModel (@HiveType)
│   │   │   └── sources/
│   │   └── domain/
│   │       ├── entities/
│   │       ├── repositories/
│   │       └── usecases/
│   ├── home/                      # Bottom nav shell
│   ├── setting/                   # Settings, language, feedback
│   ├── splash/                    # Splash screen
│   └── time/                      # Pomodoro timer + ambient sounds
├── generated/                     # Localization (intl)
└── l10n/                          # ARB files (en + ar)
```

## 🔧 Tech Stack

| Category | Technology |
|----------|-----------|
| State Management | `flutter_bloc` (Cubit pattern) |
| Networking | `Dio` with interceptors (auth, error, logging) |
| Local DB | `Hive` (session history) |
| Secure Storage | `flutter_secure_storage` (JWT tokens) |
| Dependency Injection | `get_it` |
| Error Handling | `dartz` Either pattern |
| Localization | `intl` (English + Arabic) |
| Testing | `mocktail` |

## 🚀 Setup

```bash
# Clone
git clone <repo-url>
cd silent_space

# Install dependencies
flutter pub get

# Run
flutter run

# Run tests
flutter test
```

## 🔐 Authentication

Uses [reqres.in](https://reqres.in) — a free, public REST API.

**Test credentials:**
- Email: `eve.holt@reqres.in`
- Password: `cityslicka`

Tokens are stored in `flutter_secure_storage` (hardware-backed keystore on Android, Keychain on iOS).

## 🧪 Testing

```bash
flutter test
```

| Test File | Coverage |
|-----------|----------|
| `sign_in_usecase_test.dart` | Success, server failure, network failure |
| `sign_up_usecase_test.dart` | Success, server failure |
| `auth_repository_impl_test.dart` | Network check, offline, remote success + token cache, server exception, sign-out, isLoggedIn |
| `save_session_usecase_test.dart` | Success, cache failure |

## 📸 Screenshots

<!-- Add screenshots here -->
| Login | Home | Settings |
|-------|------|----------|
| ![Login](screenshots/login.png) | ![Home](screenshots/home.png) | ![Settings](screenshots/settings.png) |

## 📄 License

This project is for portfolio/demonstration purposes.
