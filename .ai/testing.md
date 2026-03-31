# Testing Prompt

## Template
Use the /testing-flutter skill for {target_class_or_feature}.

Required tests:
- Domain unit tests for use cases
- Data unit tests for repository mapping and failures
- Presentation widget/cubit tests for state transitions and rendering

Constraints:
- Use mocktail
- Use Arrange -> Act -> Assert
- BDD naming: testWhen_ShouldExpect
- Cover happy path + failure path + edge case

## Example
Use the /testing-flutter skill for SaveSessionUseCase and SessionCubit.

Add tests for:
- success save
- repository failure
- empty session list
- loading and error UI states

## Checklist
- [ ] Mocks are isolated and deterministic
- [ ] Failure scenarios are asserted explicitly
- [ ] Cubit state sequence is validated
- [ ] Widget test verifies visible behavior
- [ ] No implementation details asserted unnecessarily
