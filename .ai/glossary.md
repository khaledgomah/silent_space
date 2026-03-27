---
description: Silent Space project glossary and domain-specific terminology
---

# Silent Space Glossary

**Reference:** Key terms, acronyms, and domain concepts used throughout the codebase.

## Architecture & Design Patterns

| Term                   | Definition                                                                                                  |
| ---------------------- | ----------------------------------------------------------------------------------------------------------- |
| **Clean Architecture** | Three-layer architecture separating Domain, Data, and Presentation layers without cross-layer dependencies  |
| **Domain Layer**       | Pure Dart business logic; defines entities, repository contracts, and use cases. Zero external dependencies |
| **Data Layer**         | Implements repositories; contains models, data sources (remote/local), and data mapping logic               |
| **Presentation Layer** | UI implementation using Cubits for state management; displays domain entities to users                      |
| **Repository Pattern** | Abstraction that coordinates data from multiple sources (API, cache, local DB)                              |
| **Use Case**           | Encapsulates a business rule; takes input parameters and returns `Either<Failure, T>` result                |
| **Entity**             | Core business object in domain layer; immutable, pure Dart class                                            |
| **Model**              | Data-layer representation of entities; maps to/from JSON, database, or API responses                        |
| **Either<Failure, T>** | Functional result type from `dartz` package; represents error (Left/Failure) or success (Right/T)           |

## State Management

| Term             | Definition                                                                              |
| ---------------- | --------------------------------------------------------------------------------------- |
| **Cubit**        | Simplified BLoC for state management; emits state changes via `emit()`                  |
| **State**        | Immutable class representing app state at a point in time; extends `Equatable`          |
| **Emit**         | Method to push new state to listeners via Cubit; replaces mutation                      |
| **BlocBuilder**  | Widget that rebuilds when Cubit emits new state                                         |
| **BlocListener** | Widget that executes side effects (navigation, toast) when state changes                |
| **BlocSelector** | Performance optimization; rebuilds only when selected portion of state changes          |
| **Side Effect**  | Action triggered by state change (e.g., navigate, show dialog); handled in BlocListener |

## Data & Persistence

| Term                   | Definition                                                                       |
| ---------------------- | -------------------------------------------------------------------------------- |
| **Hive**               | Local key-value NoSQL database for offline persistence and caching               |
| **Hive Box**           | A collection/table in Hive; each box stores one data type                        |
| **TypeAdapter**        | Code generator pattern for Hive models; registers type IDs for serialization     |
| **SharedPreferences**  | Simple key-value storage for app settings and preferences                        |
| **Secure Storage**     | Encrypted storage for sensitive data (JWT tokens, passwords)                     |
| **Cache**              | Temporary storage of API responses for offline access; includes TTL/invalidation |
| **Cache Invalidation** | Removing stale cache to force fresh data fetch                                   |
| **Remote Data Source** | Dio client interface for API requests (Firebase, REST, GraphQL)                  |
| **Local Data Source**  | Hive/SQLite interface for offline data access                                    |
| **Offline-First**      | Pattern prioritizing local cache; syncs to remote when online                    |

## Networking & API

| Term                  | Definition                                                                                    |
| --------------------- | --------------------------------------------------------------------------------------------- |
| **Dio**               | HTTP client library for REST APIs; supports interceptors, retries, timeouts                   |
| **Interceptor**       | Middleware that intercepts requests/responses (auth headers, error handling, logging)         |
| **Request/Response**  | HTTP message; request includes method/body/headers, response includes status/data             |
| **API Endpoint**      | Named URL path for a specific API operation (e.g., `/sessions`, `/auth/signin`)               |
| **Server Exception**  | Exception thrown on API error (4xx, 5xx); caught by repository and mapped to Failure          |
| **Network Exception** | Exception thrown on connectivity issues (timeout, no internet); mapped to NetworkFailure      |
| **JWT Token**         | JSON Web Token for stateless authentication; stored securely and sent in Authorization header |
| **Refresh Token**     | Long-lived token used to obtain new access token when expired                                 |
| **Interceptor Chain** | Multiple interceptors executed in order for request preprocessing and error handling          |

## Error Handling

| Term                      | Definition                                                                                              |
| ------------------------- | ------------------------------------------------------------------------------------------------------- |
| **Failure**               | Typed error object representing domain-level failures (ServerFailure, CacheFailure, etc.); never thrown |
| **Exception**             | Thrown error from API/database; caught in repositories and mapped to Failure                            |
| **Exception Handler**     | Mapping logic converting specific exceptions to typed Failures                                          |
| **User-Friendly Message** | String shown to user for failure (e.g., "Session saved successfully") vs. technical error               |
| **Retry Logic**           | Automatic re-attempt of failed transient operations (timeout, 5xx) with exponential backoff             |
| **Graceful Degradation**  | Handling failure by returning cached data or reduced functionality instead of crashing                  |

## Dependency Injection (DI)

| Term                    | Definition                                                                                  |
| ----------------------- | ------------------------------------------------------------------------------------------- |
| **Service Locator**     | `get_it` package; central registry for all app dependencies                                 |
| **Injection**           | Providing dependencies to classes via constructor instead of creating internally            |
| **Singleton**           | One instance shared across entire app lifetime; registered with `registerLazySingleton`     |
| **Factory**             | New instance created each time; registered with `registerFactory`                           |
| **Lazy Singleton**      | Singleton created on first access, not at startup                                           |
| **Override**            | Temporarily replace registered dependency for testing; `override: true`                     |
| **Circular Dependency** | A → B → A; architectural flaw indicating poor separation of concerns                        |
| **Locator Setup**       | Initialization function (`locatorSetup()`) registering all dependencies; called in `main()` |

## Localization & Internationalization

| Term                     | Definition                                                                         |
| ------------------------ | ---------------------------------------------------------------------------------- |
| **i18n / i18l**          | Internationalization; adapting app for multiple languages                          |
| **L10n**                 | Localization; translating strings to specific languages (en, ar, etc.)             |
| **AppStrings**           | Constants class mapping translation keys (e.g., `AppStrings.welcomeTitle.tr()`)    |
| **Translation File**     | JSON files (`en.json`, `ar.json`) containing key-value translation pairs           |
| **Localization Package** | `easy_localization` package; provides `.tr()` extension and multi-language support |
| **Supported Locales**    | Languages the app supports (English, Arabic)                                       |
| **Fallback Locale**      | Default language if requested locale unavailable                                   |
| **Placeholder**          | Dynamic value in translation string (e.g., "Hello {name}")                         |

## UI & Widgets

| Term                  | Definition                                                                          |
| --------------------- | ----------------------------------------------------------------------------------- |
| **StatelessWidget**   | Immutable widget with no internal state; preferred pattern                          |
| **StatefulWidget**    | Mutable widget with `State` class; avoid in favor of Cubits                         |
| **Widget Tree**       | Hierarchy of nested widgets building the UI                                         |
| **Build Method**      | Function rebuilding widget UI; should be pure (no side effects)                     |
| **Const Constructor** | Compile-time constant constructor; required for performance optimization            |
| **Widget Extraction** | Breaking large `build()` methods into smaller widget classes (max 3 nesting levels) |
| **Custom Widget**     | Reusable UI component composed from basic widgets                                   |
| **Theme**             | Centralized colors, typography, spacing for consistent UI                           |
| **Material Design**   | Google's design system; followed by Silent Space                                    |

## Testing

| Term                   | Definition                                                                  |
| ---------------------- | --------------------------------------------------------------------------- |
| **Unit Test**          | Tests a single class/function in isolation (domain use cases, repositories) |
| **Widget Test**        | Tests widget rendering and interaction without platform code                |
| **BDD Naming**         | Behavior-Driven Development naming: `testWhen_ShouldExpectWhat()`           |
| **Mock**               | Fake object replacing real dependency for testing; created with `mocktail`  |
| **Arrange-Act-Assert** | Test structure: setup (arrange), execute (act), verify (assert)             |
| **Test Coverage**      | Percentage of code executed by tests; target ≥70% for domain/data           |
| **Fixture**            | Test data (JSON, model instance) used across multiple tests                 |
| **setUp/tearDown**     | Test lifecycle hooks; `setUp()` before each test, `tearDown()` after        |

## Feature Structure

| Term                    | Definition                                                                                         |
| ----------------------- | -------------------------------------------------------------------------------------------------- |
| **Feature**             | Self-contained module (auth, session, settings, home, time); organized in domain/data/presentation |
| **Feature Isolation**   | Features depend only on domain contracts, not directly on other features                           |
| **Domain Module**       | `features/{feature}/domain/`; entities, repository contracts, use cases                            |
| **Data Module**         | `features/{feature}/data/`; models, data sources, repository implementations                       |
| **Presentation Module** | `features/{feature}/presentation/`; Cubits, pages, widgets                                         |

## Firebase & Cloud Services

| Term                         | Definition                                                                  |
| ---------------------------- | --------------------------------------------------------------------------- |
| **Firebase**                 | Google's backend-as-a-service; provides auth, Firestore, storage, messaging |
| **Firestore**                | NoSQL document database; stores user sessions, settings, feedback data      |
| **Firebase Authentication**  | User sign-in/sign-up service with email, phone, OAuth providers             |
| **Firestore Security Rules** | Server-side rules enforcing authentication and data ownership               |
| **Document**                 | JSON-like record in Firestore collection                                    |
| **Collection**               | Named group of documents (e.g., "users", "sessions")                        |
| **Real-Time Listeners**      | Firestore streams pushing updates to app when remote data changes           |

## Performance & Optimization

| Term                    | Definition                                                          |
| ----------------------- | ------------------------------------------------------------------- |
| **Hot Reload**          | Update code without restarting app; preserves state                 |
| **Hot Restart**         | Full app restart; clears state                                      |
| **Performance Profile** | DevTools tool measuring frame time, CPU, memory                     |
| **Const Widget**        | Widget with const constructor; prevents unnecessary rebuilds        |
| **Memoization**         | Caching function result to avoid recomputation                      |
| **Debounce**            | Delaying execution until stream stops emitting (e.g., search input) |
| **Throttle**            | Limiting execution to fixed intervals (e.g., scroll events)         |

## Monitoring & Debugging

| Term                | Definition                                                                  |
| ------------------- | --------------------------------------------------------------------------- |
| **Logging**         | Recording app events and errors for debugging                               |
| **Verbose Logging** | Detailed logs including request/response bodies; enabled during development |
| **Error Tracking**  | Capturing crashes and errors (e.g., Firebase Crashlytics)                   |
| **DevTools**        | Flutter development tools for profiling, inspection, logging                |
| **Breakpoint**      | Pause execution at a line for debugging                                     |
| **Stack Trace**     | Call sequence leading to a crash; shows where error originated              |

## Agile & Process

| Term                    | Definition                                                             |
| ----------------------- | ---------------------------------------------------------------------- |
| **Semantic Versioning** | Major.Minor.Patch versioning (e.g., 1.2.3); indicates API changes      |
| **Pull Request (PR)**   | Proposed code changes reviewed before merging to main                  |
| **Code Review**         | Peer inspection of code for quality, correctness, architecture         |
| **Merge Conflict**      | When changes to same code can't auto-merge; requires manual resolution |
| **Scenario**            | Modernization epic covering a complete feature implementation          |
| **Task**                | Atomic unit of work within a scenario                                  |
| **Sprint**              | Time-boxed development cycle (typically 2 weeks)                       |

## Projects & Files

| Term                      | Definition                                                        |
| ------------------------- | ----------------------------------------------------------------- |
| **Silent Space**          | Production Flutter focus timer app with Clean Architecture        |
| **pubspec.yaml**          | Package manifest declaring dependencies, version, metadata        |
| **analysis_options.yaml** | Linter rules for code quality (null safety, unused imports, etc.) |
| **gradle**                | Android build system; configures APK compilation                  |
| **Xcode**                 | iOS/macOS build tools; configures app signing and provisioning    |
| **Firebase Console**      | Google Cloud dashboard managing Firebase project settings         |

## Abbreviations

| Abbr      | Full Form                                      |
| --------- | ---------------------------------------------- |
| **API**   | Application Programming Interface              |
| **JWT**   | JSON Web Token                                 |
| **DI**    | Dependency Injection                           |
| **BDD**   | Behavior-Driven Development                    |
| **TTL**   | Time To Live                                   |
| **CRUD**  | Create, Read, Update, Delete                   |
| **HTTP**  | HyperText Transfer Protocol                    |
| **JSON**  | JavaScript Object Notation                     |
| **REST**  | Representational State Transfer                |
| **NoSQL** | Non-relational database                        |
| **MVP**   | Model-View-Presenter                           |
| **MVVM**  | Model-View-ViewModel                           |
| **UI**    | User Interface                                 |
| **UX**    | User Experience                                |
| **SQL**   | Structured Query Language                      |
| **OAuth** | Open Authorization                             |
| **APK**   | Android Package                                |
| **IPA**   | iOS App Archive                                |
| **SDK**   | Software Development Kit                       |
| **CLI**   | Command-Line Interface                         |
| **IDE**   | Integrated Development Environment             |
| **CI/CD** | Continuous Integration / Continuous Deployment |
| **PR**    | Pull Request                                   |

---

**Note:** This glossary serves as a shared vocabulary for AI agents, developers, and documentation. Keep updated as project evolves.
