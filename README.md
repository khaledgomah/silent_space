# 🧘 Silent Space

A premium, production-grade Flutter focus timer and productivity application designed to eliminate distractions, cultivate deep focus, and track productivity analytics. This project is built using a **Strict Clean Architecture**, **BLoC/Cubit state management**, and **Firebase** as the remote backend database.

> [!IMPORTANT]
> This project adheres to advanced architectural guardrails, ensuring 100% separation of concerns and high-security standards. It has undergone a comprehensive architectural audit to reach a **9.4/10** quality score. See [CLEAN_ARCHITECTURE_RULES.md](file:///H:/flutter%20old/silent_space/CLEAN_ARCHITECTURE_RULES.md) for more details.

---

## 🏗️ Architecture Blueprint

Silent Space utilizes **Strict Clean Architecture** to decouple business rules from external frameworks, user interfaces, and databases. The codebase is strictly partitioned into independent features under `lib/features/`, and shared resources under `lib/core/`.

### The Three Layers

```
                                  ┌────────────────────────┐
                                  │      Presentation      │ (UI & Cubits)
                                  └───────────┬────────────┘
                                              │
                                              ▼ (Imports contracts/UseCases)
┌────────────────────────┐        ┌────────────────────────┐
│          Data          ├───────>│         Domain         │ (Pure Logic & Entities)
│ (Models & DataSources) │        └────────────────────────┘
└────────────────────────┘
```

1. **Domain Layer**: The heart of the application. It contains the business logic, entities, and repository contracts (interfaces). It is **pure Dart** and contains **zero external dependencies** (no Flutter, Firebase, Hive, etc.).
   - **Entities**: Immutable business models extending `Equatable`.
   - **Repository Contracts**: Abstract classes defining the data interface.
   - **Use Cases**: Single-responsibility classes that execute specific business actions (e.g., [SignInUseCase](file:///H:/flutter%20old/silent_space/lib/features/auth/domain/usecases/sign_in_usecase.dart)).
2. **Data Layer**: Responsible for data retrieval and persistence.
   - **Models**: Data models extending entities to handle JSON/database serialization/deserialization (e.g., [SessionModel](file:///H:/flutter%20old/silent_space/lib/features/session/data/models/session_model.dart)).
   - **Data Sources**: Raw input/output implementations (e.g., fetching from Firebase Auth, Cloud Firestore, or local Hive caches).
   - **Repository Implementations**: Orchestrates data sources and implements the Domain repository interfaces. Any exceptions thrown in data sources must be caught and mapped to standard functional failures.
3. **Presentation Layer**: Encompasses the user interface and state management.
   - **Cubits/States**: Manages screen state using `flutter_bloc` (immutable states only).
   - **Pages**: Screen-level widgets registered in the router (e.g., [LoginPage](file:///H:/flutter%20old/silent_space/lib/features/auth/presentation/pages/login_page.dart)).
   - **Modular Widgets**: Sub-divided, stateless components to keep widget trees shallow and readable.

### Core Architectural Rules

*   **Dependency Direction**: Outer layers (Data and Presentation) depend on the inner layer (Domain). Domain **never** imports from Data or Presentation.
*   **Dependency Inversion**: Higher-level modules do not depend on lower-level modules; both depend on abstractions.
*   **Functional Error Handling**: All operations in the Domain layer return `Either<Failure, T>` using the `dartz` package, avoiding raw exception escapes.
*   **Dependency Injection**: Dependencies are registered lazily in [service_locator.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/service_locator.dart) and injected dynamically. Widget trees do not instantiate dependencies directly.

---

## 🛠️ Technology Stack

| Category | Technology & Package | Version | Purpose |
|---|---|---|---|
| **Framework** | [Flutter SDK](https://flutter.dev) | `^3.5.4` | Core cross-platform framework |
| **State Management** | [flutter_bloc](https://pub.dev/packages/flutter_bloc) | `^8.1.6` | Cubit state management for clear state transitions |
| **Backend & Auth** | [firebase_auth](https://pub.dev/packages/firebase_auth) | `^5.4.1` | User login, registration, and anonymous sessions |
| | [cloud_firestore](https://pub.dev/packages/cloud_firestore) | `^5.6.2` | Scalable cloud database for session history sync |
| | [google_sign_in](https://pub.dev/packages/google_sign_in) | `^6.2.2` | One-tap authentication using Google accounts |
| **Local Cache** | [hive](https://pub.dev/packages/hive) | `^2.2.3` | High-performance key-value local storage |
| **Security** | [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) | `^9.2.2` | Encrypted hardware-backed store for tokens/credentials |
| **Dependency Injection** | [get_it](https://pub.dev/packages/get_it) | `^7.2.0` | Light-weight Service Locator |
| | [flutter_getit](https://pub.dev/packages/flutter_getit) | `^3.0.1` | Seamless Flutter DI binding |
| **Functional Programming** | [dartz](https://pub.dev/packages/dartz) | `^0.10.1` | Either pattern for error handling |
| **Localization** | [easy_localization](https://pub.dev/packages/easy_localization) | `^3.0.7` | Out-of-the-box Arabic and English translation support |
| **Media & Audio** | [just_audio](https://pub.dev/packages/just_audio) | `^0.9.42` | Native audio engine for playing ambient sounds |
| **Analytics/Charts** | [mrx_charts](https://pub.dev/packages/mrx_charts) | `^0.1.3` | Beautiful charts for focus statistics |
| **UI Utilities** | [circular_countdown_timer](https://pub.dev/packages/circular_countdown_timer) | `^0.2.4` | Countdown indicator widget for Pomodoro timing |

---

## 📂 Project Structure

Below is the directory mapping of the project's source code:

```
silent_space/
├── .ai/                       # AI Prompt-Driven Development templates & reports
│   ├── AI_ECOSYSTEM.md        # Comprehensive AI integration documentation
│   ├── create-feature.md      # Template for building a new Clean Architecture feature
│   └── architecture-review.md # Template for doing code audits
├── assets/                    # Static assets including images, sounds, translations
│   ├── images/                # App icons and graphics
│   ├── sounds/                # Ambient background audios (Forest, Rain, etc.)
│   └── translations/          # Translation json files (en.json, ar.json)
├── lib/
│   ├── core/                  # Core modules shared across all features
│   │   ├── app/               # Root widget application config ([silent_space.dart](file:///H:/flutter%20old/silent_space/lib/core/app/silent_space.dart))
│   │   ├── cache/             # Hive local cache setup ([hive_service.dart](file:///H:/flutter%20old/silent_space/lib/core/cache/hive_service.dart))
│   │   ├── constants/         # App constants
│   │   ├── cubits/            # Global shared Cubits (e.g. [language_cubit.dart](file:///H:/flutter%20old/silent_space/lib/core/cubits/language_cubit/language_cubit.dart))
│   │   ├── errors/            # Custom failures and exception definitions
│   │   ├── network/           # Connectivity mapping ([network_info.dart](file:///H:/flutter%20old/silent_space/lib/core/network/network_info.dart))
│   │   ├── security/          # Hardware-backed [secure_storage_service.dart](file:///H:/flutter%20old/silent_space/lib/core/security/secure_storage_service.dart)
│   │   ├── theme/             # Theme settings (Light / Dark mode styling)
│   │   └── utils/             # Core utilities (e.g. [service_locator.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/service_locator.dart), routing)
│   └── features/              # Feature modules (strictly isolated)
│       ├── auth/              # Registration, Login, Google Sign-in, Password Reset
│       ├── home/              # Dashboard with Bottom Navigation & Stats Charts
│       ├── session/           # Saving, listing, and syncing focus sessions
│       ├── setting/           # Settings screens (Language, Theme, About, Feedback)
│       ├── splash/            # Landing screen with login check routing
│       └── time/              # Focus Timer countdown and ambient audio selection
└── test/                      # Comprehensive unit and widget tests
    ├── features/              # Mirroring structure of features for test coverage
    │   ├── auth/              # Tests for Authentication usecases & cubits
    │   ├── forgot_password/   # Tests for Forgot Password flow
    │   └── session/           # Tests for Session saving and fetching
    └── helpers/               # Testing mocks and fixtures
```

---

## 🎨 Feature Overview

### 🔒 Authentication
*   **Sign-in Options**: Supports email and password registry, Google login, and anonymous guest profiles.
*   **Security & Encryption**: Authenticated session tokens are refreshed dynamically on startup (`getIdToken(true)`) to protect Firebase interactions. Credentials are stored securely using KeyStore (Android) and Keychain (iOS) via [secure_storage_service.dart](file:///H:/flutter%20old/silent_space/lib/core/security/secure_storage_service.dart).
*   **Atomic Wipe**: Logging out or deleting an account executes an atomic cleanup of local secure storage and clears all cached Hive session history.

### ⏱️ Focus Timer
*   **Pomodoro Method**: Custom timers allow specifying focus duration, short break duration, and session category.
*   **Ambient Music**: Users can play high-quality atmospheric sounds (Rain, Nature, Forest, white noise) directly from the timer dashboard using [just_audio](https://pub.dev/packages/just_audio).
*   **State Persistence**: Focus sessions are tracked dynamically, and upon completion, auto-saved to database schemas.

### 📊 History & Analytics
*   **Offline First**: Focus sessions are written to Hive storage immediately upon completion, guaranteeing that user history is preserved even during offline usage.
*   **Cloud Synchronization**: Once connectivity is verified via connectivity trackers, Hive logs sync to Cloud Firestore.
*   **Visual Charts**: Displays daily, weekly, and total focus minutes in elegant, modern charts ([states_screen.dart](file:///H:/flutter%20old/silent_space/lib/features/home/presentation/widgets/states_screen.dart)).

### ⚙️ Settings & Personalization
*   **Dynamic Localization**: Seamless English & Arabic support utilizing [easy_localization](https://pub.dev/packages/easy_localization) with full RTL layout direction adaptation.
*   **Theme Control**: Quick Light and Dark theme toggles with animated transition switches.
*   **Interaction Forms**: Feedback module allowing users to compose and submit system diagnostics via email.

---

## 🚀 Getting Started

### Prerequisites

*   Flutter SDK: `^3.5.4`
*   Dart SDK: `^3.5.4`
*   Firebase CLI installed and configured.

### Local Setup

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/khaledgomah/silent_space.git
    cd silent_space
    ```

2.  **Install project dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Generate Generated Files**:
    The project uses code generators for Hive adapters (`HiveObject`). Build them using:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Configure Firebase**:
    If not already done, configure the Firebase project using the FlutterFire CLI:
    ```bash
    flutterfire configure
    ```
    This will generate [lib/firebase_options.dart](file:///H:/flutter%20old/silent_space/lib/firebase_options.dart).

5.  **Run the Application**:
    Ensure you have an emulator active or a physical device connected:
    ```bash
    flutter run
    ```

---

## 🧪 Testing Guidelines

Testing is treated as a first-class citizen in Silent Space. Every business rule defined in Domain requires a corresponding test.

### Running Tests

Execute the following command to run all unit and widget tests:
```bash
flutter test
```

### Coverage Structure

*   **Domain Tests**: Mock dependencies using `mocktail` to verify that use cases process arguments, perform correct repository calls, and output the correct `Either<Failure, T>` responses.
*   **Data Tests**: Verify that repository implementations correctly catch underlying client exceptions and map them to domain-safe `Failure` entities.
*   **Presentation Tests**: Test Cubit state streams and transitions in response to events, and write widget tests for critical interface flows.

---

## 🤖 AI Prompt-Driven Workflow

The project contains a built-in AI development ecosystem. In the [.ai/](file:///H:/flutter%20old/silent_space/.ai) directory, there are specialized Markdown prompt files that serve as instructions for AI tools to construct codebase features safely:

*   [create-feature.md](file:///H:/flutter%20old/silent_space/.ai/create-feature.md): Guideline for generating new features complying with Clean Architecture.
*   [architecture-review.md](file:///H:/flutter%20old/silent_space/.ai/architecture-review.md): Automated architectural auditing prompts.
*   [debugging.md](file:///H:/flutter%20old/silent_space/.ai/debugging.md): Template for resolving bugs in a thread-safe and Clean-conforming manner.
*   [testing.md](file:///H:/flutter%20old/silent_space/.ai/testing.md): Automated prompt for writing robust unit, mock, and widget tests.

Developers are highly encouraged to copy the content of these prompts into their AI assistants (like Copilot Chat or Gemini) when extending or modifying this project.

---

## 🚀 Development Roadmap

For the overall status of features and planned additions, see [PENDING_TASKS.md](file:///H:/flutter%20old/silent_space/PENDING_TASKS.md). Below is a summary of the phased roadmap:

*   **Phase 1 (UX & Branding)**: Add a custom onboarding slider sequence (`OnboardingCubit` and `OnboardingPage`), refine app logo branding, and support Remember Me checkbox.
*   **Phase 2 (Core Productivity)**: Upgrade Pomodoro Timer with background services to maintain time ticking during device lock screen, add daily goals tracker, and extend focus session charts.
*   **Phase 3 (Settings & Profile)**: Complete user avatar selection and profile update screen, support customized reminders.
*   **Phase 4 (Quality Assurance)**: Compress all media assets to optimize bundle size, reach 90%+ testing coverage across all Cubits.

---

## 📄 Architectural Guidelines & Reference Docs

*   [CLEAN_ARCHITECTURE_RULES.md](file:///H:/flutter%20old/silent_space/CLEAN_ARCHITECTURE_RULES.md): Read this to understand the boundary layers and rule enforcements.
*   [FEATURE_GUIDELINES.md](file:///H:/flutter%20old/silent_space/FEATURE_GUIDELINES.md): Follow this checklist when implementing any new features.
*   [TROUBLESHOOTING.md](file:///H:/flutter%20old/silent_space/TROUBLESHOOTING.md): Known issues, resolutions, and environment setups.
