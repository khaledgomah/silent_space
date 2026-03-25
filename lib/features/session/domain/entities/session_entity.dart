import 'package:equatable/equatable.dart';

/// Pure domain entity representing a completed focus session.
class SessionEntity extends Equatable {
  final String id;
  final DateTime startTime;
  final int durationMinutes;
  final DateTime completedAt;

  const SessionEntity({
    required this.id,
    required this.startTime,
    required this.durationMinutes,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [id, startTime, durationMinutes, completedAt];
}
