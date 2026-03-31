# Create Feature Prompt

## Template
Use the /create-feature + /dependency-injection + /testing-flutter skills to create a new feature named {feature_name}.

Requirements:
- Architecture: domain/data/presentation layers with strict boundaries.
- Domain: entity {entity_name}, repository contract, use cases: {use_cases}.
- Data: model mapping, remote/local sources, repository implementation with Either<Failure, T>.
- Presentation: immutable Cubit states (loading/success/error/empty), page, modular widgets.
- DI: register all new dependencies in lib/core/utils/service_locator.dart.
- Localization: no hardcoded strings.
- Testing: unit tests for use cases and repository, widget test for page.

Output format:
1. Files created
2. Full code for each file
3. Validation steps

## Example
Use the /create-feature + /dependency-injection + /testing-flutter skills to create a notifications feature.

Requirements:
- Entity: NotificationEntity(id, title, body, createdAt, isRead)
- Use cases: GetNotificationsUseCase, MarkNotificationReadUseCase
- Data: Firebase remote source + Hive cache
- Presentation: NotificationCubit, NotificationPage, NotificationList widget
- DI and tests required

## Checklist
- [ ] Domain contains no Flutter/Firebase/Dio imports
- [ ] Repository contract is abstract and returns Either<Failure, T>
- [ ] Data layer maps exceptions to Failures
- [ ] Cubit states are immutable and Equatable
- [ ] No hardcoded strings/colors in UI
- [ ] All dependencies registered in service locator
- [ ] Unit and widget tests added
