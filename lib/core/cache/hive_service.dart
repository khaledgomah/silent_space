import 'package:hive_flutter/hive_flutter.dart';

/// Initializes Hive and manages box lifecycle.
class HiveService {
  static const String sessionBoxName = 'sessions';

  /// Call once during app initialization.
  Future<void> init() async {
    await Hive.initFlutter();
  }

  /// Opens a typed box. Registers the adapter if not already registered.
  Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Closes all open boxes. Call on app dispose if needed.
  Future<void> closeAllBoxes() async {
    await Hive.close();
  }
}
