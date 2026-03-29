# Custom Prompts for AI-Assisted Development

These prompts are designed to be used with GitHub Copilot Chat for targeted development tasks.

## Usage

Copy the prompt text and paste into Copilot Chat (`Ctrl+Shift+I` in VS Code):

### 1. Create a Complete Feature

**Prompt:**

```
Use the /create-feature skill to implement a {FEATURE_NAME} feature with:
- Domain: {ENTITY} entity with {FIELDS}
- Use Cases: {USECASE_NAMES}
- Data: Remote API endpoint {ENDPOINT}, local Hive storage
- Presentation: Feature page and tiles
- Tests: Unit tests for use cases and repositories, widget tests for pages
- Service Locator registration in service_locator.dart

Follow Clean Architecture strictly. No shortcuts.
```

**Example:**

```
Use the /create-feature skill to implement a Feedback feature with:
- Domain: Feedback entity with id, rating (1-5), comment, createdAt, userId
- Use Cases: SubmitFeedback, GetUserFeedback, DeleteFeedback
- Data: Remote API endpoint /feedback, local Hive storage
- Presentation: FeedbackPage, FeedbackForm, FeedbackTile
- Tests: Unit tests for all use cases and repositories, widget tests for pages
- Service Locator registration

Follow Clean Architecture strictly. No shortcuts.
```

---

### 2. Code Review — Architecture & Logic

**Prompt:**

```
Use the /architecture-review skill to validate {FILE_OR_FEATURE}:

Core Checks:
- [ ] Domain layer has ZERO external dependencies (no flutter, no data layer).
- [ ] No presentation layer imports from data layer (use repositories/usecases).
- [ ] All repositories implement domain contracts (interfaces).
- [ ] Dependency injection is correctly registered in service_locator.dart.
- [ ] State management uses immutable Equatable classes and specific states.
- [ ] Error handling follows Either<Failure, T> pattern.
- [ ] Business logic should NOT be in Widgets or UI files.

Deep Checks:
- [ ] Complexity: Are functions and classes following Single Responsibility Principle?
- [ ] Duplication: Is there any logic that can be moved to core/utils or core/widgets?
- [ ] Naming: Does the code follow standard Flutter/Dart naming conventions (camelCase, PascalCase)?

Report violations concisely with suggested fixes.
```

---

### 3. Debug Architecture Violation

**Prompt:**

```
Use the /debugging-architecture skill:

Error: {ERROR_MESSAGE}
File: {FILE_PATH}
Context: {BRIEF_DESCRIPTION}

1. Explain the root cause
2. Show how to fix it
3. Validate the fix doesn't break anything else
```

**Example:**

```
Use the /debugging-architecture skill:

Error: "Type 'SessionRemoteDataSourceImpl' not found"
File: lib/features/session/presentation/cubit/session_cubit.dart
Context: Getting "Type not found" when trying to use remoteDataSource

1. Explain the root cause
2. Show how to fix it
3. Validate the fix doesn't break anything else
```

---

### 4. Implement Error Handling

**Prompt:**

```
Use the /error-handling skill:

Feature: {FEATURE_NAME}
API Endpoint/Operation: {OPERATION}
Expected Failures: {FAILURE_TYPES}

1. Define a custom Failure subclass
2. Create exception types for this operation
3. Update repository to map exceptions to Failures
4. Show how Cubit handles and displays errors to user
5. Add test cases for error scenarios
```

**Example:**

```
Use the /error-handling skill:

Feature: Payment Processing
API Endpoint: /payments/process
Expected Failures: PaymentFailure (insufficient funds, network error, server error, timeout)

1. Define a custom PaymentFailure subclass
2. Create exception types (InsufficientFundsException, PaymentTimeoutException)
3. Update repository to map exceptions to Failures
4. Show how PaymentCubit handles and displays errors to user
5. Add test cases for all failure scenarios
```

---

### 5. Refactor Large Widget

**Prompt:**

```
Use the /widget-refactoring skill:

File: {FILE_PATH}
Widget: {WIDGET_NAME}
Issues: {PROBLEMS}

1. Break down into smaller components
2. Keep nesting depth ≤ 3 levels
3. Extract logic into separate widgets
4. Ensure all widgets use const constructors
5. Optimize rebuilds using BlocSelector
6. Keep all strings using AppStrings.xxx.tr()
```

**Example:**

```
Use the /widget-refactoring skill:

File: lib/features/session/presentation/pages/session_detail_page.dart
Widget: SessionDetailPage
Issues: 250 lines, 5 levels of nesting, hardcoded strings, full rebuild on any state change

1. Break down into smaller components (SessionHeader, SessionStats, SessionActions)
2. Keep nesting depth ≤ 3 levels
3. Extract logic into separate widgets
4. Ensure all widgets use const constructors
5. Optimize rebuilds using BlocSelector for each section
6. Keep all strings using AppStrings.xxx.tr()
```

---

### 6. Write Tests

**Prompt:**

```
Use the /testing-flutter skill:

Unit Test: Test {CLASS_NAME}.{METHOD_NAME}
Domain/Data: {LAYER}
Test Cases:
- When {CONDITION1}, should return {EXPECTED1}
- When {CONDITION2}, should throw {EXCEPTION2}
- When {CONDITION3}, should use repository correctly

Use BDD naming: test{When_Should}
Mock all dependencies with mocktail
Use Arrange-Act-Assert structure
```

**Example:**

```
Use the /testing-flutter skill:

Unit Test: Test SignInUseCase.call()
Domain/Data: Domain (repository is mocked)
Test Cases:
- When credentials valid, should return Right(UserEntity)
- When credentials invalid, should return Left(AuthFailure)
- When network error, should return Left(NetworkFailure)

Use BDD naming: testWhen_Should
Mock AuthRepository with mocktail
Use Arrange-Act-Assert structure
```

---

### 7. Setup Caching Strategy

**Prompt:**

```
Use the /caching-persistence skill:

Entity/Feature: {ENTITY_NAME}
Caching Strategy: {STRATEGY}
Cache Duration: {DURATION}
Offline Support: {YES/NO}

1. Design local data source with Hive
2. Implement cache validation and TTL
3. Handle offline scenarios
4. Implement sync-when-online if needed
5. Add cache invalidation
6. Write tests for cache behavior
```

**Example:**

```
Use the /caching-persistence skill:

Entity/Feature: Sessions
Caching Strategy: Cache-then-network (show cached immediately, update in background)
Cache Duration: 30 minutes for list, 1 hour for details
Offline Support: Yes, show cached sessions when offline

1. Design local data source with Hive for sessions list
2. Implement cache validation and 30-minute TTL
3. Handle offline scenarios (return cached if no internet)
4. Implement sync-when-online for pending operations
5. Add cache invalidation on logout
6. Write tests for cache behavior with timestamps
```

---

### 8. Setup Networking

**Prompt:**

```
Use the /networking-api skill:

API Base URL: {BASE_URL}
Endpoints needed: {LIST_ENDPOINTS}
Authentication: {AUTH_TYPE}
Special: {RETRIES/HEADERS/INTERCEPTORS}

1. Configure Dio client with base URL and timeouts
2. Implement auth interceptor with JWT tokens
3. Implement error handling and mapping
4. Setup request/response logging
5. Implement retry logic with exponential backoff
6. Write tests for API calls and error scenarios
```

**Example:**

```
Use the /networking-api skill:

API Base URL: https://api.silentspace.com/v1
Endpoints needed: /sessions (GET, POST, PUT, DELETE), /users (GET, PUT)
Authentication: JWT Bearer token
Special: Refresh token when 401, retry timeouts up to 3x

1. Configure Dio client with base URL=https://api.silentspace.com/v1, timeout=30s
2. Implement auth interceptor adding "Authorization: Bearer {token}" header
3. Implement error handling mapping 401→RefreshToken, 4xx→ClientFailure, 5xx→ServerFailure
4. Setup LogInterceptor for development
5. Implement retry logic: exponential backoff for timeout/500/503
6. Write tests mocking Dio for success/error scenarios
```

---

### 9. Add Localization

**Prompt:**

```
Use the /localization-i18n skill:

Strings needed: {LIST_KEYS}
Languages: English, Arabic
Notes: {SPECIAL_FORMATTING}

1. Create AppStrings constants class
2. Add entries to en.json and ar.json
3. Update all hardcoded strings in feature
4. Test language switching
5. Verify RTL for Arabic
6. Check coverage (no missed strings)
```

**Example:**

```
Use the /localization-i18n skill:

Strings needed:
- "feedback_title": "Share Your Feedback"
- "feedback_rating_label": "Rate your experience (1-5)"
- "feedback_comment_hint": "Optional comments..."
- "feedback_submit": "Submit Feedback"
- "feedback_success": "Thank you for your feedback!"

Languages: English, Arabic
Notes: Arabic should support RTL properly, ratings should be 5→1 in RTL

1. Create AppStrings constants class with feedbackTitle, feedbackRatingLabel, etc.
2. Add entries to assets/translations/en.json and ar.json
3. Update FeedbackForm and FeedbackPage to use AppStrings
4. Test language switching in app settings
5. Verify RTL layout for Arabic
6. Check no hardcoded strings remain
```

---

### 10. Dependency Injection Setup

**Prompt:**

```
Use the /dependency-injection skill:

New dependencies to register:
1. {SERVICE_NAME} (External service)
2. {DATA_SOURCE_NAME} (Data layer)
3. {REPOSITORY_NAME} (Domain contract)
4. {USECASE_NAME} (Business logic)
5. {CUBIT_NAME} (Presentation)

1. Show correct registration order
2. Identify circular dependencies
3. Update service_locator.dart
4. Verify in tests using getIt<T>()
```

**Example:**

```
Use the /dependency-injection skill:

New dependencies to register:
1. PaymentGateway (Firebase integration)
2. PaymentRemoteDataSource (API calls)
3. PaymentRepository (implements PaymentRepository contract)
4. ProcessPaymentUseCase (validates and processes)
5. PaymentCubit (manages payment state)

1. Show correct registration order
2. Check if PaymentGateway and PaymentRemoteDataSource are circularly dependent
3. Update service_locator.dart with all 5 registrations
4. Verify tests can mock and inject PaymentRepository
```

---

### 11. Multi-Cubit Coordination

**Prompt:**

```
Use the /state-management-advanced skill:

Flow: {MULTI_STEP_FLOW}
Cubits involved: {LIST_CUBITS}
Side effects: {NAVIGATION/DIALOGS/TOASTS}

1. Design state coordination (which Cubit owns which state)
2. Implement BlocListener for side effects
3. Show how Cubits communicate (via repository, not direct)
4. Handle errors and rollbacks
5. Write tests for multi-Cubit flows
```

**Example:**

```
Use the /state-management-advanced skill:

Flow: User signs up → validates form → creates remote account → caches user → navigates to home
Cubits involved: SignUpCubit, AuthCubit, SessionCubit
Side effects: Show validation errors, Show success toast, Navigate to HomePage

1. Design state: SignUpCubit owns form/validation, AuthCubit owns auth state after signup
2. Implement BlocListener on AuthCubit to navigate when AuthSuccess emitted
3. Show SignUpCubit calls repository.signUp() which updates AuthCubit via state
4. If signup fails, rollback form and show error
5. Write tests for: success flow, validation failure, network error, concurrent signups
```

---

### 12. Theme & Design System Review

**Prompt:**

```
Use the /theme-review skill to audit {FILE_OR_PATH}:

Check for Compliance:
- [ ] Colors: No hardcoded Hex/RGB colors. Use AppColors.xxx or Theme.of(context).
- [ ] Backgrounds: Scaffolds should use standard theme background color.
- [ ] Typography: Use Theme.of(context).textTheme for all text styles.
- [ ] Constants: Use standard spacing constants (Constants.xxx or SizedBox padding).
- [ ] Theme Symmetry: Does the widget support both Light and Dark mode?

Identify all hardcoded visual values and show how to replace them with theme tokens.
```

---

### 13. UI/UX Excellence ("Logify" Standards)

**Prompt:**

```
Evaluate {FILE_OR_PATH} against the "Logify" Design Standards:

Standards Checklist:
- [ ] Backgrounds: Dark Navy (AppColors.logifyBackground) for dark mode.
- [ ] Accents: Magenta (AppColors.logifyPrimary) for primary actions/links.
- [ ] Buttons: Pill-shaped (StadiumBorder) with 0 elevation for primary actions.
- [ ] Fields: Underline-style inputs with consistent hint/label colors.
- [ ] Spacing: Large comfortable paddings (16px/24px/32px).
- [ ] Icons: Consistent icon weights and sizes (Icons.xxx_outlined preferred).

Report any inconsistencies with the premium Logify design language.
```

---

### 14. Performance & Widget Optimization

**Prompt:**

```
Analyze {FILE_OR_PATH} for Flutter performance issues:

Optimization Checklist:
- [ ] Const: Ensure ALL static widgets use 'const' constructors.
- [ ] Nesting: Nesting depth should not exceed 5 levels (extract if deeper).
- [ ] Rebuilds: Wrap dynamic parts in BlocBuilder/BlocSelector instead of full rebuilds.
- [ ] Images: Check for large assets or missing placeholders.
- [ ] Lambdas: Avoid complex logic inside build methods (move to methods or cubit).

Provide a refactored version of the widget with performance improvements.
```

---

### 15. Prompt Engineering & Meta-Review

**Prompt:**

```
Analyze the following prompt for effectiveness and compliance with our project standards:

Prompt to Review: "{PROMPT_TEXT}"

Evaluation Criteria:
- [ ] Context: Does it provide enough background (files, features, architecture)?
- [ ] Specificity: Is the goal clear and unambiguous?
- [ ] Constraints: Does it enforce Clean Architecture and Logify Design?
- [ ] Output Format: Is the desired response format specified (code, report, tests)?
- [ ] Skill Usage: Does it correctly invoke the appropriate /skill?

Suggest improvements to make this prompt more "powerful" and effective for the AI agent.
```

---

## Meta-Review: Prompt Design Guidelines

1. **State the Skill Clearly**: Use `/skill-name` notation.
2. **Provide a Specific Checklist**: Use `[ ]` for scannable requirements.
3. **Include Examples**: Show exactly what a "good" call looks like.
4. **Enforce Standards**: Explicitly mention Clean Architecture and Logify Design.

## Quick Command Reference

```bash
# Ask Copilot to use a specific skill
/create-feature
/architecture-review
/testing-flutter
/error-handling
/theme-review
/caching-persistence
/networking-api
/dependency-injection
/state-management-advanced
/localization-i18n
/widget-refactoring
/debugging-architecture
/ui-audit
/performance-opt
```

## Tips for Better Results

1. **Be specific** — Include file names, entities, and scenarios
2. **Copy examples** — Provide expected inputs/outputs
3. **Ask for validation** — Ask Copilot to verify the solution follows Clean Architecture
4. **Request tests** — Always ask to include test cases
5. **Ask for refactoring** — After implementation, ask "Can this be improved?"

## When to Ask Different Prompts

| Situation                   | Prompt                              |
| --------------------------- | ----------------------------------- |
| Building new feature        | "Create a Complete Feature"         |
| Code smells / Arch check    | "Code Review — Architecture"        |
| Color / Style inconsistency | "Theme & Design System Review"      |
| UI doesn't look premium     | "UI/UX Excellence (Logify)"         |
| Slow/laggy scrolling/UI     | "Performance & Widget Optimization" |
| Runtime errors              | "Debug Architecture Violation"      |
| Missing error handling      | "Implement Error Handling"          |
| No test coverage            | "Write Tests"                       |
| Data not persisting         | "Setup Caching Strategy"            |
| API errors                  | "Setup Networking"                  |
| Hardcoded strings           | "Add Localization"                  |
| "Type not found" errors     | "Dependency Injection Setup"        |
| Complex flows               | "Multi-Cubit Coordination"          |

---

**Last Updated:** March 2026  
**Tip:** Copy these into Copilot Chat for guided development!
