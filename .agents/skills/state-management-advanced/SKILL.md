---
name: state-management-advanced
description: 'Implement or optimize complex state transitions, bloc-to-bloc communications, state caching, and reactive cubit states.'
argument-hint: 'Optional cubit or bloc name to update'
---

# Advanced State Management (Cubit/BLoC)

## When to Use
- When managing screen interactions, complex state relationships (e.g. listening to auth state transitions to reload user data), or caching cubit states.
- When optimising bloc/cubit build rebuild performance.

## Principles

### 1. Immutable States
- All state classes must extend `Equatable` and have final fields.
- Provide a `copyWith` method in state classes to emit updated state objects without mutating the original.

### 2. Separation of Business Logic
- UI must only listen to state transitions (`BlocBuilder`, `BlocConsumer`) or emit events.
- Never write business logic directly inside widget tap handlers—always delegate actions to cubits.

---

## Step-by-Step Procedure

### 1. Define State Class
```dart
abstract class FeatureState extends Equatable {
  const FeatureState();
  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}

class FeatureLoading extends FeatureState {}

class FeatureLoaded extends FeatureState {
  final List<DataEntity> items;
  const FeatureLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}
```

### 2. Implement Cubit
```dart
class FeatureCubit extends Cubit<FeatureState> {
  final FetchDataUseCase fetchData;
  FeatureCubit(this.fetchData) : super(FeatureInitial());

  Future<void> load() async {
    emit(FeatureLoading());
    final result = await fetchData(NoParams());
    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (data) => emit(FeatureLoaded(items: data)),
    );
  }
}
```

### 3. Cubit-to-Cubit Communication
If a cubit needs to respond to changes in another cubit (e.g., refreshing data when auth status changes):
- Pass the source cubit into the target cubit's constructor or handle transitions in the UI presentation layer using `BlocListener`.
