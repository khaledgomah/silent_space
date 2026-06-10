---
name: architecture-review
description: 'Review codebase or specific features against Clean Architecture layering guidelines, testing contracts, and dependency injection rules.'
argument-hint: 'Optional specific feature name or directory'
---

# Architecture Review

## When to Use
- Before merging a feature branch or completing a major task.
- When reviewing someone else's code or doing self-assessment of newly written code.
- When verifying that Silent Space design standards are upheld.

## Principles

### 1. Clean Architecture Layering Rules
Ensure strict isolation of concerns across layers:
- **Domain Layer**: Must be pure Dart. No imports of `package:flutter`, Firebase, Dio, Hive, or data models. Must define abstract repositories, entities, and use cases.
- **Data Layer**: Contains remote/local data sources, models, and repository implementations. Data sources must not leak raw exceptions; repository implementations must return `Either<Failure, T>`.
- **Presentation Layer**: Contains Cubits, UI widgets, and pages. Must not directly access repositories or data sources—use cases only.

### 2. Dependency Injection Contract
- Check [service_locator.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/service_locator.dart) to ensure all dependencies are registered correctly.
- Ensure proper lifecycle choices: `registerLazySingleton` for singletons/stateful services, `registerFactory` for cubits.

---

## Step-by-Step Procedure

### 1. Identify Target Files
Collect a list of all files in the feature package:
- Domain files: `/domain/entities/`, `/domain/repositories/`, `/domain/usecases/`
- Data files: `/data/models/`, `/data/sources/`, `/data/implements/`
- Presentation files: `/presentation/cubit/`, `/presentation/pages/`, `/presentation/widgets/`

### 2. Check Layer Separation
Inspect import statements at the top of each file:
- Ensure `/domain/` files do not import anything from `package:flutter` or from the `/data/` or `/presentation/` directories.
- Ensure `/presentation/` files do not import from `/data/`.

### 3. Check Service Registrations
Open [service_locator.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/service_locator.dart) and ensure the new use cases, cubits, and repositories are properly registered in the dependency tree.

### 4. Produce a Compliance Report
Structure your review into a clear feedback list covering:
- Compliance with Clean Architecture Layering.
- Dependency injection validation.
- Test coverage evaluation.
- Identified anti-patterns (e.g., raw exceptions in repositories, business logic in UI).
