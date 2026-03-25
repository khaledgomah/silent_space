import 'package:equatable/equatable.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionLoaded extends SessionState {
  final List<SessionEntity> sessions;

  // ── Today stats ──
  final int todayMinutes;
  final int todayCount;

  // ── All-time stats ──
  final int totalMinutes;
  final int totalCount;

  // ── Weekly breakdown (last 7 days, index 0 = 6 days ago, 6 = today) ──
  final List<int> weeklyMinutes;

  const SessionLoaded._({
    required this.sessions,
    required this.todayMinutes,
    required this.todayCount,
    required this.totalMinutes,
    required this.totalCount,
    required this.weeklyMinutes,
  });

  factory SessionLoaded({required List<SessionEntity> sessions}) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // Today
    final todaySessions = sessions
        .where((s) => s.completedAt.isAfter(todayStart))
        .toList();

    // Weekly (last 7 days)
    final weekly = List<int>.filled(7, 0);
    for (final session in sessions) {
      final diff = now.difference(session.completedAt).inDays;
      if (diff >= 0 && diff < 7) {
        weekly[6 - diff] += session.durationMinutes;
      }
    }

    return SessionLoaded._(
      sessions: sessions,
      todayMinutes: todaySessions.fold(0, (sum, s) => sum + s.durationMinutes),
      todayCount: todaySessions.length,
      totalMinutes: sessions.fold(0, (sum, s) => sum + s.durationMinutes),
      totalCount: sessions.length,
      weeklyMinutes: weekly,
    );
  }

  @override
  List<Object> get props => [
        sessions,
        todayMinutes,
        todayCount,
        totalMinutes,
        totalCount,
        weeklyMinutes,
      ];
}

class SessionError extends SessionState {
  final String message;

  const SessionError({required this.message});

  @override
  List<Object> get props => [message];
}
