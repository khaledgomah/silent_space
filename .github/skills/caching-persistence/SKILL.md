---
name: caching-persistence
description: 'Configure Hive local persistence, implement caching strategies, manage offline-first patterns, and synchronize cached data. Use for storing user sessions, sessions list, offline support, and cache invalidation.'
argument-hint: 'Entity or data type to persist (e.g., session, user-settings, notifications-list)'
---

# Caching & Persistence

## When to Use
- Storing data locally with Hive
- Implementing offline-first patterns
- Caching API responses for offline access
- Persisting app settings and preferences
- Managing cache invalidation strategies
- Synchronizing local and remote data

## File Structure

```
lib/core/cache/
├── hive_service.dart        # Hive initialization + boxes
├── cache_constants.dart     # Box names, keys
└── cache_mapper.dart        # Data type mappings

features/*/data/datasources/
├── *_local_data_source.dart # Hive operations (read/write)
└── *_remote_data_source.dart # API operations
```

## Step-by-Step Setup

### 1. **Initialize Hive Service**

Create `lib/core/cache/hive_service.dart`:

```dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:silent_space/features/*/data/models/*.dart';  // Import all models

class HiveService {
  static const String sessionBox = 'session_box';
  static const String settingsBox = 'settings_box';
  static const String sessionsListBox = 'sessions_list_box';
  static const String cacheMetaBox = 'cache_meta_box';

  /// Initialize Hive and register adapters
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register TypeAdapters for models
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SessionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserSettingsModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(NotificationModelAdapter());
    }

    // Open boxes
    await Hive.openBox<SessionModel>(sessionBox);
    await Hive.openBox<Map<String, dynamic>>(settingsBox);
    await Hive.openBox<List<SessionModel>>(sessionsListBox);
    await Hive.openBox<Map<String, dynamic>>(cacheMetaBox);
  }

  /// Get box instance
  static Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  /// Close all boxes (on app logout)
  static Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(sessionBox);
    await Hive.deleteBoxFromDisk(settingsBox);
    await Hive.deleteBoxFromDisk(sessionsListBox);
    await Hive.deleteBoxFromDisk(cacheMetaBox);
  }
}
```

### 2. **Create Local Data Source with Caching**

```dart
abstract class SessionLocalDataSource {
  Future<SessionModel?> getCachedSession();
  Future<void> cacheSession(SessionModel session);
  Future<void> clearSession();
  Future<DateTime?> getCacheTimestamp(String key);
  Future<void> setCacheTimestamp(String key);
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  final HiveService hiveService;

  SessionLocalDataSourceImpl({required this.hiveService});

  @override
  Future<SessionModel?> getCachedSession() async {
    try {
      final box = hiveService.getBox<SessionModel>(HiveService.sessionBox);
      return box.get('session_key');
    } catch (e) {
      throw CacheException(message: 'Error reading cache: $e');
    }
  }

  @override
  Future<void> cacheSession(SessionModel session) async {
    try {
      final box = hiveService.getBox<SessionModel>(HiveService.sessionBox);
      await box.put('session_key', session);
      
      // Store cache timestamp
      await setCacheTimestamp('session_timestamp');
    } catch (e) {
      throw CacheException(message: 'Error caching session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      final box = hiveService.getBox<SessionModel>(HiveService.sessionBox);
      await box.delete('session_key');
      
      // Clear timestamp
      final metaBox = hiveService.getBox<Map>(HiveService.cacheMetaBox);
      await metaBox.delete('session_timestamp');
    } catch (e) {
      throw CacheException(message: 'Error clearing cache: $e');
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp(String key) async {
    try {
      final metaBox = hiveService.getBox<Map>(HiveService.cacheMetaBox);
      final timestamp = metaBox.get(key);
      return timestamp != null ? DateTime.parse(timestamp) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setCacheTimestamp(String key) async {
    try {
      final metaBox = hiveService.getBox<Map>(HiveService.cacheMetaBox);
      await metaBox.put(key, DateTime.now().toIso8601String());
    } catch (e) {
      // Non-critical, ignore
    }
  }
}
```

### 3. **Implement Repository with Offline-First**

```dart
class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;
  final SessionLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SessionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SessionModel>> getCurrentSession() async {
    // Try local cache first
    try {
      final cached = await localDataSource.getCachedSession();
      if (cached != null) {
        // Check cache age (e.g., invalidate if > 1 hour)
        final timestamp = await localDataSource.getCacheTimestamp('session_timestamp');
        final age = DateTime.now().difference(timestamp ?? DateTime(2000));
        
        if (age.inHours < 1) {
          return Right(cached);  // Cache is fresh
        }
      }
    } catch (e) {
      // Cache read failed, continue
    }

    // If offline, return cached if available
    if (!await networkInfo.isConnected) {
      final cached = await localDataSource.getCachedSession();
      if (cached != null) {
        return Right(cached);
      }
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    // Fetch from remote
    try {
      final session = await remoteDataSource.getCurrentSession();
      
      // Cache locally
      await localDataSource.cacheSession(session);
      
      return Right(session);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SessionModel>> startSession(SessionStartParams params) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final session = await remoteDataSource.startSession(params);
      
      // Cache immediately
      await localDataSource.cacheSession(session);
      
      return Right(session);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearSession() async {
    try {
      await localDataSource.clearSession();
      
      // Only try to log out remotely if online
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.logout();
        } catch (e) {
          // Non-critical, continue clearing locally
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Error clearing session'));
    }
  }
}
```

## Caching Strategies

### Strategy 1: Cache-Then-Network

```dart
/// Load cached data immediately, then fetch fresh data
Future<Either<Failure, List<SessionModel>>> getSessions() async {
  // Return cached immediately
  try {
    final cached = await localDataSource.getCachedSessions();
    if (cached.isNotEmpty) {
      emit(SessionsLoaded(sessions: cached));
    }
  } catch (e) {
    // Ignore cache read errors
  }

  // Fetch fresh data in background
  if (await networkInfo.isConnected) {
    try {
      final sessions = await remoteDataSource.getSessions();
      await localDataSource.cacheSessions(sessions);
      return Right(sessions);
    } catch (e) {
      // If network fails, return cached
      try {
        final cached = await localDataSource.getCachedSessions();
        if (cached.isNotEmpty) return Right(cached);
      } catch (_) {}
      return Left(ServerFailure(message: 'Failed to load sessions'));
    }
  }

  // Offline, return cached
  try {
    final cached = await localDataSource.getCachedSessions();
    return Right(cached);
  } catch (e) {
    return Left(NetworkFailure(message: 'No internet'));
  }
}
```

### Strategy 2: Smart Cache Invalidation

```dart
class CacheManager {
  final HiveService hiveService;
  
  // Cache duration for different data types
  static const Duration userCacheDuration = Duration(hours: 24);
  static const Duration sessionsCacheDuration = Duration(minutes: 30);
  static const Duration settingsCacheDuration = Duration(days: 7);

  CacheManager({required this.hiveService});

  /// Check if cache is still valid
  bool isCacheValid(String cacheKey, {required Duration maxAge}) {
    try {
      final metaBox = hiveService.getBox<Map>(HiveService.cacheMetaBox);
      final timestamp = metaBox.get('${cacheKey}_timestamp');
      
      if (timestamp == null) return false;
      
      final cachedAt = DateTime.parse(timestamp);
      final age = DateTime.now().difference(cachedAt);
      
      return age < maxAge;
    } catch (e) {
      return false;
    }
  }

  /// Invalidate specific cache
  Future<void> invalidateCache(String cacheKey) async {
    try {
      final metaBox = hiveService.getBox<Map>(HiveService.cacheMetaBox);
      await metaBox.delete('${cacheKey}_timestamp');
    } catch (e) {
      // Ignore
    }
  }

  /// Invalidate all caches
  Future<void> invalidateAllCaches() async {
    try {
      final metaBox = hiveService.getBox<Map>(HiveService.cacheMetaBox);
      await metaBox.clear();
    } catch (e) {
      // Ignore
    }
  }
}
```

### Strategy 3: Optimistic Updates (Offline-First)

```dart
/// Update locally first, sync to remote when online
Future<Either<Failure, SessionModel>> updateSession(
  String sessionId,
  SessionUpdateParams params,
) async {
  // Update locally immediately
  try {
    final updated = SessionModel(
      id: sessionId,
      // ... apply params
    );
    await localDataSource.cacheSession(updated);
    emit(SessionUpdated(session: updated));
  } catch (e) {
    return Left(CacheFailure(message: 'Failed to update locally'));
  }

  // Sync to remote if online
  if (await networkInfo.isConnected) {
    try {
      final synced = await remoteDataSource.updateSession(sessionId, params);
      // Verify response matches local
      await localDataSource.cacheSession(synced);
      return Right(synced);
    } on ServerException catch (e) {
      // Rollback to previous state
      emit(SessionUpdateFailed(error: e.message));
      return Left(ServerFailure(message: e.message));
    }
  }

  // Mark for sync later
  await _markPendingSync('session_update', sessionId);
  return Right(await localDataSource.getCachedSession());
}

Future<void> _markPendingSync(String operation, String entityId) async {
  final syncBox = hiveService.getBox<Map>(HiveService.cacheMetaBox);
  final pending = syncBox.get('pending_sync') as List? ?? [];
  pending.add({'op': operation, 'id': entityId, 'timestamp': DateTime.now().toIso8601String()});
  await syncBox.put('pending_sync', pending);
}

/// Sync pending operations when online (background task)
Future<void> syncPendingOperations() async {
  if (!await networkInfo.isConnected) return;

  try {
    final syncBox = hiveService.getBox<Map>(HiveService.cacheMetaBox);
    final pending = syncBox.get('pending_sync') as List? ?? [];

    for (final op in pending) {
      try {
        if (op['op'] == 'session_update') {
          final session = await localDataSource.getCachedSession();
          await remoteDataSource.updateSession(op['id'], session);
        }
      } catch (e) {
        // Log and continue
        print('Sync failed for ${op['op']}: $e');
      }
    }

    // Clear pending after sync
    await syncBox.put('pending_sync', []);
  } catch (e) {
    print('Sync error: $e');
  }
}
```

### Strategy 4: Pagination Caching

```dart
abstract class SessionListLocalDataSource {
  Future<List<SessionModel>> getCachedSessions(int page);
  Future<void> cacheSessions(List<SessionModel> sessions, int page);
  Future<void> clearSessionsCache();
}

class SessionListLocalDataSourceImpl implements SessionListLocalDataSource {
  final HiveService hiveService;

  @override
  Future<List<SessionModel>> getCachedSessions(int page) async {
    try {
      final box = hiveService.getBox<List>(HiveService.sessionsListBox);
      final cached = box.get('page_$page') as List<SessionModel>? ?? [];
      return cached;
    } catch (e) {
      throw CacheException(message: 'Error reading paginated cache');
    }
  }

  @override
  Future<void> cacheSessions(List<SessionModel> sessions, int page) async {
    try {
      final box = hiveService.getBox<List>(HiveService.sessionsListBox);
      await box.put('page_$page', sessions);
    } catch (e) {
      throw CacheException(message: 'Error caching page');
    }
  }

  @override
  Future<void> clearSessionsCache() async {
    try {
      final box = hiveService.getBox<List>(HiveService.sessionsListBox);
      await box.clear();
    } catch (e) {
      throw CacheException(message: 'Error clearing cache');
    }
  }
}
```

## Testing Cache Operations

```dart
void main() {
  late MockHiveService mockHive;
  late SessionLocalDataSourceImpl dataSource;

  setUp(() {
    mockHive = MockHiveService();
    dataSource = SessionLocalDataSourceImpl(hiveService: mockHive);
  });

  test('getCachedSession_WhenDataExists_ReturnsSession', () async {
    // Arrange
    final tSession = SessionModel(
      id: '1',
      focusTime: 60,
      breakTime: 15,
    );
    when(() => mockHive.getBox(HiveService.sessionBox))
        .thenReturn(mockBox);
    when(() => mockBox.get('session_key')).thenReturn(tSession);

    // Act
    final result = await dataSource.getCachedSession();

    // Assert
    expect(result, equals(tSession));
  });

  test('cacheSession_StoresSessionAndTimestamp', () async {
    // Arrange
    final tSession = SessionModel(
      id: '1',
      focusTime: 60,
      breakTime: 15,
    );
    when(() => mockHive.getBox(HiveService.sessionBox))
        .thenReturn(mockSessionBox);
    when(() => mockHive.getBox(HiveService.cacheMetaBox))
        .thenReturn(mockMetaBox);
    when(() => mockSessionBox.put('session_key', tSession))
        .thenAnswer((_) async => null);
    when(() => mockMetaBox.put(
          'session_timestamp',
          any(that: isA<String>()),
        )).thenAnswer((_) async => null);

    // Act
    await dataSource.cacheSession(tSession);

    // Assert
    verify(() => mockSessionBox.put('session_key', tSession)).called(1);
    verify(() => mockMetaBox.put(
          'session_timestamp',
          any(that: isA<String>()),
        )).called(1);
  });

  test('getCachedSession_WhenBoxEmpty_ReturnsNull', () async {
    // Arrange
    when(() => mockHive.getBox(HiveService.sessionBox))
        .thenReturn(mockBox);
    when(() => mockBox.get('session_key')).thenReturn(null);

    // Act
    final result = await dataSource.getCachedSession();

    // Assert
    expect(result, isNull);
  });
}
```

## Register in Service Locator

Update `lib/core/utils/service_locator.dart`:

```dart
// Initialize Hive on startup
await HiveService.init();

// Cache layer
getIt.registerLazySingleton<HiveService>(
  () => HiveService(),
);

getIt.registerLazySingleton<CacheManager>(
  () => CacheManager(hiveService: getIt<HiveService>()),
);

// Local data sources
getIt.registerLazySingleton<SessionLocalDataSource>(
  () => SessionLocalDataSourceImpl(hiveService: getIt<HiveService>()),
);

getIt.registerLazySingleton<UserSettingsLocalDataSource>(
  () => UserSettingsLocalDataSourceImpl(hiveService: getIt<HiveService>()),
);
```

## Caching Checklist

- [ ] Hive service initialized in `main()` before running app
- [ ] All models have generated `@HiveType()` adapters
- [ ] Adapters registered with unique IDs
- [ ] Local data sources separate from remote sources
- [ ] Cache strategy defined (cache-first, network-first, offline-first)
- [ ] Cache invalidation implemented
- [ ] Timestamp tracking for cache age
- [ ] Offline support tested
- [ ] Sync pending operations on connectivity
- [ ] Clear cache on logout

## Best Practices

✅ **Initialize Hive early** — Call `HiveService.init()` before running app
✅ **Separate concerns** — Local and remote sources in different classes
✅ **Track cache age** — Store timestamps to invalidate stale data
✅ **Handle offline gracefully** — Return cached or show "offline" UI
✅ **Clear on logout** — Privacy: remove all cached user data
✅ **Test cache strategy** — Unit test repository with mock caches
✅ **Implement smart invalidation** — Don't cache forever
✅ **Sync optimistically** — Update UI before remote completes

## Anti-Patterns

❌ **No cache invalidation** — Stale data forever
❌ **Caching sensitive data** — User tokens, passwords
❌ **No offline support** — App crashes without internet
❌ **Single data source** — Can't test cache independently
❌ **No cache timestamps** — Can't determine if data is fresh
❌ **Clearing cache on every restart** — Defeats the purpose
❌ **Ignoring cache errors** — Silent failures are hard to debug
❌ **Not testing offline scenarios** — Real users go offline
