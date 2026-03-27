---
description: Troubleshooting guide for common Silent Space development issues with AI-assisted solutions
---

# Silent Space — Troubleshooting Guide

**Use this guide when things break.** Each section includes the problem, root cause, and AI-assisted solution path.

---

## Startup & Build Errors

### "No instance of type XYZ found in service locator"

**Root Cause:**
- Dependency not registered in `service_locator.dart`
- `locatorSetup()` not called before running app
- Circular dependency in registration chain

**Solution Steps:**

1. **Check if registered:**
   ```bash
   # Search service_locator.dart for the type
   grep -n "registerLazySingleton<AuthRepository>" lib/core/utils/service_locator.dart
   ```

2. **If missing, add registration:**
   - Ask AI: *"I'm getting 'No instance of AuthRepository found'. Help me register it in service_locator.dart"*
   - AI will guide you through registration order

3. **Ensure locatorSetup() called:**
   ```dart
   // lib/main.dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await locatorSetup();  // ✅ Must be called
     await HiveService.init();  // ✅ Hive must initialize
     runApp(const SilentSpace());
   }
   ```

4. **Check for circular dependencies:**
   - Ask AI: *"Check if there's a circular dependency in [Type A] and [Type B]"*
   - Ask to see the dependency graph: *"Show me what each repository depends on"*

---

### "Widget not found" or "Page not found"

**Root Cause:**
- Route not registered in `on_generate_route.dart`
- Wrong route path in navigation
- Feature not properly initialized

**Solution:**
```dart
// lib/core/utils/on_generate_route.dart
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.login:
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),  // ✅ Ensure page exists
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const UnknownPage(),
      );
  }
}

// Usage in widget
Navigator.pushNamed(context, AppRoutes.login);  // ✅ Route name matches
```

**AI Help:** *"Add a route to [PageName] in on_generate_route.dart and show me the correct import path"*

---

### "Null safety error"

**Root Cause:**
- Nullable type (`String?`) used where non-nullable expected
- Missing null check before accessing property
- Late field not initialized

**Solution:**
```dart
// ❌ Wrong: Uninitialized late field
class AuthCubit {
  late UserEntity user;  // Will crash if accessed before set
}

// ✅ Correct: Nullable with null check
class AuthCubit {
  UserEntity? user;  // Can be null, check before use
  
  void login() {
    emit(AuthLoading());
    // Only emit Success if user is not null
    if (user != null) {
      emit(AuthSuccess(user: user!));
    }
  }
}
```

**AI Help:** *"Fix null safety errors in [file name]. Assume a property might be null"*

---

## Network & API Errors

### "Failed to fetch data" or timeout

**Root Cause:**
- Network unreachable
- API endpoint incorrect
- Timeout too short
- Server down

**Debugging:**

```bash
# Check if device has internet
adb shell dumpsys connectivitymanager | grep -i "active"

# Test API endpoint manually
curl -H "Authorization: Bearer <token>" https://api.example.com/sessions

# Check Dio timeout in code
# lib/core/network/dio_client.dart
dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 30),  // ← Check this
    receiveTimeout: const Duration(seconds: 30),
  ),
);
```

**Solution:**

1. **Check network connectivity:**
   - Use `NetworkInfo` to check before requests
   - Show "No internet" UI if offline

2. **Increase timeout if needed:**
   - Ask AI: *"The API is slow. Help me increase timeouts in dio_client.dart"*

3. **Implement retry logic:**
   - Ask AI: *"Add exponential backoff retry for failed requests"*

4. **Enable network logging:**
   ```dart
   // In dio_client.dart
   dio.interceptors.add(
     LogInterceptor(
       requestBody: true,
       responseBody: true,
       logPrint: (obj) => print('[Dio] $obj'),
     ),
   );
   ```

**AI Help:** *"Debug why [endpoint name] is timing out. Check the network request flow"*

---

### "Unauthorized (401)" or "Forbidden (403)"

**Root Cause:**
- JWT token expired or invalid
- User not authenticated
- Wrong permission level

**Solution:**

1. **Check token stored correctly:**
   ```dart
   final token = await SecureStorageService().getToken();
   print('Token: $token');  // Should not be null
   ```

2. **Verify auth interceptor:**
   ```dart
   // In dio_client.dart
   dio.interceptors.add(
     QueuedInterceptorsWrapper(
       onRequest: (options, handler) async {
         final token = await _secureStorage.getToken();
         if (token != null) {
           options.headers['Authorization'] = 'Bearer $token';  // ✅ Correct format
         }
         return handler.next(options);
       },
     ),
   );
   ```

3. **Implement token refresh:**
   - Ask AI: *"The token expired. Implement refresh token logic in the unauthorized interceptor"*

4. **Force logout if unrecoverable:**
   ```dart
   if (error.response?.statusCode == 401) {
     await getIt<SessionRepository>().clearSession();
     // Redirect to login
   }
   ```

**AI Help:** *"The API returns 401. Help me implement token refresh logic"*

---

## State Management & UI Issues

### "Cubit emits state but UI doesn't update"

**Root Cause:**
- State class missing `Equatable` implementation
- State not being emitted (method not called)
- BlocBuilder not listening to correct Cubit
- Async operation not awaited

**Solution:**

```dart
// ❌ Wrong: State without Equatable
class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess({required this.user});
}

// ✅ Correct: Extends Equatable
class AuthSuccess extends AuthState {
  final UserEntity user;
  
  const AuthSuccess({required this.user});
  
  @override
  List<Object> get props => [user];  // ← UI rebuilds when user changes
}

// ❌ Wrong: Mutation instead of emission
class AuthCubit {
  late UserEntity user;
  
  void login() {
    user = fetchedUser;  // ❌ Wrong! No emission
  }
}

// ✅ Correct: Emit new state
class AuthCubit {
  Future<void> login() async {
    emit(const AuthLoading());
    try {
      final user = await _repository.signIn(...);
      emit(AuthSuccess(user: user));  // ✅ Emit state
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }
}

// ❌ Wrong: BlocBuilder listens to wrong Cubit
BlocBuilder<SessionCubit, SessionState>(  // ← Wrong Cubit!
  builder: (context, state) {
    if (state is AuthSuccess) {  // ← Won't match SessionState
      return Text(state.user.name);
    }
    return const SizedBox();
  },
)

// ✅ Correct: BlocBuilder listens to correct Cubit
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state is AuthSuccess) {
      return Text(state.user.name);
    }
    return const SizedBox();
  },
)
```

**AI Help:** *"The Cubit is running but UI doesn't update. Check if the state class is properly set up"*

---

### "setState called after dispose"

**Root Cause:**
- Async operation completes after widget disposed
- Stream/Future not canceled on dispose
- Missing bloc close in cubit stream

**Solution:**

```dart
// ✅ Correct: Cubit automatically handles dispose
// No need for dispose/cancel; Flutter's bloc handles streaming cleanly

// ❌ Common mistake: Storing async result in mutable field
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late UserEntity user;  // ❌ Mutable field

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final fetched = await repository.getUser();
    setState(() {
      user = fetched;  // ❌ Can crash if called after dispose
    });
  }
}

// ✅ Correct: Use Cubit (no setState needed)
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Text(state.user.name);
        }
        return const SizedBox();
      },
    );
  }
}
```

**AI Help:** *"I'm getting 'setState called after dispose'. Convert this StatefulWidget to use Cubit instead"*

---

### "ListView shows blank" or "Grid not rendering"

**Root Cause:**
- List is null or empty
- No height constraint for scrollable
- Item builder returning null widget

**Solution:**

```dart
// ❌ Wrong: No height constraint
Column(
  children: [
    ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, idx) => ListTile(title: Text(items[idx])),
    ),  // ← ListView has infinite height, Column doesn't constrain
  ],
)

// ✅ Correct: Expanded or Flexible wraps ListView
Column(
  children: [
    Expanded(  // ← Gives height to ListView
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, idx) => ListTile(title: Text(items[idx])),
      ),
    ),
  ],
)

// ✅ Alternative: SizedBox with explicit height
Column(
  children: [
    SizedBox(
      height: 300,  // ← Explicit height
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, idx) => ListTile(title: Text(items[idx])),
      ),
    ),
  ],
)

// ✅ Handle empty list
BlocBuilder<SessionsCubit, SessionsState>(
  builder: (context, state) {
    if (state is SessionsLoaded) {
      if (state.sessions.isEmpty) {
        return const Center(child: Text('No sessions'));  // ← Handle empty
      }
      return ListView.builder(
        itemCount: state.sessions.length,
        itemBuilder: (ctx, idx) => SessionTile(session: state.sessions[idx]),
      );
    }
    return const SizedBox();
  },
)
```

**AI Help:** *"My ListView shows blank. Help me debug [widget name]"*

---

## Cache & Persistence Errors

### "Cannot store data in Hive" or "Hive box not initialized"

**Root Cause:**
- Hive not initialized
- Box not opened
- TypeAdapter not registered

**Solution:**

```dart
// ✅ In main() before running app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive FIRST
  await HiveService.init();  // ← Must be before locatorSetup
  
  await locatorSetup();
  runApp(const SilentSpace());
}

// ✅ HiveService.init() should register adapters
// lib/core/cache/hive_service.dart
static Future<void> init() async {
  await Hive.initFlutter();

  // Register ALL adapters BEFORE opening boxes
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SessionModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(UserSettingsModelAdapter());
  }

  // Only then open boxes
  await Hive.openBox<SessionModel>(sessionBox);
  await Hive.openBox<Map<String, dynamic>>(settingsBox);
}
```

**AI Help:** *"I can't store data in Hive. Check the initialization order in main()"*

---

### "Data not persisting" or "Cache cleared unexpectedly"

**Root Cause:**
- Cache invalidated too aggressively
- Hive box cleared on logout (expected)
- Data saved to wrong box

**Solution:**

```dart
// ✅ Check cache age before returning
Future<SessionModel?> getCachedSession() async {
  final box = hiveService.getBox<SessionModel>(HiveService.sessionBox);
  final session = box.get('session_key');
  
  // Check timestamp
  final timestamp = await _getCacheTimestamp('session');
  if (timestamp != null) {
    final age = DateTime.now().difference(timestamp);
    if (age.inHours > 24) {  // ← Invalidate if > 24 hours
      await box.delete('session_key');
      return null;
    }
  }
  
  return session;
}

// ✅ Only clear on logout
Future<void> clearSession() async {
  final box = hiveService.getBox<SessionModel>(HiveService.sessionBox);
  await box.delete('session_key');  // ← Intentional clear
}
```

**AI Help:** *"Data isn't persisting. Check cache invalidation strategy"*

---

## Testing Errors

### "Test fails: 'No instance of XYZ found'"

**Root Cause:**
- Service locator not properly mocked in test
- Mock not registered with `override: true`
- Test doesn't reset between runs

**Solution:**

```dart
void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    
    // Register mock with override: true
    getIt.registerSingleton<AuthRepository>(
      mockRepository,
      override: true,  // ← Critical for tests
    );
  });

  tearDown(() {
    getIt.reset();  // ← Clear all registrations
  });

  test('AuthCubit login success', () async {
    // Arrange
    when(() => mockRepository.signIn(...))
        .thenAnswer((_) async => Right(tUserEntity));

    // Act & Assert
    final cubit = AuthCubit(signInUseCase: SignInUseCase(mockRepository));
    expect(
      cubit.stream,
      emitsInOrder([
        const AuthLoading(),
        AuthSuccess(user: tUserEntity),
      ]),
    );
    
    cubit.login();
  });
}
```

**AI Help:** *"My test is failing because of missing mocks. Help me set up service locator for tests"*

---

### "Widget test: BlocBuilder doesn't render"

**Root Cause:**
- Cubit not provided in test widget tree
- Wrong widget type for test
- MaterialApp not wrapping widget

**Solution:**

```dart
void main() {
  group('LoginPage', () {
    late MockAuthCubit mockCubit;

    setUp(() {
      mockCubit = MockAuthCubit();
    });

    testWidgets('Shows loading', (WidgetTester tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(const AuthLoading());

      // Act
      await tester.pumpWidget(
        MaterialApp(  // ← Required for Material widgets
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,  // ← Provide mock
            child: const LoginPage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

**AI Help:** *"My widget test fails. Help me properly provide the Cubit to the test widget"*

---

## Performance Issues

### "App is slow" or "Frames dropping"

**Root Cause:**
- Too many rebuilds due to missing `const` constructors
- Large lists rendered without separation
- Expensive computation in `build()`

**Solution:**

```dart
// ❌ Wrong: Rebuilds every time parent rebuilds
class SessionTile extends StatelessWidget {
  final SessionModel session;

  SessionTile({required this.session});  // ← No const

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(session.name));
  }
}

// ✅ Correct: Const constructor prevents rebuilds
class SessionTile extends StatelessWidget {
  final SessionModel session;

  const SessionTile({required this.session});  // ← Const

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(session.name));
  }
}

// Usage with const
ListView.builder(
  itemCount: sessions.length,
  itemBuilder: (ctx, idx) => const SessionTile(session: sessions[idx]),  // ← Const instance
)

// ❌ Wrong: Heavy computation in build
@override
Widget build(BuildContext context) {
  final sorted = sessions.sort((a, b) => ...);  // ❌ Every rebuild
  return ListView(...);
}

// ✅ Correct: Precompute or use selector
final sorted = sessions.toList()..sort((a, b) => ...);  // ← Precompute

@override
Widget build(BuildContext context) {
  return BlocSelector<SessionsCubit, SessionsState, List<SessionModel>>(
    selector: (state) => (state as SessionsLoaded).sessions,  // ← Only listen to this
    builder: (ctx, sessions) => ListView(...),
  );
}
```

**AI Help:** *"My app is slow. Identify performance bottlenecks in [page name]"*

---

## Firebase & Cloud Issues

### "Firebase not initialized" or "Firestore connection fails"

**Root Cause:**
- Firebase not configured in `main()`
- Google credentials missing
- Android minSdkVersion too low

**Solution:**

```dart
// ✅ Initialize Firebase first
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await HiveService.init();
  await locatorSetup();
  runApp(const SilentSpace());
}

// ✅ Check Android minSdkVersion (should be 21+)
// android/app/build.gradle.kts
android {
  compileSdk = 35
  
  defaultConfig {
    applicationId = "com.example.silent_space"
    minSdk = 21  // ← Firebase requires 21+
    targetSdk = 35
  }
}

// ✅ Check iOS deployment target (12.0+)
// ios/Podfile
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'FIREBASE_ANALYTICS_COLLECTION_ENABLED=1',
      ]
    end
  end
end
```

**AI Help:** *"Firebase isn't connecting. Check initialization and platform setup"*

---

## Git & Version Control

### "Merge conflict" in pubspec.yaml or model files

**Root Cause:**
- Two branches modified same dependencies or entities
- Concurrent changes to generated code

**Solution:**

```bash
# Step 1: Identify conflicts
git status

# Step 2: Open conflicted file and resolve (look for <<<< >>>> markers)
# vi lib/features/auth/domain/entities/user_entity.dart

# Step 3: Clean up generated files
flutter clean
flutter pub get
flutter generate_build_runner

# Step 4: Stage and commit
git add .
git commit -m "Resolve merge conflicts in pubspec.yaml"
```

**AI Help:** *"I have merge conflicts. Help me resolve conflicts in [file name]"*

---

## General Debugging Tips

**Ask AI for help using these patterns:**

1. **"Debug [feature name]"** — Explain what's broken
   - *"Debug the login flow. After clicking signin, nothing happens"*

2. **"Check [file name] for issues"** — AI reviews code
   - *"Check session_cubit.dart for state management issues"*

3. **"Implement [pattern name]"** — AI shows correct usage
   - *"Implement offline-first caching for sessions"*

4. **"Why is [error]"** — AI explains and fixes
   - *"Why am I getting 'No instance of AuthRepository found'?"*

5. **"Validate [feature] architecture"** — AI checks Clean Architecture
   - *"Validate the auth feature follows Clean Architecture"*

---

## Quick Reference: Common Fixes

| Problem | Quick Fix |
|---------|-----------|
| Type not found | Register in `service_locator.dart` |
| UI not updating | Add `@override` to `Equatable.props` |
| Hive error | Call `HiveService.init()` before `runApp()` |
| Network timeout | Check `Dio` timeout config (30s default) |
| Null safety error | Add `?` for nullable or `!` for forced unwrap (carefully) |
| Fast failed | Add mocks + `override: true` in test `setUp()` |
| Widget blank | Wrap in `Expanded` or use `SizedBox` with height |
| App slow | Add `const` to all constructors |
| Firebase error | Check `minSdk=21` and initialization order |

---

**Last Updated:** March 2026  
**Contributing:** Update this guide when you solve new problems  
**AI Help:** Always include file names and error messages when asking for help
