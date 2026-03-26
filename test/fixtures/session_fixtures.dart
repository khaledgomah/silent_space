import 'package:silent_space/features/session/data/models/session_model.dart';

class SessionFixtures {
  static final List<SessionModel> mockSessions = [
    SessionModel(
      id: '1',
      startTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      durationMinutes: 45,
      completedAt: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 15)),
    ),
    SessionModel(
      id: '2',
      startTime: DateTime.now().subtract(const Duration(hours: 5)),
      durationMinutes: 25,
      completedAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 35)),
    ),
    SessionModel(
      id: '3',
      startTime: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      durationMinutes: 60,
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    SessionModel(
      id: '4',
      startTime: DateTime.now().subtract(const Duration(days: 3, minutes: 30)),
      durationMinutes: 15,
      completedAt: DateTime.now().subtract(const Duration(days: 3, minutes: 15)),
    ),
  ];

  static List<Map<String, dynamic>> get mockSessionsJson => 
      mockSessions.map((s) => s.toJson()).toList();
}
