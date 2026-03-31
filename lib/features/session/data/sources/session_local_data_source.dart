import 'package:hive/hive.dart';
import 'package:silent_space/core/cache/hive_service.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/features/session/data/models/session_model.dart';

/// Local data source for session CRUD via Hive.
abstract class SessionLocalDataSource {
  Future<void> saveSession(SessionModel session);
  Future<List<SessionModel>> getSessions();
  Future<void> clearSessions();
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  SessionLocalDataSourceImpl({required this.hiveService});
  final HiveService hiveService;

  Future<Box<SessionModel>> get _box =>
      hiveService.openBox<SessionModel>(HiveService.sessionBoxName);

  @override
  Future<void> saveSession(SessionModel session) async {
    try {
      final box = await _box;
      await box.put(session.id, session);
    } catch (e) {
      throw CacheException(message: 'Failed to save session locally: $e');
    }
  }

  @override
  Future<List<SessionModel>> getSessions() async {
    try {
      final box = await _box;
      return box.values.toList()..sort((a, b) => b.startTime.compareTo(a.startTime));
    } catch (e) {
      throw CacheException(message: 'Failed to load local sessions: $e');
    }
  }

  @override
  Future<void> clearSessions() async {
    try {
      final box = await _box;
      await box.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear local sessions: $e');
    }
  }
}
