---
name: testing-flutter
description: 'Write or review unit tests, repository tests, cubit tests, and widget tests using mocktail, flutter_test, and bloc_test.'
argument-hint: 'Optional test target file or class'
---

# Testing Flutter Code

## When to Use
- When writing unit tests for use cases, repositories, or data sources.
- When writing bloc/cubit tests to verify correct state emissions.
- When writing widget tests for UI elements and validation flows.

## Principles

### 1. Test Coverage Contract
- Every new or modified use case requires a unit test.
- Repository tests must cover both success scenarios and failure/error mapping scenarios.
- Cubit tests should utilize the `bloc_test` library to assert sequences of states.

### 2. Mocking with Mocktail
- Use `mocktail` for clean, type-safe mocks.
- Always stub method calls inside your test group setup using `when(...)`.

---

## Step-by-Step Procedure

### 1. Structure Tests Directory
Tests must duplicate the structure of `lib/`:
- `test/features/<feature>/domain/usecases/`
- `test/features/<feature>/data/repositories/`
- `test/features/<feature>/presentation/cubit/`

### 2. Write Use Case Test
```dart
class MockFeatureRepository extends Mock implements FeatureRepository {}

void main() {
  late MockFeatureRepository mockRepository;
  late FeatureUseCase useCase;

  setUp(() {
    mockRepository = MockFeatureRepository();
    useCase = FeatureUseCase(mockRepository);
  });

  test('should return data from repository', () async {
    when(() => mockRepository.getData()).thenAnswer((_) async => Right(tData));
    final result = await useCase(NoParams());
    expect(result, Right(tData));
    verify(() => mockRepository.getData()).called(1);
  });
}
```

### 3. Write Cubit Test
Use `blocTest` for cubits:
```dart
blocTest<FeatureCubit, FeatureState>(
  'should emit [Loading, Loaded] when load succeeds',
  build: () {
    when(() => mockUseCase(any())).thenAnswer((_) async => Right(tData));
    return FeatureCubit(mockUseCase);
  },
  act: (cubit) => cubit.load(),
  expect: () => [
    FeatureLoading(),
    FeatureLoaded(items: tData),
  ],
);
```
