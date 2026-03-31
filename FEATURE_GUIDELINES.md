# Feature Guidelines

## Objective
This document defines the mandatory blueprint for any new or refactored feature in Silent Space.

## Required Structure
Each feature should follow this structure whenever business logic or data access is present:

- lib/features/{feature}/domain
- lib/features/{feature}/data
- lib/features/{feature}/presentation

## Domain Layer Rules
- Keep domain pure (no Flutter, Firebase, Dio, Hive imports).
- Define entities as immutable and Equatable.
- Define repository contracts as abstract classes.
- Implement one use case per business action.
- Return Either<Failure, T> from repository contracts.

## Data Layer Rules
- Models convert to/from entities.
- Data sources contain raw IO logic (Firebase, Dio, cache).
- Repository implementations orchestrate data sources.
- Catch exceptions and map them to typed failures.

## Presentation Layer Rules
- Use Cubit with immutable states.
- Keep business logic outside widgets.
- Use localized strings and theme colors only.
- Split large widgets into modular stateless widgets.

## Dependency Injection Rules
- Register dependencies in lib/core/utils/service_locator.dart.
- External services first, then data sources, repositories, use cases, cubits.
- Use registerLazySingleton for long-lived services.
- Use registerFactory for screen-scoped cubits.

## Test Requirements Per Feature
- Domain: use case unit tests.
- Data: repository mapping tests.
- Presentation: widget/cubit tests for critical flows.

## Completion Checklist
- [ ] Layer folders exist and are used correctly
- [ ] Repository contract + implementation exist
- [ ] Use cases added for each business action
- [ ] Cubit and state classes are immutable
- [ ] Dependencies registered in service locator
- [ ] Strings localized in en/ar
- [ ] Unit and widget tests added
