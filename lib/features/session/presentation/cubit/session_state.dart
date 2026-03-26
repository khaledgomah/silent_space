import 'package:equatable/equatable.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {
  const SessionInitial();
}

class SessionLoading extends SessionState {
  const SessionLoading();
}

class SessionLoaded extends SessionState {
  final List<FocusSession> sessions;

  const SessionLoaded(this.sessions);

  int get totalMinutes =>
      sessions.fold(0, (sum, s) => sum + (s.durationInSeconds ~/ 60));
  int get totalCount => sessions.length;

  int get todayMinutes {
    final now = DateTime.now();
    return sessions
        .where((s) =>
            s.startTime.year == now.year &&
            s.startTime.month == now.month &&
            s.startTime.day == now.day)
        .fold(0, (sum, s) => sum + (s.durationInSeconds ~/ 60));
  }

  int get todayCount {
    final now = DateTime.now();
    return sessions
        .where((s) =>
            s.startTime.year == now.year &&
            s.startTime.month == now.month &&
            s.startTime.day == now.day)
        .length;
  }

  List<int> get weeklyMinutes {
    final now = DateTime.now();
    final weekData = List.filled(7, 0);
    for (var i = 0; i < 7; i++) {
        final date = now.subtract(Duration(days: 6 - i));
        weekData[i] = sessions
            .where((s) =>
                s.startTime.year == date.year &&
                s.startTime.month == date.month &&
                s.startTime.day == date.day)
            .fold(0, (sum, s) => sum + (s.durationInSeconds ~/ 60));
    }
    return weekData;
  }

  @override
  List<Object?> get props => [sessions];
}

class SessionError extends SessionState {
  final String message;

  const SessionError({required this.message});

  @override
  List<Object?> get props => [message];
}
