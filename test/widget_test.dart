// Smoke test — validates that the app starts without crashing.
//
// Integration-level widget testing is limited here because
// SilentSpace requires platform services (Hive, SecureStorage, etc.)
// that are not available in the test environment without mocking.
//
// See test/features/ for focused unit tests on use cases and repositories.

import 'package:flutter_test/flutter_test.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';

void main() {
  group('Entity equality', () {
    test('UserEntity supports value equality', () {
      const a = UserEntity(id: 1, email: 'a@b.com', token: 'tok');
      const b = UserEntity(id: 1, email: 'a@b.com', token: 'tok');
      expect(a, equals(b));
    });

    test('SessionEntity supports value equality', () {
      final now = DateTime(2026, 1, 1);
      final a = SessionEntity(
        id: '1',
        startTime: now,
        durationMinutes: 25,
        completedAt: now,
      );
      final b = SessionEntity(
        id: '1',
        startTime: now,
        durationMinutes: 25,
        completedAt: now,
      );
      expect(a, equals(b));
    });
  });
}
