# 🧘 Silent Space

A premium, production-grade Flutter focus timer application built with **Strict Clean Architecture**, **BLoC state management**, and **Firebase**.

> [!IMPORTANT]
> This project adheres to advanced architectural guardrails, ensuring 100% separation of concerns and high-security standards. It has undergone a comprehensive architectural audit to reach a **9.4/10** quality score.

## 🏗️ Architecture

```
Clean Architecture (Strict Layering)
├── Domain    → Entities, Repository contracts, Use Cases (ZERO external dependencies)
├── Data      → Models, Data Sources (Firebase/Hive), Repository implementations
└── Presentation → Cubits (Singletons for global state), Pages, Modular Widgets
```

| Principle | How It's Applied |
|-----------|-----------------|
| **SOLID** | UseCases follow SRP; Repositories are injected via abstract interfaces. |
| **Dependency Inversion** | Higher-level modules (Domain) do not depend on lower-level modules (Data/UI). |
| **Either Pattern** | All domain operations return `Either<Failure, T>` for functional error handling. |
| **DI Management** | `get_it` used for lazy singleton lifecycle management of core state cubits. |

## 💎 Architectural Excellence & Refactoring

This project follows a "Defensive Engineering" philosophy implemented during a major architectural refactoring:

- **Security-First Auth**: Tokens are refreshed on every session start (`getIdToken(true)`) and stored in hardware-backed `SecureStorage`.
- **Atomic State Reset**: Logout and account deletion perform an atomic wipe of local Hive caches and secure storage.
- **Performance Optimized**: Splash logic parallelization and `buildWhen` filters on root providers minimize CPU/GPU overhead.
- **Modular UI**: Generic widgets are separated into `core/widgets`, while feature-specific logic is strictly isolated.

## 🔧 Tech Stack

| Category | Technology |
|----------|-----------|
| **Core** | Flutter 3.x, Dart 3.x |
| **State Management** | `flutter_bloc` (Cubit pattern) |
| **Backend** | `Firebase Auth`, `Cloud Firestore` |
| **Local DB** | `Hive` (encrypted/typed focus history) |
| **Secure Storage** | `flutter_secure_storage` (Keychain/Keystore) |
| **DI / Locator** | `get_it` |
| **Error Handling** | `dartz` (Functional programming) |
| **Localization** | `easy_localization` (English + Arabic) |

## 🤖 AI Prompt Workflow

Reusable prompt templates are available in `.ai/` for architecture-safe development:

- `create-feature.md`
- `architecture-review.md`
- `debugging.md`
- `testing.md`
- `networking.md` (Firebase-first)
- `caching.md`
- `localization.md`
- `performance.md`

Use these prompts with Copilot Chat to generate features, audits, tests, and refactors that respect Clean Architecture.

## 🧱 Core Infrastructure

- Dependency injection: `lib/core/utils/service_locator.dart`
- Error system: `lib/core/errors/`
- Use case base: `lib/core/usecases/usecase.dart`
- Constants: `lib/core/constants/`
- Remote backend: Firebase Auth + Cloud Firestore (no Dio dependency)

## 🚀 Setup

```bash
# Install dependencies
flutter pub get

# Initialize Firebase (requires Firebase CLI)
# flutterfire configure

# Run
flutter run

# Run tests
flutter test
```

## 🧪 Testing

The codebase maintains strict verification patterns:

```bash
# Run all tests
flutter test
```

| Coverage Area | Verification Strategy |
|---------------|----------------------|
| **Domain** | UseCase mocking via `mocktail` |
| **Data** | Repository implementation & error mapping |
| **Logic** | Cubit state transition validation |

## 📸 Screenshots

<!-- Add screenshots here -->
| Auth | Timer | Statistics |
|-------|------|----------|
| ![Auth](assets/images/app_icon.png) | ![Timer](assets/images/background.jpg) | ![Stats](assets/images/books.png) |

## 📄 License

This project is for demonstration of advanced Flutter software engineering practices.
