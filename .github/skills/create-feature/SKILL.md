---
name: create-feature
description: 'Generate all structural directories and file stubs for a new clean-architecture feature in the codebase.'
argument-hint: 'Name of the feature to create'
---

# Create Feature

## When to Use
- When starting work on a completely new capability/module (e.g., focus timers, analytics, user profile).

## Principles

### 1. Mandatory Clean Architecture Structure
Every feature must follow the core Clean Architecture layers:
- `domain/`
  - `entities/`
  - `repositories/`
  - `usecases/`
- `data/`
  - `models/`
  - `sources/`
  - `implements/`
- `presentation/`
  - `cubit/`
  - `pages/`
  - `widgets/`

---

## Step-by-Step Procedure

### 1. Create Folder Structure
Create all directories for the feature under `lib/features/<feature_name>/`:
- `lib/features/<feature_name>/domain/entities`
- `lib/features/<feature_name>/domain/repositories`
- `lib/features/<feature_name>/domain/usecases`
- `lib/features/<feature_name>/data/models`
- `lib/features/<feature_name>/data/sources`
- `lib/features/<feature_name>/data/implements`
- `lib/features/<feature_name>/presentation/cubit`
- `lib/features/<feature_name>/presentation/pages`
- `lib/features/<feature_name>/presentation/widgets`

### 2. Create Core File Stubs
1. **Entity**: Define immutable entities inheriting from `Equatable`.
2. **Repository Contract**: Define the abstract class return signatures using `Either<Failure, T>`.
3. **Remote/Local Sources**: Define interfaces and implementations for remote API/database calls.
4. **Repository Implementation**: Write implementation class matching repository contract, wrapping source calls in try-catch.
5. **Use Cases**: Create a use case class for each atomic action, extending a generic `UseCase` template.
6. **Cubit & State**: Define cubit and state classes for UI state management.

### 3. Register Dependencies
Open [service_locator.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/service_locator.dart) and register data sources, repository implementations, use cases, and cubits.
