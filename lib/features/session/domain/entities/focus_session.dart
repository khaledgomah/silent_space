import 'package:equatable/equatable.dart';

/// Pure domain entity representing a completed focus session.
class FocusSession extends Equatable {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final int durationInSeconds;
  final String category;

  const FocusSession({
    required this.id,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.durationInSeconds,
    required this.category,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        startTime,
        endTime,
        durationInSeconds,
        category,
      ];
}
