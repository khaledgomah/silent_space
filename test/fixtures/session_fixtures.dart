import 'package:silent_space/features/session/data/models/session_model.dart';

class SessionFixtures {
  static final List<SessionModel> mockSessions = [
    SessionModel(
      id: '1',
      userId: 'user123',
      startTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      endTime: DateTime.now()
          .subtract(const Duration(days: 1, hours: 1, minutes: 15)),
      durationInSeconds: 45 * 60,
      category: 'Work',
    ),
    SessionModel(
      id: '2',
      userId: 'user123',
      startTime: DateTime.now().subtract(const Duration(hours: 5)),
      endTime: DateTime.now().subtract(const Duration(hours: 4, minutes: 35)),
      durationInSeconds: 25 * 60,
      category: 'Study',
    ),
    SessionModel(
      id: '3',
      userId: 'user123',
      startTime: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      endTime: DateTime.now().subtract(const Duration(days: 2)),
      durationInSeconds: 60 * 60,
      category: 'Exercise',
    ),
    SessionModel(
      id: '4',
      userId: 'user123',
      startTime: DateTime.now().subtract(const Duration(days: 3, minutes: 30)),
      endTime: DateTime.now().subtract(const Duration(days: 3, minutes: 15)),
      durationInSeconds: 15 * 60,
      category: 'Reading',
    ),
  ];

  static List<Map<String, dynamic>> get mockSessionsJson =>
      mockSessions.map((s) => s.toJson()).toList();
}
