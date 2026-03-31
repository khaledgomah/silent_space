# Clean Architecture Rules

## Non-Negotiable Layering
- Domain must not import from data or presentation.
- Data may import domain, never presentation.
- Presentation may import domain contracts/use cases, never data sources.

## Error Handling Contract
- No raw exceptions should escape repository implementations.
- Repositories must return Either<Failure, T>.
- Failures must be user-safe and actionable.

## Dependency Injection Contract
- All dependencies are registered only in service locator.
- Widgets do not manually instantiate repositories, use cases, or services.
- Lifecycles must be intentional (singleton vs factory).

## UI Quality Contract
- No hardcoded user-facing strings.
- No hardcoded colors where theme/color system exists.
- Keep build nesting shallow; extract reusable widgets.

## Testing Contract
- Every changed use case requires a unit test.
- Every changed repository requires error mapping coverage.
- Critical screens should have at least one widget test.

## Anti-Patterns
- Business logic in widget build methods.
- Direct Firebase/Dio/Hive calls in presentation.
- Mutable Cubit states or hidden mutable source-of-truth fields.
- Unregistered dependencies or runtime service locator lookups in domain.
