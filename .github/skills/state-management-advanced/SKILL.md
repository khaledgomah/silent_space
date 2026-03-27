---
name: state-management-advanced
description: 'Advanced state management patterns beyond basic Cubits. Use for multi-step flows, combining multiple Cubits, handling side effects, optimistic updates, and complex state synchronization.'
argument-hint: 'Feature or pattern type (e.g., multi-step-forms, shopping-cart, session-management)'
---

# Advanced State Management

## When to Use
- Multiple Cubits coordinating (e.g., Auth + User profile + Settings)
- Multi-step flows (checkout, onboarding, complex wizard)
- Optimistic UI updates (save before server confirms)
- Synchronizing state across features
- Complex state dependencies
- Side effects beyond simple state changes

## Cubit Patterns

### Pattern 1: Multiple Cubits Coordinating

**Scenario:** User logs in → Update auth → Load profile → Update UI

```dart
// StatelessWidget with multiple BlocProviders
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<ProfileCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<SettingsCubit>(),
        ),
      ],
      child: const _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        // When auth succeeds, load profile
        if (authState is AuthSuccess) {
          context.read<ProfileCubit>().loadProfile(authState.user.id);
        }
        // When auth fails, reset other cubits
        if (authState is AuthError) {
          context.read<ProfileCubit>().reset();
        }
      },
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const _LoadingWidget();
            } else if (state is ProfileLoaded) {
              return _ProfileView(profile: state.profile);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

### Pattern 2: Multi-Step Wizard with Intermediate State

**Scenario:** Signup flow (email → password → profile → confirm)

```dart
// Define state hierarchy
part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignUpUseCase signUpUseCase;
  final ValidateEmailUseCase validateEmailUseCase;

  SignupCubit({
    required this.signUpUseCase,
    required this.validateEmailUseCase,
  }) : super(const SignupInitial());

  // Step 1: Email validation
  Future<void> validateEmail(String email) async {
    emit(const SignupEmailValidating());
    
    final result = await validateEmailUseCase(
      ValidateEmailParams(email: email),
    );

    result.fold(
      (failure) => emit(SignupEmailError(message: failure.displayMessage)),
      (isValid) {
        if (isValid) {
          emit(const SignupEmailValid());
        } else {
          emit(const SignupEmailError(message: 'Invalid email format'));
        }
      },
    );
  }

  // Step 2: Set password
  void setPassword(String password) {
    if (password.length < 8) {
      emit(const SignupPasswordError(message: 'Min 8 characters'));
    } else {
      emit(const SignupPasswordValid());
    }
  }

  // Step 3: Complete signup
  Future<void> completeSignup(String email, String password, String name) async {
    emit(const SignupLoading());

    final result = await signUpUseCase(
      SignUpParams(email: email, password: password, name: name),
    );

    result.fold(
      (failure) => emit(SignupError(message: failure.displayMessage)),
      (user) => emit(SignupSuccess(user: user)),
    );
  }
}
```

**State classes:**
```dart
part of 'signup_cubit.dart';

abstract class SignupState extends Equatable {
  const SignupState();
  
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignupEmailValidating extends SignupState {
  const SignupEmailValidating();
}

class SignupEmailValid extends SignupState {
  const SignupEmailValid();
}

class SignupEmailError extends SignupState {
  final String message;
  const SignupEmailError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class SignupPasswordValid extends SignupState {
  const SignupPasswordValid();
}

class SignupPasswordError extends SignupState {
  final String message;
  const SignupPasswordError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class SignupLoading extends SignupState {
  const SignupLoading();
}

class SignupSuccess extends SignupState {
  final UserEntity user;
  const SignupSuccess({required this.user});
  
  @override
  List<Object?> get props => [user];
}

class SignupError extends SignupState {
  final String message;
  const SignupError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
```

**UI:**
```dart
class SignupWizard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        if (state is SignupInitial) {
          return _EmailStep();
        } else if (state is SignupEmailValid) {
          return _PasswordStep();
        } else if (state is SignupPasswordValid) {
          return _ProfileStep();
        } else if (state is SignupLoading) {
          return const _LoadingWidget();
        } else if (state is SignupSuccess) {
          return const _SuccessWidget();
        } else if (state is SignupError) {
          return _ErrorWidget(message: state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
```

### Pattern 3: Optimistic Updates

**Scenario:** Add item to cart → Show immediately → Sync with server

```dart
class CartCubit extends Cubit<CartState> {
  final AddToCartUseCase addToCartUseCase;

  CartCubit({required this.addToCartUseCase})
      : super(const CartInitial());

  Future<void> addItem(Product product) async {
    // Optimistic update: Emit success immediately
    final currentItems = (state as? CartLoaded)?.items ?? [];
    final updatedItems = [...currentItems, product];

    emit(CartLoaded(items: updatedItems));

    // Sync with server in background
    final result = await addToCartUseCase(
      AddToCartParams(productId: product.id),
    );

    result.fold(
      // If server fails, revert to previous state
      (failure) {
        emit(CartLoaded(items: currentItems));
        emit(CartError(message: failure.displayMessage));
      },
      // If success, confirm (or update if needed)
      (_) {
        // Server confirmed, keep optimistic state or refresh
        _refreshCart();
      },
    );
  }

  Future<void> _refreshCart() async {
    // Refresh from server to ensure sync
    final result = await getCartUseCase(NoParams());
    result.fold(
      (failure) => emit(CartError(message: failure.displayMessage)),
      (cart) => emit(CartLoaded(items: cart.items)),
    );
  }
}
```

### Pattern 4: BlocListener for Side Effects

**Scenario:** Show snackbar on success, navigate on failure

```dart
class _ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen for profile updates
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdating) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saving...')),
              );
            } else if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved!')),
              );
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        // Listen for auth failures (redirect to login)
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              context.go('/login');
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const CircularProgressIndicator();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

### Pattern 5: BlocSelector for Granular Rebuilds

**Scenario:** Only rebuild when specific field changes

```dart
class UserPreferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Only rebuilds when theme changes
        BlocSelector<SettingsCubit, SettingState, bool>(
          selector: (state) => state is SettingLoaded ? state.isDarkMode : false,
          builder: (context, isDarkMode) {
            return Switch(
              value: isDarkMode,
              onChanged: (_) {
                context.read<SettingsCubit>().toggleTheme();
              },
            );
          },
        ),
        
        // Only rebuilds when notifications change
        BlocSelector<SettingsCubit, SettingState, bool>(
          selector: (state) =>
              state is SettingLoaded ? state.notificationsEnabled : false,
          builder: (context, enabled) {
            return Switch(
              value: enabled,
              onChanged: (_) {
                context.read<SettingsCubit>().toggleNotifications();
              },
            );
          },
        ),
      ],
    );
  }
}
```

## Advanced Patterns

### Pattern 6: Combining Multiple Sources

```dart
class DashboardCubit extends Cubit<DashboardState> {
  final GetSessionsUseCase getSessionsUseCase;
  final GetGoalsUseCase getGoalsUseCase;
  final GetStatisticsUseCase getStatisticsUseCase;

  DashboardCubit({
    required this.getSessionsUseCase,
    required this.getGoalsUseCase,
    required this.getStatisticsUseCase,
  }) : super(const DashboardInitial());

  Future<void> loadDashboard() async {
    emit(const DashboardLoading());

    // Load all in parallel
    final sessionsResult = await getSessionsUseCase(NoParams());
    final goalsResult = await getGoalsUseCase(NoParams());
    final statsResult = await getStatisticsUseCase(NoParams());

    // Check if any failed
    final failure = [sessionsResult, goalsResult, statsResult]
        .whereType<Left<Failure, dynamic>>()
        .firstOrNull;

    if (failure != null) {
      emit(DashboardError(message: failure.value.displayMessage));
      return;
    }

    // All succeeded
    final sessions = (sessionsResult as Right).value;
    final goals = (goalsResult as Right).value;
    final stats = (statsResult as Right).value;

    emit(DashboardLoaded(
      sessions: sessions,
      goals: goals,
      statistics: stats,
    ));
  }
}
```

### Pattern 7: Stream Integration

```dart
class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsStreamUseCase getNotificationsStreamUseCase;
  StreamSubscription<List<NotificationEntity>>? _subscription;

  NotificationCubit({required this.getNotificationsStreamUseCase})
      : super(const NotificationInitial());

  Future<void> listenToNotifications() async {
    emit(const NotificationLoading());

    final result = await getNotificationsStreamUseCase(NoParams());

    result.fold(
      (failure) => emit(NotificationError(message: failure.displayMessage)),
      (notificationStream) {
        // Listen to stream updates
        _subscription = notificationStream.listen((notifications) {
          emit(NotificationLoaded(notifications: notifications));
        });
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

## State Management Checklist

- [ ] Each Cubit has single responsibility
- [ ] States are immutable and extend Equatable
- [ ] No business logic in widgets
- [ ] Use BlocListener for side effects (snackbar, navigation)
- [ ] Use BlocBuilder for UI updates
- [ ] Use BlocSelector for optimization (rebuild only on field change)
- [ ] Multi-step flows have intermediate states
- [ ] Error states communicated clearly
- [ ] Loading states show progress
- [ ] Empty states handled explicitly

## Best Practices

✅ **One Cubit per feature** — Auth, Profile, Settings each have own Cubit
✅ **Communicate between Cubits via BlocListener** — Not direct calls
✅ **Side effects in Cubits** — Navigation, API calls in Cubit methods
✅ **Immutable state** — Emit new states, never mutate
✅ **Clear state hierarchy** — All states inherit from base state class
✅ **Granular rebuilds** — Use BlocSelector when possible
✅ **Optimistic updates** — For better UX, revert on failure

## Anti-Patterns

❌ **Widget directly calling use case** — Use Cubit instead
❌ **Cubit mutating internal fields** — Emit new states
❌ **Single mega-Cubit for entire app** — Split by feature
❌ **BlocProvider creating Cubit in build()** — Use service locator
❌ **No error handling** — Always emit error states
❌ **Silent failures** — Load from cache while showing success
